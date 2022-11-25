//
//  LocalDataClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 21.11.22.
//

import Foundation
import Combine

// TODO: consider encryption.
class LocalDataClient: ILocalData {
    enum Keys {
        static let articlesKey = "Articles"
    }
    
    func writeArticles(articles: [Article]) -> AnyPublisher<Void, VSError> {
        let key = Keys.articlesKey
        return Future { promise in
            do {
                let data = try JSONEncoder().encode(articles)
                UserDefaults.standard.set(data, forKey: key)
                // TODO: must compile without (()), it's ugly, to fix
                promise(.success(()))
            }
            catch {
                let vsError = VSError(localDataError: error, code: VSError.ErrorCode.errorWritingLocalData.rawValue)
                promise(.failure(vsError))
            }
        }.eraseToAnyPublisher()
    }
    
    func getArticles() -> AnyPublisher<[Article]?, VSError> {
        let key = Keys.articlesKey
        return Future { promise in
            if let data = UserDefaults.standard.data(forKey: key) {
                do {
                    let articles = try JSONDecoder().decode([Article].self, from: data)
                    promise(.success(articles))
                }
                catch {
                    let vsError = VSError(localDataError: error, code: VSError.ErrorCode.errorReadingLocalData.rawValue)
                    promise(.failure(vsError))
                }
            }
            else {
                // If no data was yet saved, it's not an error. Return nil.
                promise(.success(nil))
            }
        }.eraseToAnyPublisher()
    }
}
