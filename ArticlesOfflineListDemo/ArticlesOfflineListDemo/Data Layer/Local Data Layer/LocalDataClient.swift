//
//  LocalDataClient.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 21.11.22.
//

import Foundation
import Combine

class LocalDataClient: ILocalData {
    enum Keys {
        static let articlesKey = "Articles"
    }
    
    func writeArticles(articles: [Article]) async throws {
        let key = Keys.articlesKey
        do {
            let data = try JSONEncoder().encode(articles)
            UserDefaults.standard.set(data, forKey: key)
            return
        }
        catch {
            let vsError = VSError(localDataError: error, code: VSError.ErrorCode.errorWritingLocalData.rawValue)
            throw vsError
        }
    }
    
    func getArticles() async throws -> [Article]? {
        let key = Keys.articlesKey
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let articles = try JSONDecoder().decode([Article].self, from: data)
                return articles
            }
            catch {
                let vsError = VSError(localDataError: error, code: VSError.ErrorCode.errorReadingLocalData.rawValue)
                throw vsError
            }
        }
        else {
            // If no data was yet saved, it's not an error. Return nil.
            return nil
        }
    }
    
    func clearArticles() {
        UserDefaults.standard.set(nil, forKey: Keys.articlesKey)
    }
}
