//
//  VieSureDemoUITests.swift
//  VieSureDemoUITests
//
//  Created by Stanislav Kimov on 11.11.22.
//

import XCTest

final class VieSureDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testArticlesListLoad() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.collectionViews[AccessibilityIdentifiers.ArticlesList.list].waitForExistence(timeout: 10))
    }
    
    func testOpenArticleDetail() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews[AccessibilityIdentifiers.ArticlesList.list].buttons[String(format: AccessibilityIdentifiers.ArticlesList.listCellFormat, 0)].tap()
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.ArticleDetail.title].waitForExistence(timeout: 10))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
