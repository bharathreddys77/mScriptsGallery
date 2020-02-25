//
//  NetworkingTests.swift
//  MscriptsGalleryTests
//
//  Created by A6049116 on 2/26/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import XCTest
@testable import MscriptsGallery

class NetworkingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_photos_api() {
        let promise = expectation(description: "Verify that API is returning photos")
        mScriptsServiceController().retrievePublicPhotos { (photos, error) in
            XCTAssertNil(photos?.networkError)
            XCTAssertNil(error)
            XCTAssert((photos?.photos?.allPhotos?.count ?? 0) > 0, "Flickr API returned photos")
            promise.fulfill()
        }
        waitForExpectations(timeout: 100) { (erro) in
            XCTAssertFalse(false, "Flickr photo API timed out")
        }
    }
    

}
