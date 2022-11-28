//
//  ArticlesListTest.swift
//  VieSureDemoTests
//
//  Created by Stanislav Kimov on 25.11.22.
//

import XCTest
@testable import VieSureDemo
import Combine

final class ArticlesListTest: XCTestCase {
    var localDataClient: ILocalData = LocalDataClient()
   
    private var bag: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        localDataClient.clearArticles()
    }

    // A bit rought, could refactor some code for less copy-paste, but it's ok for unit tests. Works fine.
    func testLoadArticles() throws {
        let expectation = self.expectation(description: "States")
        
        let apiClient = MockAPIClient()
        let viewModel = ArticlesListViewModel(localDataClient: localDataClient, apiClient: apiClient)
        let apiArticles = try apiClient.loadSyncArticlesList()
        let toCompareArticles: [Article] = apiArticles.map({ Article(apiResponse: $0) })
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.showArticles(articles: toCompareArticles)]
        var step: Int = 0
        
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadArticlesFailingLocal() throws {
        let expectation = self.expectation(description: "States")
        
        let localDataFailingClient = FailingLocalDataClient()
        let apiClient = MockAPIClient()
        let viewModel = ArticlesListViewModel(localDataClient: localDataFailingClient, apiClient: apiClient)
        let apiArticles = try apiClient.loadSyncArticlesList()
        let toCompareArticles: [Article] = apiArticles.map({ Article(apiResponse: $0) })
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.showArticles(articles: toCompareArticles)]
        var step: Int = 0
        
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadArticlesFailingAPI() throws {
        let expectation = self.expectation(description: "States")
        
        let apiClient = FailingAPIClient()
        let viewModel = ArticlesListViewModel(localDataClient: localDataClient, apiClient: apiClient)
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.loading, .showError(errorMessage: VSStrings.Error.API.loadingArticlesFromServerErrorMessage)]
        var step: Int = 0
        
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadArticlesFailingBoth() throws {
        let expectation = self.expectation(description: "States")
        
        let localDataFailingClient = FailingLocalDataClient()
        let apiClient = FailingAPIClient()
        let viewModel = ArticlesListViewModel(localDataClient: localDataFailingClient, apiClient: apiClient)
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, .showError(errorMessage: VSStrings.Error.API.loadingArticlesFromServerErrorMessage)]
        var step: Int = 0
        
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadArticlesFailingApiWithRetryState() throws {
        let expectation = self.expectation(description: "States")
        
        let localDataFailingClient = FailingLocalDataClient()
        let apiClient = FailingAPIClient()
        apiClient.failingError = VSError(apiError: VSError.unknown, code: HTTPStatusCode.internalServerError.rawValue, title: VSStrings.Error.API.internalServerErrorTitle, message: VSStrings.Error.API.internalServerErrorMessage)
        let viewModel = ArticlesListViewModel(localDataClient: localDataFailingClient, apiClient: apiClient)
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, .showError(errorMessage: VSStrings.Error.API.loadingArticlesFromServerErrorMessage)]
        var step: Int = 0
        
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // 3 retrys with 2s delay is > 5s, must timeout
    func testLoadArticlesFailingApiWithRetryTime() throws {
        let expectation = self.expectation(description: "States")
        expectation.isInverted = true
        
        let localDataFailingClient = FailingLocalDataClient()
        let apiClient = FailingAPIClient()
        apiClient.failingError = VSError(apiError: VSError.unknown, code: HTTPStatusCode.internalServerError.rawValue, title: VSStrings.Error.API.internalServerErrorTitle, message: VSStrings.Error.API.internalServerErrorMessage)
        let viewModel = ArticlesListViewModel(localDataClient: localDataFailingClient, apiClient: apiClient)
        let toCompareStates = [ArticlesListViewModel.ViewState.loading, ArticlesListViewModel.ViewState.showEmptyList]
        var step: Int = 0
        
        let _ = viewModel.$viewState
            .sink { value in
                let stateToCompare = toCompareStates[step]
                guard stateToCompare == value else {
                    XCTFail("Wrong state")
                    return
                }
                step += 1
                if step == toCompareStates.count {
                    expectation.fulfill()
                }
            }
            .store(in: &bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension MockAPIClient {
    func loadSyncArticlesList() throws -> [APIModel.Response.Article] {
        return try getObject(fileName: MockJsonFiles.articlesList)
    }
}
