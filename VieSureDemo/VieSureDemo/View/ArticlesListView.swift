//
//  ContentView.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 11.11.22.
//

import SwiftUI

struct ArticlesListView: View {
    @ObservedObject var viewModel: ArticlesListViewModel
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            loaderView()

        case .showArticles(let articles):
            articlesListView(articles: articles)

        case .showError(let errorMessage):
            errorView(errorMessage: errorMessage)
        }
    }
    
    
    // MARK: - Loading
    
    private func loaderView() -> some View {
        ProgressView()
    }
    
    
    // MARK: - Articles list
    
    private func articlesListView(articles: [APIModel.Response.Article]) -> some View {
        List(articles) { article in
            articleCell(article: article)
        }
    }
    
    private func articleCell(article: APIModel.Response.Article) -> some View {
        HStack(spacing: 16) {
            // TODO: should cache the images for local storage
            AsyncImage(url: URL(string: article.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40, alignment: .center)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                Text(article.description)
                    .font(.system(size: 12, weight: .regular))
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
    
    
    // MARK: - Error
    
    private func errorView(errorMessage: String) -> some View {
        VStack(alignment: .center) {
            Spacer()
            Text(errorMessage)
                .font(.headline.bold())
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView(viewModel: ArticlesListViewModel())
    }
}
