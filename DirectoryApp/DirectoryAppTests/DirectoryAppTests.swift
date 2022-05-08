//
//  DirectoryAppTests.swift
//  DirectoryAppTests
//
//  Created by Geethika on 06/05/22.
//

import XCTest
@testable import DirectoryApp

class DirectoryAppTests: XCTestCase {
    let colleagueListViewModel = ColleagueListViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertNotNil(Bundle.main.url(forResource: "ColleagueData", withExtension: "json"))
        XCTAssertNoThrow(try NetworkHandler.readData(from: "ColleagueData", fileExtension: "json"), "Returned Exception while reading from Json file")
        XCTAssertNoThrow(try colleagueListViewModel.fetchData(), "Returned Exception with error")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
