//
//  MockAPIClient.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 25.11.22.
//

import Foundation
import Combine

class MockAPIClient: API {
    enum MockJsonFiles {
        static let articlesList = "articles_list"
    }
    
    func loadArticlesList() async throws -> [APIModel.Response.Article] {
        return try getObject(fileName: MockJsonFiles.articlesList)
    }
}

extension MockAPIClient {
    func getObject<T: Decodable>(fileName: String) throws -> T {
        let jsonString = JsonHelper.readJsonString(named: fileName)
        let data = jsonString.data(using: .utf8)!
        return try decodeApiResponse(data: data)
    }
}
