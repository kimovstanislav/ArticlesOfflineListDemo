//
//  NetworkManager.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

// TODO: change to use Combine
//protocol VSAPI {
//    func getArticles(completion: @escaping CompletionResult<([APIModel.Response.Article]), VSError>)
//}

// TODO: check to simplify later.
/*
 Currently is used just as a middle layer to hide VSAPIClient. May be too complicated for this app.
 Will think to simplify it later. Like the idea to have all the base stuff in APIClient.
 May just make VSAPIClient to take NetworkManager's place and implement API interface.
 But NetworkManager may come in handy when implementing unit tests with Mock data. Will think about it on that step.
 */
class NetworkManager {//: VSAPI {
    // TODO: read on options where to store this object for the global app architecture. Later, just for myself.
    // For this example singleton is fine.
    static let shared = NetworkManager()
    
    // TODO: inject properly
    private let client: IVSAPI = VSAPIClient()
    
    func getArticles(completion: @escaping CompletionResult<([APIModel.Response.Article]), VSError>) {
        client.getArticles() { [weak self] result in
            print(">> NetworkManager - getArticles - result: \(result)")
            guard let self = self else { return }
            self.processClientResult(result, completion: completion)
        }
    }
    
    private func processClientResult<CompletionType: Decodable>(_ result: Result<Data, VSError>, completion: CompletionResult<CompletionType, VSError>) {
        switch result {
        case let .success(data):
            do {
                let decodedData: CompletionType = try JSONDecoder().decode(CompletionType.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(VSError.unknown))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}
