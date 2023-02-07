//
//  Article.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

struct Article: Codable, Identifiable, Equatable {
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
    
    init(id: Int, title: String, description: String, author: String, releaseDate: String, image: String) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.releaseDate = releaseDate
        self.image = image
    }
}

extension Article {
    var releaseDateAsDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.monthDayYear
        return dateFormatter.date(from: releaseDate)
    }
}
