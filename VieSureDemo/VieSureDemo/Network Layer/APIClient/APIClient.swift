//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

protocol APIClient {
    func getArticles(completion: @escaping CompletionResult<Data, VSError>)
}
