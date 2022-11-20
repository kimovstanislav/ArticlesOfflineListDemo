//
//  ArticlesListViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 20.11.22.
//

import Foundation

// TODO: add View State for articles/error/whatever?..
class ArticlesListViewModel: ObservableObject {
    @Published var articles: [APIModel.Response.Article]?
    @Published var errorMessage: String?
    
    init() {
        loadArticles()
    }
    
    private func loadArticles() {
        NetworkManager.shared.getArticles { result in
            switch result {
            case let .success(articles):
                DispatchQueue.main.async {
                    self.articles = articles
                }
            case let .failure(error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
