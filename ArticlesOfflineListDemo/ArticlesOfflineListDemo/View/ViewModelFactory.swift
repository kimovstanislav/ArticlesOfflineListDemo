//
//  ViewModelFactory.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 25.11.22.
//

import Foundation

// TODO: remove comment, think how can do it better.
class ViewModelFactory {
    // Could create in App and pass through EnvironmentVariable, but prefer to avoid SwiftUI specific approach.
    static let shared = ViewModelFactory()
    
    private let localDataClient: LocalData = LocalDataClient()
    private let apiClient: API = APIClient()
    
    func makeArticlesListViewModel() -> ArticlesListViewModel {
        return ArticlesListViewModel(localDataClient: localDataClient, apiClient: apiClient)
    }
}
