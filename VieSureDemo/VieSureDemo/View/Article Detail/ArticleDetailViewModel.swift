//
//  ArticleDetailViewModel.swift
//  VieSureDemo
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
