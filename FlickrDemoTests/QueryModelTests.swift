//
//  QueryModelTests.swift
//  FlickrDemoTests
//
//  Created by John Cottrell on 12/14/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import XCTest
@testable import FlickrDemo

var photoQueryInfo: PhotoQueryInfo!

class QueryModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        photoQueryInfo = PhotoQueryInfo(id: "123", owner: "testOwner", secret: "testSecret", server: "testServer", farm: 0, title: "testTitle", ispublic: 0, isfriend: 0, isfamily: 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhotoQueryInfo() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(photoQueryInfo.id, "123", "ASSERT EQUAL FAILED: ids are not the same")
        XCTAssertEqual(photoQueryInfo.owner, "testOwner", "ASSERTEQUAL FAILED: owners are not the same")
        XCTAssertEqual(photoQueryInfo.secret, "testSecret", "ASSERTEQUAL FAILED: secrets are not the same")
        XCTAssertEqual(photoQueryInfo.server, "testServer", "ASSERTEQUAL FAILED: servers are not the same")
        XCTAssertEqual(photoQueryInfo.farm, 0, "ASSERTEQUAL FAILED: farms are not the same")
        XCTAssertEqual(photoQueryInfo.title, "testTitle", "ASSERTEQUAL FAILED: titles are not the same")
        XCTAssertEqual(photoQueryInfo.ispublic, 0, "ASSERTEQUAL FAILED: ispublics are not the same")
        XCTAssertEqual(photoQueryInfo.isfriend, 0, "ASSERTEQUAL FAILED: isfriends are not the same")
        XCTAssertEqual(photoQueryInfo.isfamily, 0, "ASSERTEQUAL FAILED: isfamilys are not the same")
    }
}
