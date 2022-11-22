//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

protocol IVSAPI {
    func getArticles(completion: @escaping CompletionResult<Data, VSError>)
//    func getArticles(completion: @escaping CompletionResult<[APIModel.Response.Article], VSError>)
}
