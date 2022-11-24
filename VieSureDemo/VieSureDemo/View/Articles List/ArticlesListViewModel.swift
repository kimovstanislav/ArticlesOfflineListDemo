//
//  ArticlesListViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 20.11.22.
//

import Foundation
import Combine

class ArticlesListViewModel: BaseViewModel {
    @Published var viewState: ViewState = .loading
    
    var retryCount = 0
    let maxNumberOfRetries = 3
    let retryInterval = 2.0
    
    // TODO: make sure we handle it correctly
    // TODO: split to server and local?
    // TODO: cancel before starting a new request?
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        handleEvent(.onAppear)
    }
    
    // TODO: create articles var and tie output to it, then on change call this function. For nicer Combine code?
    private func updateArticlesList(_ articles: [Article]) {
        if articles.isEmpty {
            viewState = .showEmptyList
        }
        else {
            viewState = .showArticles(articles: articles)
        }
    }
    
    private func showLoading() {
        viewState = .loading
    }
}


// MARK: - Load from local storage

extension ArticlesListViewModel {
    private func loadArticlesFromLocalData() {
        LocalDataManager.shared.getArticles().sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.handleEvent(.onFailedToLoadLocalArticles(error))
            case .finished:
                break
            }
        } receiveValue: { [weak self] articles in
            self?.handleEvent(.onLocalArticlesLoaded(articles))
        }.store(in: &cancellables)
    }
    
    private func writeArticlesToLocalData(_ articles: [Article]) {
        LocalDataManager.shared.writeArticles(articles: articles).sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.handleEvent(.onFailedToSaveArticlesToLocalData(articles, error))
            case .finished:
                self?.handleEvent(.onArticlesSavedToLocalData(articles))
            }
        } receiveValue: {
            // Nothing
        }.store(in: &cancellables)
    }
}


// MARK: - Load from server

extension ArticlesListViewModel {
    private func loadArticlesFromServer() {
        NetworkManager.shared.articlesList().sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.handleEvent(.onFailedToLoadApiArticles(error))
            case .finished:
                break
            }
        } receiveValue: { [weak self] articles in
            self?.handleEvent(.onApiArticlesLoaded(articles))
        }.store(in: &cancellables)
    }
}


// MARK: - Handle API response

extension ArticlesListViewModel {
    private func handleGetApiArticlesSuccess(_ apiArticles: [APIModel.Response.Article]) {
        retryCount = 0
        let articles: [Article] = apiArticles.map({ Article(apiResponse: $0) })
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.monthDayYear
        let sortedArticles = articles.sorted { article1, article2 in
            guard let date1 = dateFormatter.date(from: article1.releaseDate), let date2 = dateFormatter.date(from: article2.releaseDate) else {
                unexpectedCodePath(message: "Wrong article date format.")
            }
            return date1 < date2
        }
        writeArticlesToLocalData(sortedArticles)
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
            loadArticlesFromLocalData()
            // TODO: display error alert that failed to load articles from API.
        }
    }
}


// MARK: - States + Events

extension ArticlesListViewModel {
    enum ViewState {
        case loading
        case showEmptyList
        case showArticles(articles: [Article])
        // We don't use an error state actually, should be enough to display an alert and then a local/empty list.
        case showError(errorMessage: String)
    }
    
    enum Event {
        /// UI lifecycle
        case onAppear
        
        /// User input
        case onSelectArticle(Article)
        case onReloadArticles
        
        /// Internal
        /// Load local
        case onLocalArticlesLoaded([Article]?)
        case onFailedToLoadLocalArticles(VSError)
        
        /// Load API
        case onApiArticlesLoaded([APIModel.Response.Article])
        case onFailedToLoadApiArticles(VSError)
        
        /// Save to local
        case onArticlesSavedToLocalData([Article])
        case onFailedToSaveArticlesToLocalData([Article], VSError)
    }
    
    func handleEvent(_ event: Event) {
        switch event {
        /// UI lifecycle
        case .onAppear:
            loadArticlesFromLocalData()
            
        /// User input
        case let .onSelectArticle(article):
            print("TODO: display fullscreen article: \(article.title)")
            break
            
        case .onReloadArticles:
            break
            
        /// Internal
        /// Load local
        case let .onLocalArticlesLoaded(articles):
            if let loadedArticles = articles {
                updateArticlesList(loadedArticles)
            }
            else {
                showLoading()
            }
            loadArticlesFromServer()
            
        case let .onFailedToLoadLocalArticles(error):
            // Don't care for error, if failed to load local, will still be loaded from Server.
            ErrorLogger.logError(error)
            loadArticlesFromServer()
            
        /// Load API
        case let .onApiArticlesLoaded(articles):
            handleGetApiArticlesSuccess(articles)
            
        case let .onFailedToLoadApiArticles(error):
            handleGetApiArticlesFailure(error)
            
        /// Save to local
        case let .onArticlesSavedToLocalData(articles):
            updateArticlesList(articles)
            
        case let .onFailedToSaveArticlesToLocalData(articles, error):
            // Don't care for error, if failed to save to local data. Still display the loaded articles
            ErrorLogger.logError(error)
            updateArticlesList(articles)
        }
    }
}
