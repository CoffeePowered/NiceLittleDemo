//
//  NiceLittleDemoTests.swift
//  NiceLittleDemoTests
//
//  Created by user on 8/29/17.
//  Copyright © 2017 SomeCompany. All rights reserved.
//

import XCTest
@testable import NiceLittleDemo

class NiceLittleDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParser() {
        //let mockJSON = loadJSONFromFile(named: "VideosResponse")
        //print(mockJSON)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func loadJSONFromFile(named: String) -> String? {
        var result : String?
        if let jsonURL = Bundle.main.url(forResource: named, withExtension: "json")
        {
            do {
                let jsonData = try Data(contentsOf: jsonURL, options: .mappedIfSafe)
                result = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            } catch {}
        }
        return result
    }
    
}
