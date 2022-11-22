//
//  ArticlesListViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 20.11.22.
//

import Foundation

// TODO: add a data object for article (almost the same as APIModel.Response.Article). Create data layer.
class ArticlesListViewModel: ObservableObject {
    enum ViewState {
        case loading
        case showArticles(articles: [APIModel.Response.Article])
        case showError(errorMessage: String)
    }
    @Published var viewState: ViewState = .loading
    
    init() {
        loadInitialArticles()
    }
    
    
    // MARK: - Load from local storage
    
    private func loadInitialArticles() {
        // First load locally stored articles, so they can be displayed right away. Then load from API and refresh the data.
        loadArticlesFromLocalData { [weak self] in
            guard let self = self else { return }
            self.loadArticlesFromServer()
        }
    }
    
    private func loadArticlesFromLocalData(completion: @escaping VoidClosure) {
        LocalDataManager.shared.getArticles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(articles):
                DispatchQueue.main.async {
                    self.viewState = .showArticles(articles: articles)
                    completion()
                }
            case let .failure(error):
                // Don't care for error, if failed to load local, just keep displaying loading, will still be loaded from Server.
                // But can log the error here still, if we had logging.
                print("Error loading local articles: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.viewState = .loading
                    completion()
                }
            }
        }
    }
    
    private func writeArticlesToLocalData(_ articles: [APIModel.Response.Article], completion: @escaping VoidClosure) {
        LocalDataManager.shared.writeArticles(articles: articles) { result in
            switch result {
            case .success():
                completion()
            case let .failure(error):
                // Don't actually care if it succeeded or not, no difference for the UI, user needs not know.
                // But can log the error here still, if we had logging.
                print("Error writing to local articles: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    
    // MARK: - Load from server
    
    private func reloadArticlesFromServer() {
        // On reload not displaying loading. Just update the UI when there is new data.
        loadArticlesFromServer()
    }
    
    private func loadArticlesFromServer() {
        NetworkManager.shared.getArticles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(articles):
                self.processLoadedArticles(articles)
            case let .failure(error):
                // TODO: handle reloading 3 times with 2 seconds interval on internet/server failure later.
                DispatchQueue.main.async {
                    self.viewState = .showError(errorMessage: error.localizedDescription)
                }
            }
        }
    }
    
    private func processLoadedArticles(_ articles: [APIModel.Response.Article]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let sortedArticles = articles.sorted { article1, article2 in
            guard let date1 = dateFormatter.date(from: article1.release_date), let date2 = dateFormatter.date(from: article2.release_date) else {
                unexpectedCodePath(message: "Wrong article date format.")
            }
            return date1 < date2
        }
        writeArticlesToLocalData(sortedArticles) { [weak self] in
            guard let self = self else { return }
            self.viewState = .showArticles(articles: sortedArticles)
        }
    }
}
