//
//  ViewModelFactory.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 25.11.22.
//

import Foundation

class ViewModelFactory {
    // Could create in App and pass through EnvironmentVariable, but prefer to avoid SwiftUI specific approach.
    static let shared = ViewModelFactory()
    
    private let localDataClient: ILocalData = LocalDataClient()
    private let apiClient: IVSAPI = APIClient()
    
    func makeArticlesListViewModel() -> ArticlesListViewModel {
        return ArticlesListViewModel(localDataClient: localDataClient, apiClient: apiClient)
    }
}
