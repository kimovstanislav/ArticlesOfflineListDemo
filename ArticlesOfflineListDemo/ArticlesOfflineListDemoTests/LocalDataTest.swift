//
//  LocalDataTest.swift
//  ArticlesOfflineListDemoTests
//
//  Created by Stanislav Kimov on 25.11.22.
//

import XCTest
@testable import ArticlesOfflineListDemo

final class LocalDataTest: XCTestCase {
    var localDataClient: LocalData = LocalDataClient()
    
    func testSaveArticles() async throws {
        let dataClient = localDataClient
        let initialArticles = generateArticles(count: 10)
        
        try await dataClient.writeArticles(articles: initialArticles)
        let articles = try await dataClient.getArticles()
        guard let loadedArticles = articles else {
            XCTFail("Loaded articles is nil.")
            return
        }
        XCTAssert(initialArticles == loadedArticles)
    }
}

extension LocalDataTest {
    private func generateArticles(count: Int) -> [Article] {
        var articles = [Article]()
        for i in 0..<count {
            let article = Article(id: i,
                                  title: "Title number \(i)",
                                  description: "congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam",
                                  author: "tgrzelczyk3@webmd.com",
                                  releaseDate: "3/23/2020",
                                  image: "")
            articles.append(article)
        }
        return articles
    }
}
