//
//  ILocalData.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 25.11.22.
//

import Foundation
import Combine

protocol LocalData {
    func writeArticles(articles: [Article]) async throws
    func getArticles() async throws -> [Article]?
    func clearArticles()
}
