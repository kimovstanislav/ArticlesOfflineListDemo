//
//  VieSureDemoApp.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 11.11.22.
//

import SwiftUI
import SDWebImageSwiftUI

@main
struct ArticlesOfflineListDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ArticlesListView(viewModel: ViewModelFactory.shared.makeArticlesListViewModel())
        }
    }
}
