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
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithValidRequest_ShouldReturnValidResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.signInUser(passPhrase: "next morning badge tomato walk banner behind little holiday invest project human") { result in
            //Asserting for a not nil response from the server.
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                //Asserting for true as a response from the server.
                XCTAssertTrue(response.success!)
                //Asserting for a not nil privateKey.
                XCTAssertNotNil(response.privateKey)
                //Asserting for a not nil publicKey.
                XCTAssertNotNil(response.publicKey)
                //Asserting for a accountname equal to the given accountname.
                XCTAssertEqual("testaccount0011.headstraitdev2.testnet", response.accountName)
                expectation.fulfill()
            case .failure(let error):
                //Asserting for a not nil response from the server.
                XCTAssertNil(error)
                //Expectation fullfilled.
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_SignInAPI_WithInvalidRequest_ShouldReturnInvalidResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithInvalidRequest_ShouldReturnInvalidResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.signInUser(passPhrase: "next morning badge tomato walk banner behind little holiday invest project") { result in
            //Asserting for a not nil response from the server.
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                //Asserting false as the response from the server.
                XCTAssertFalse(response.success!)
                //Asserting for a not nil text message.
                XCTAssertNotNil(response.text)
                expectation.fulfill()
            case .failure(let error):
                //Asserting for a not nil response from the server.
                XCTAssertNil(error)
                //Expectation fullfilled.
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
}
