//
//  NetworkManager.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    // TODO: inject properly later, when having mocks and tests
    private let client: IVSAPI = VSAPIClient()

    
    func articlesList() -> AnyPublisher<[APIModel.Response.Article], VSError> {
        return client.articlesList()
    }
}
