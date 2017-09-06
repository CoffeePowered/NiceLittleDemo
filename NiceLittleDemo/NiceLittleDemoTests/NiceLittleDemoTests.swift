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
        if let path = Bundle.main.path(forResource: "VideosResponse", ofType: "json")
        {
            do {
            let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
            
                if let jsonResult: [String:Any] = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                {
                    let videos = Parser.doYaThing(withDictionary: jsonResult, usingThumbnailBaseURL: "", andVideosBaseURL: "")
                    print("parsed mock response")
                    XCTAssert(videos.count == 18, "The count of parsed videos must be 18")
                    if let firstVideo = videos.first {
                        if let firstTitle = firstVideo.title {
                            XCTAssert(firstTitle == "Join WWE Superstars in helping those affected by Hurricane Harvey", "The parsed title of the first video does not match the expected value")
                        } else {
                            XCTAssert(false, "The parsed title of the first video should not be nil")
                        }
                    } else {
                        XCTAssert(false, "The parsed response does not even have one video!")
                    }
                    
                }
            }
            catch {
            }
        }
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
