//
//  ArticleDetailViewModel.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 28.11.22.
//

import Foundation

class ArticleDetailViewModel: ObservableObject {
    @Published var article: Article
    
    init(article: Article) {
        self.article = article
    }
}

extension Article {
    func getDetailReleaseDate() -> String {
        guard let date = releaseDateAsDate else {
            return releaseDate
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.articleDetail
        return dateFormatter.string(from: date)// ?? releaseDate
    }
}
