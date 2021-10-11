//
//  SignInAPIUserTests.swift
//  NearTests
//
//  Created by Bhushan Mahajan on 11/10/21.
//

import XCTest
@testable import Near

class SignInAPIUserTests: XCTestCase {

    func test_SignInAPI_WithValidRequest_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "WithValidRequest_ShouldReturnValidResponse")
        
        NearRestAPI.shared.signInUser(passPhrase: "next morning badge tomato walk banner behind little holiday invest project human") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertTrue(response.success!)
                XCTAssertNotNil(response.privateKey)
                XCTAssertNotNil(response.publicKey)
                XCTAssertEqual("testaccount0011.headstraitdev2.testnet", response.accountName)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_SignInAPI_WithInvalidRequest_ShouldReturnInvalidResponse() {
        let expectation = self.expectation(description: "WithInvalidRequest_ShouldReturnInvalidResponse")
        
        NearRestAPI.shared.signInUser(passPhrase: "next morning badge tomato walk banner behind little holiday invest project") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertFalse(response.success!)
                XCTAssertNotNil(response.text)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
}
