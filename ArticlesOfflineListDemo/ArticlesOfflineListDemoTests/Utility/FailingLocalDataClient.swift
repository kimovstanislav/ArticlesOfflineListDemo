//
//  FailingLocalDataClient.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation
@testable import ArticlesOfflineListDemo

class FailingLocalDataClient: LocalData {
    func writeArticles(articles: [Article]) async throws {
        throw DetailedError.unknown
    }

    func getArticles() async throws -> [Article]? {
        throw DetailedError(localDataError: DetailedError.unknown, code: DetailedError.ErrorCode.errorReadingLocalData.rawValue)
    }

    func clearArticles() {
        
    }
}


