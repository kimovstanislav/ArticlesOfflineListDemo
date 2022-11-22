//
//  Article.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

struct Article: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let author: String
    let releaseDate: String
    let image: String
    
    init(apiResponse: APIModel.Response.Article) {
        self.id = apiResponse.id
        self.title = apiResponse.title
        self.description = apiResponse.description
        self.author = apiResponse.author
        self.releaseDate = apiResponse.release_date
        self.image = apiResponse.image
    }
}
