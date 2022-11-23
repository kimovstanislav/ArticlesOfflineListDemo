//
//  VieSureDemoApp.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 11.11.22.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

@main
struct VieSureDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ArticlesListView(viewModel: ArticlesListViewModel())
        }
    }
}
