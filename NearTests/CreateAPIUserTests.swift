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
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "ValidRequest_ShouldReturnValidResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.createUser(username: "testaccount2559") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                //Asserting for a not null response.
                XCTAssertNotNil(response.accountName)
                //Asserting for accountName to be equal to the given accountName.
                XCTAssertEqual("testaccount2559.headstraitdev2.testnet", response.accountName)
                //Asserting for a not null privateKey.
                XCTAssertNotNil(response.privateKey)
                //Asserting for a not null publicKey.
                XCTAssertNotNil(response.publicKey)
                //Asserting for a not null passPhrase.
                XCTAssertNotNil(response.passPhrase)
                expectation.fulfill()
            case .failure(let error):
                //Asserting for a null error from server result.
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_CreateUserAPIWithInvalidRequest_ShouldReturnInvalidResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "CreateUserAPIWithInvalidRequest_ShouldReturnInvalidResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.createUser(username: "testaccount255") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                //Asserting for a statusCode for server error.
                XCTAssertNotNil(response.statusCode)
                //Asserting for a 500 response statusCode.
                XCTAssertEqual(500, response.statusCode)
                //Asserting for a not null error
                XCTAssertNotNil(response.error)
                //Asserting for a not null error message
                XCTAssertNotNil(response.message)
                expectation.fulfill()
            case .failure(let error):
                //Asserting for a null error from server request to ensure the server request has been fullfilled with either success or failure.
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }

}
