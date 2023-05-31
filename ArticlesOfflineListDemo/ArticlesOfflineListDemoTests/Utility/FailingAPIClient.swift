//
//  FailingAPIClient.swift
//  ArticlesOfflineListDemoTests
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation
@testable import ArticlesOfflineListDemo

class FailingAPIClient: API {
    // Can set any error we like
    var failingError: DetailedError = DetailedError.Factory.makeDecodingError(cause: nil)
    
    func loadArticlesList() async throws -> [APIModel.Response.Article] {
        throw failingError
    }
}
