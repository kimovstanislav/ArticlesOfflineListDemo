//
//  ArticleDetailView.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 28.11.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticleDetailView: View {
    @ObservedObject var viewModel: ArticleDetailViewModel
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: viewModel.article.image))
                .resizable()
                .placeholder(Image(systemName: "photo"))
                .scaledToFill()
                .frame(width: 40, height: 40, alignment: .center)
                .clipShape(Circle())

            Text(viewModel.article.title)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
            
            Text(viewModel.article.description)
                    .font(.system(size: 12, weight: .regular))
                    .lineLimit(2)
            }
        }
    }
