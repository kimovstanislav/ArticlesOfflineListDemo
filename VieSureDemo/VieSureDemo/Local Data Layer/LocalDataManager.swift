//
//  LocalDataManager.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 21.11.22.
//

import Foundation

// TODO: use combine, maybe create a different struct for article, not use the API response 1 to 1
protocol VSLocalData {
    func writeArticles(articles: [Article], completion: @escaping CompletionResult<Void, VSError>)
    func getArticles(completion: @escaping CompletionResult<[Article], VSError>)
}

class LocalDataManager: VSLocalData {
    static let shared = LocalDataManager()
    
    let articlesKey = "Articles"
    
    // TODO: cleanup error handling
    func writeArticles(articles: [Article], completion: @escaping CompletionResult<Void, VSError>) {
        do {
            let data = try JSONEncoder().encode(articles)
            UserDefaults.standard.set(data, forKey: articlesKey)
            
            // TODO: must compile without (()), to fix
            completion(.success(()))
        }
        catch {
            print("Unable to Encode Articles (\(error))")
            // TODO: properly
            let vsError = VSError(code: 666, message: "AAaaa!")
            completion(.failure(vsError))
        }
    }
    
    func getArticles(completion: @escaping CompletionResult<[Article], VSError>) {
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: articlesKey) {
            do {
                let articles = try JSONDecoder().decode([Article].self, from: data)
                completion(.success(articles))
            }
            catch {
                print("Unable to Decode Articles (\(error))")
                // TODO: properly
                let vsError = VSError(code: 666, message: "AAaaa!")
                completion(.failure(vsError))
            }
        }
        else {
            // Not an error, if no data is yet saved. Return empty list.
            completion(.success([Article]()))
        }
    }
}