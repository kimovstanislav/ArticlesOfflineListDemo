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

    // A bit rought, but it's ok for unit test. Works fine.
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
                if step == 3 {
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
