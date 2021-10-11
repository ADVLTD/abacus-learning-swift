//
//  CreateAPIUserTests.swift
//  NearTests
//
//  Created by Bhushan Mahajan on 11/10/21.
//

import XCTest
@testable import Near

class CreateAPIUserTests: XCTestCase {
    
    func test_CreateUserAPIWithValidRequest_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "ValidRequest_ShouldReturnValidResponse")
        NearRestAPI.shared.createUser(username: "testaccount2559") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNotNil(response.accountName)
                XCTAssertEqual("testaccount2559.headstraitdev2.testnet", response.accountName)
                XCTAssertNotNil(response.privateKey)
                XCTAssertNotNil(response.publicKey)
                XCTAssertNotNil(response.passPhrase)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_CreateUserAPIWithInvalidRequest_ShouldReturnInvalidResponse() {
        let expectation = self.expectation(description: "CreateUserAPIWithInvalidRequest_ShouldReturnInvalidResponse")
        NearRestAPI.shared.createUser(username: "testaccount255") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertNotNil(response.statusCode)
                XCTAssertEqual(500, response.statusCode)
                XCTAssertNotNil(response.error)
                XCTAssertNotNil(response.message)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

}
