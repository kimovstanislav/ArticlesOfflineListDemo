//
//  APIModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

enum APIModel {}

// MARK: - Request

extension APIModel {
    enum Response {
        struct Article: Codable {
            let id: String
            let title: String
            let description: String
            let author: String
            let release_date: String
            let image: String
        }
    }
}
