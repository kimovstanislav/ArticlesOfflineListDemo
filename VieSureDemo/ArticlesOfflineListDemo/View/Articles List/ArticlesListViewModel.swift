//
//  ArticlesListViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 20.11.22.
//

import Foundation
import Combine

class ArticlesListViewModel: BaseViewModel {
    private let localDataClient: ILocalData
    private let apiClient: IVSAPI
    
    @Published var viewState: ViewState = .loading
    
    var retryCount = 0
    let maxNumberOfRetries = 3
    let retryInterval = 2.0
    
    init(localDataClient: ILocalData, apiClient: IVSAPI) {
        self.localDataClient = localDataClient
        self.apiClient = apiClient
        super.init()
        handleEvent(.onAppear) 
    }
    
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
        Task { [weak self] in
            do {
                let articles = try await apiClient.loadArticlesList()
                self?.handleEvent(.onApiArticlesLoaded(articles))
            }
            catch let error as VSError  {
                self?.handleEvent(.onFailedToLoadApiArticles(error))
            }
        }
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
    
    private func handleGetApiArticlesFailure(_ error: VSError) {
        if error.isDataSynchronizationError == true && retryCount < maxNumberOfRetries {
            retryCount += 1
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + retryInterval) { [weak self] in
                self?.loadArticlesFromServer()
            }
        }
        else {
            retryCount = 0
            // If any data is displayed, do nothing. If loading is displayed (no data available) - go to error state.
            if viewState == .loading {
                setViewState(.showError(errorMessage: VSStrings.Error.API.loadingArticlesFromServerErrorMessage))
            }
            // And display an alert for the API error.
            self.processError(error)
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

extension ArticlesListViewModel.ViewState: Equatable {
    static func ==(lhs: ArticlesListViewModel.ViewState, rhs: ArticlesListViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
            
        case (.showEmptyList, .showEmptyList):
            return true
            
        case (let .showArticles(articles1), let .showArticles(articles2)):
            return articles1.sorted { a, b in a.id < b.id } == articles2.sorted { a, b in a.id < b.id }
            
        case (let .showError(error1), let .showError(error2)):
            return error1 == error2

        default:
            return false
        }
    }
}
