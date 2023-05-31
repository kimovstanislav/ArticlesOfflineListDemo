//
//  ApiTest.swift
//  ArticlesOfflineListDemoTests
//
//  Created by Stanislav Kimov on 25.11.22.
//

import XCTest
@testable import ArticlesOfflineListDemo

final class ApiTest: XCTestCase {
    var mockApiClient: API = MockAPIClient()

    func testDecodeData() async throws {
        let articles = try await mockApiClient.loadArticlesList()
        XCTAssert(articles.count == 60)
    }
}
