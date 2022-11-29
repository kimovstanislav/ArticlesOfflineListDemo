//
//  LocalDataClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 21.11.22.
//

import Foundation
import Combine

class LocalDataClient: ILocalData {
    enum Keys {
        static let articlesKey = "Articles"
    }
    
    var encryptionClient: IEncryption? = nil
    
    init(encryptionClient: IEncryption? = nil) {
        self.encryptionClient = encryptionClient
    }
    
    func writeArticles(articles: [Article]) async throws {
        let key = Keys.articlesKey
        do {
            var data = try JSONEncoder().encode(articles)
            if let encryption = encryptionClient {
                data = try await encryption.encryptData(data: data)
            }
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
        if var data = UserDefaults.standard.data(forKey: key) {
            do {
                if let encryption = encryptionClient {
                    data = try await encryption.decryptData(data: data)
                }
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
