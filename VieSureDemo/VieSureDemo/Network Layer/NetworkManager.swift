//
//  NetworkManager.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation
import Combine

// TODO: check to simplify later.
/*
 Currently is used just as a middle layer to hide VSAPIClient. May be too complicated for this app.
 Will think to simplify it later. Like the idea to have all the base stuff in APIClient.
 May just make VSAPIClient to take NetworkManager's place and implement API interface.
 But NetworkManager may come in handy when implementing unit tests with Mock data. Will think about it on that step.
 */
// TODO: change to use Combine
class NetworkManager {
    static let shared = NetworkManager()
    
    // TODO: inject properly later, when having mocks and tests
    private let client: IVSAPI = VSAPIClient()

    
    static func articlesList() -> AnyPublisher<[APIModel.Response.Article], VSError> {
        return VSAPIClient.articlesList()
    }
}
