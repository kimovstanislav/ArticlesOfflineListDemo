//
//  ArtilcleDetailTest.swift
//  ArticlesOfflineListDemoTests
//
//  Created by Stanislav Kimov on 28.11.22.
//

import XCTest
@testable import ArticlesOfflineListDemo

final class ArtilcleDetailTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
  
    func testFormattedDate() throws {
        let article = Article(id: 1,
                title: "Title",
                description: "congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam",
                author: "tgrzelczyk3@webmd.com",
                releaseDate: "3/23/2020",
                image: "")
        let formattedDate = article.getDetailReleaseDate()
        XCTAssertFalse(formattedDate == article.releaseDate)
    }
}
