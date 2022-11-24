//
//  ArticlesListViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 20.11.22.
//

import Foundation
import Combine

class ArticlesListViewModel: BaseViewModel {
    enum ViewState {
        case loading
        case showEmptyList
        case showArticles(articles: [Article])
        // We don't use an error state actually, should be enough to display an alert and then a local/empty list.
        case showError(errorMessage: String)
    }
    @Published var viewState: ViewState = .loading
    
    var retryCount = 0
    let maxNumberOfRetries = 3
    let retryInterval = 2.0
    
    // TODO: make sure we handle it correctly
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        loadInitialArticles()
    }
    
    private func updateArticlesList(_ articles: [Article]) {
        if articles.isEmpty {
            self.viewState = .showEmptyList
        }
        else {
            self.viewState = .showArticles(articles: articles)
        }
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
                    self.updateArticlesList(articles)
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
    
    private func writeArticlesToLocalData(_ articles: [Article], completion: @escaping VoidClosure) {
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
    
    // TODO: add pull to refresh UI and use this function. Just nice to have.
    private func reloadArticlesFromServer() {
        // On reload not displaying loading. Just update the UI when there is new data.
        loadArticlesFromServer()
    }
    
    private func loadArticlesFromServer() {
        NetworkManager.shared.articlesList().sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.handleGetApiArticlesFailure(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] articles in
            let articles: [Article] = articles.map({ Article(apiResponse: $0) })
            self?.handleGetApiArticlesSuccess(articles)
        }.store(in: &cancellables)
    }
    
    private func handleGetApiArticlesSuccess(_ articles: [Article]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.monthDayYear
        let sortedArticles = articles.sorted { article1, article2 in
            guard let date1 = dateFormatter.date(from: article1.releaseDate), let date2 = dateFormatter.date(from: article2.releaseDate) else {
                unexpectedCodePath(message: "Wrong article date format.")
            }
            return date1 < date2
        }
        writeArticlesToLocalData(sortedArticles) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateArticlesList(sortedArticles)
            }
        }
    }
    
    // TODO: will know if it works properly with retry after creating unit tests.
    private func handleGetApiArticlesFailure(_ error: VSError) {
        if error.isDataSynchronizationError == true && retryCount < maxNumberOfRetries {
            retryCount += 1
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + retryInterval) { [weak self] in
                self?.loadArticlesFromServer()
            }
        }
        else {
            retryCount = 0
            // If local data exists, show it (if not, we still show an empty list).
            loadArticlesFromLocalData { }
        }
    }
}
