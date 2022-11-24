//
//  LocalDataManager.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 21.11.22.
//

import Foundation
import Combine

protocol VSLocalData {
    func writeArticles(articles: [Article]) -> AnyPublisher<Void, VSError>
    func getArticles() -> AnyPublisher<[Article], VSError>
}

// TODO: add encryption later, maybe.
class LocalDataManager: VSLocalData {
    static let shared = LocalDataManager()
    
    let articlesKey = "Articles"
    
    func writeArticles(articles: [Article]) -> AnyPublisher<Void, VSError> {
        let key = articlesKey
        return Future { promise in
            do {
                let data = try JSONEncoder().encode(articles)
                UserDefaults.standard.set(data, forKey: key)
                
                // TODO: must compile without (()), it's ugly, to fix
                promise(.success(()))
            }
            catch {
                print("Unable to Encode Articles: (\(error))")
                let vsError = VSError(localDataError: error, code: VSError.ErrorCode.errorWritingLocalData.rawValue)
                promise(.failure(vsError))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func getArticles() -> AnyPublisher<[Article], VSError> {
        let key = articlesKey
        return Future { promise in
            if let data = UserDefaults.standard.data(forKey: key) {
                do {
                    let articles = try JSONDecoder().decode([Article].self, from: data)
                    promise(.success(articles))
                }
                catch {
                    print("Unable to Decode Articles: (\(error))")
                    let vsError = VSError(localDataError: error, code: VSError.ErrorCode.errorReadingLocalData.rawValue)
                    promise(.failure(vsError))
                }
            }
            else {
                // Not an error, if no data is yet saved. Return empty list.
                promise(.success([Article]()))
            }
        }.eraseToAnyPublisher()
    }
}
