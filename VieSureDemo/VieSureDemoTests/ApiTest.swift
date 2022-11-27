//
//  ApiTest.swift
//  VieSureDemoTests
//
//  Created by Stanislav Kimov on 25.11.22.
//

import XCTest
@testable import VieSureDemo

final class ApiTest: XCTestCase {
    var mockApiClient: IVSAPI = MockAPIClient()

    func testDecodeData() throws {
        Task {
            do {
                let articles = try await mockApiClient.loadArticlesList()
                XCTAssert(articles.count == 60)
            }
            catch let error as VSError  {
                XCTFail(error.message)
            }
        }
    }
}
