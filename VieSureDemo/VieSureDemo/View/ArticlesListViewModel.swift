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
        // TODO: first load locally stored articles, so they can be displayed right away. Then load from API and refresh the data.
        loadArticlesFromServer()
    }
    
    func reloadArticles() {
        // On reload not displaying loading. Just update the UI when there is new data.
        loadArticlesFromServer()
    }
    
    private func loadArticlesFromServer() {
        NetworkManager.shared.getArticles { result in
            switch result {
            case let .success(articles):
                self.processArticles(articles)
            case let .failure(error):
                // TODO: handle reloading 3 times with 2 seconds interval on internet/server failure later.
                DispatchQueue.main.async {
                    self.viewState = .showError(errorMessage: error.localizedDescription)
                }
            }
        }
    }
    
    private func processArticles(_ articles: [APIModel.Response.Article]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let sortedArticles = articles.sorted { article1, article2 in
            guard let date1 = dateFormatter.date(from: article1.release_date), let date2 = dateFormatter.date(from: article2.release_date) else {
                unexpectedCodePath(message: "Wrong article date format.")
            }
            return date1 < date2
        }
        DispatchQueue.main.async {
            self.viewState = .showArticles(articles: sortedArticles)
        }
    }
}
