//
//  ArticleDetailView.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 28.11.22.
//

import SwiftUI
import SDWebImageSwiftUI

// The most basic UI (and ViewModel) to just display the data with 0 extra logic.
struct ArticleDetailView: View {
    @ObservedObject var viewModel: ArticleDetailViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            WebImage(url: URL(string: viewModel.article.image))
                .resizable()
                .placeholder(Image(systemName: "photo"))
                .scaledToFill()
                .frame(height: 250, alignment: .center)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.article.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(1)
                    .accessibility(identifier: AccessibilityIdentifiers.ArticleDetail.title)
                
                HStack {
                    Spacer()
                    Text(viewModel.article.getDetailReleaseDate())
                        .font(.system(size: 12, weight: .regular))
                }
                
                ScrollView(.vertical) {
                    Text(viewModel.article.description)
                        .font(.system(size: 14, weight: .regular))
                }
                
                Text("Author: ").font(.system(size: 14, weight: .semibold)) + Text(viewModel.article.author).font(.system(size: 12, weight: .regular))
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        
    }
}
