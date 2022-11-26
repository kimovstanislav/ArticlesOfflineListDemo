//
//  ArticlesListViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 20.11.22.
//

import Foundation
import Combine

class ArticlesListViewModel: BaseViewModel {
    private var localDataClient: ILocalData!
    private var apiClient: IVSAPI!
    
    @Published var viewState: ViewState = .loading
    
    var retryCount = 0
    let maxNumberOfRetries = 3
    let retryInterval = 2.0
    
    // TODO: make sure we handle it correctly
    // TODO: split to server and local?
    // TODO: cancel before starting a new request?
    private var cancellables: Set<AnyCancellable> = []
    
    init(localDataClient: ILocalData, apiClient: IVSAPI) {
        super.init()
        self.localDataClient = localDataClient
        self.apiClient = apiClient
        handleEvent(.onAppear)
    }
    
    // TODO: create articles var and tie output to it, then on change call this function. For nicer Combine code?
    private func updateArticlesList(_ articles: [Article]) {
        if articles.isEmpty {
            setViewState(.showEmptyList)
        }
        else {
            setViewState(.showArticles(articles: articles))
        }
    }
    
    private func showLoading() {
        setViewState(.loading)
    }
    
    private func setViewState(_ state: ViewState) {
        DispatchQueue.main.async {
            self.viewState = state
        }
    }
}


// MARK: - Load from local storage

extension ArticlesListViewModel {
    private func loadArticlesFromLocalData() {
        Task { [weak self] in
            do {
                let articles = try await localDataClient.getArticles()
                self?.handleEvent(.onLocalArticlesLoaded(articles))
            }
            catch let error as VSError  {
                self?.handleEvent(.onFailedToLoadLocalArticles(error))
            }
        }
    }
    
    private func writeArticlesToLocalData(_ articles: [Article]) {
        Task { [weak self] in
            do {
                try await localDataClient.writeArticles(articles: articles)
                self?.handleEvent(.onArticlesSavedToLocalData(articles))
            }
            catch let error as VSError {
                self?.handleEvent(.onFailedToSaveArticlesToLocalData(articles, error))
            }
        }
    }
}


// MARK: - Load from server

extension ArticlesListViewModel {
    private func loadArticlesFromServer() {
        apiClient.articlesList().sink { [weak self] completion in
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
            // And display an alert for the error for failing to load articles from API.
            DispatchQueue.main.async {
                self.showAlert(title: VSStrings.Error.API.title, message: VSStrings.Error.API.loadingArticlesFromServerErrorMessage)
            }
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
