//
//  FailingLocalDataClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation
@testable import VieSureDemo

class FailingLocalDataClient: ILocalData {
    func writeArticles(articles: [Article]) async throws {
        throw VSError.unknown
    }

    func getArticles() async throws -> [Article]? {
        throw VSError.unknown
    }

    func clearArticles() {
        
    }
}


