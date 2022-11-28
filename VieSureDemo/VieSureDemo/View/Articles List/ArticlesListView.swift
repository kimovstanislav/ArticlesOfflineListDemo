//
//  ContentView.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 11.11.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticlesListView: View {
    @ObservedObject var viewModel: ArticlesListViewModel
    
    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .loading:
                loaderView()
                
            case .showEmptyList:
                emptyListView()

            case .showArticles(let articles):
                articlesListView(articles: articles)

            case .showError(let errorMessage):
                errorView(errorMessage: errorMessage)
            }
        }
        .alert(isPresented: $viewModel.alertModel.showAlert, content: { () -> Alert in
            Alert(title: Text(viewModel.alertModel.title), message: Text(viewModel.alertModel.message), dismissButton: .default(Text(VSStrings.Button.close)))
        })
    }
    
    
    // MARK: - Loading
    
    private func loaderView() -> some View {
        ProgressView()
    }
    
    
    // MARK: - Empty list
    
    private func emptyListView() -> some View {
        Text("No articles")
    }
    
    
    // MARK: - Articles list
    
    private func articlesListView(articles: [Article]) -> some View {
        List(articles.indices, id: \.self) { index in
            NavigationLink(destination: ArticleDetailView(viewModel: ArticleDetailViewModel(article: articles[index]))) {
                articleCell(article: articles[index])
            }
            .accessibility(identifier: String(format: AccessibilityIdentifiers.ArticlesList.listCellFormat, index))
        }
        .accessibility(identifier: AccessibilityIdentifiers.ArticlesList.list)
    }
    
    private func articleCell(article: Article) -> some View {
        HStack(spacing: 16) {
            // AsyncImage is available from iOS 15, so had to use a Pod here.
            // TODO: OR if don't want to use external dependencies replace with stolen code (AsyncImage imlpementation, but first check if it's simple enough)
            // Sources: here https://www.vadimbulavin.com/modern-mvvm-ios-app-architecture-with-combine-and-swiftui/ or here https://github.com/phetsana/BoardGameList-MVVM-Input-Output
            // TODO: but then I'd have to unit test and assure code coverage for it. Not in this scope for sure, no. Propably leave as it is. Just write a nice comment later about the justification.
            WebImage(url: URL(string: article.image))
                .resizable()
                .placeholder(Image(systemName: "photo"))
                .scaledToFill()
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
        ArticlesListView(viewModel: ArticlesListViewModel(localDataClient: LocalDataClient(), apiClient: MockAPIClient()))
    }
}
