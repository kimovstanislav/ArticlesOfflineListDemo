//
//  LocalDataTest.swift
//  VieSureDemoTests
//
//  Created by Stanislav Kimov on 25.11.22.
//

import XCTest
@testable import VieSureDemo
import Combine

final class LocalDataTest: XCTestCase {
    var localDataClient: ILocalData = LocalDataClient()
    
    private var cancellables: Set<AnyCancellable> = []
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSaveArticles() throws {
        let initialArticles = generateArticles(count: 10)
        
        localDataClient.writeArticles(articles: initialArticles).sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                XCTFail(error.message)
            case .finished:
                self?.localDataClient.getArticles().sink { completion in
                    switch completion {
                    case let .failure(error):
                        XCTFail(error.message)
                    case .finished:
                        break
                    }
                } receiveValue: { articles in
                    // TODO: actually compare arrays
                    XCTAssert(initialArticles.count == articles!.count)
                }.store(in: &self!.cancellables)
            }
        } receiveValue: {
            // Nothing
        }.store(in: &cancellables)
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
