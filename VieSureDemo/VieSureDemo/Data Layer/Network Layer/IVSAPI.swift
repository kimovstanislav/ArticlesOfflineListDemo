//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

protocol IVSAPI {
    /// Throws VSError
    func loadArticlesList() async throws -> [APIModel.Response.Article]
}
