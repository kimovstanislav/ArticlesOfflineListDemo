//
//  VieSureDemoTests.swift
//  VieSureDemoTests
//
//  Created by Stanislav Kimov on 11.11.22.
//

import XCTest
@testable import VieSureDemo

final class VieSureDemoTests: XCTestCase {
    
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
}
    
    // API test
    // + 1. Test mock api decoding articles response
    
    // Local test
    // + 2. Test local client save/load articles
    
    // ViewModel test
    // 3. Test ListViewModel load only mock API - loaded list ok
    // 4. Test ListViewModel load only mock local - loaded list ok
    // 5. Test ListViewModel local fail, API ok - loaded list ok
    // 6. Test ListViewModel local ok, API fail - loaded list ok, check for error alert
    // 7. Test ListViewModel local fail, API fail - loaded list error (do we show an empty list or a proper error?), check for error alert
    // 8. Test ListViewModel local fail, API fail (error that causes retry) - error after retries, same as previous
    
    // Encryption test
    // 9. Test encrypting if it's implemented
