//
//  TransactionStatusAPIUserTests.swift
//  NearTests
//
//  Created by Bhushan Mahajan on 11/10/21.
//

import XCTest
@testable import Near

class AccountActivityAPIUserTests: XCTestCase {

    func test_AccountActivityAPI_WithValidAccountname_ShouldReturnValidResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithValidRequest_ShouldReturnValidResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.getAccountActivity(accountName: "testbhushan1.headstraitdev2.testnet") { activityArray in
            //Asserting that the activity array is not nil
            XCTAssertNotNil(activityArray)
            //Asserting that the hash value in the activities areey is not nil.
            XCTAssertNotNil(activityArray[0].hash)
            //Expectation fulfilled after these asserts pass.
            expectation.fulfill()
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_AccountActivityAPI_WithInvalidAccountname_ShouldReturnInvalidResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithInvalidAccountname_ShouldReturnInvalidResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.getAccountActivity(accountName: "testhushan1.headstraitdev2.testnet") { activityArray in
            //Asserting the activity count to be equal to zero.
            XCTAssertEqual(0, activityArray.count)
            //Expectation fulfilled after these asserts pass.
            expectation.fulfill()
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_TransactionStatusAPI_WithValidAccounntnameAndHash_ShouldReturnValidResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithValidAccounntnameAndHash_ShouldReturnValiResponse")
        
        //Server API call for the tests.
        NearRestAPI.shared.transactionStatus(accountName: "testbhushan1.headstraitdev2.testnet", hash: "3DP8UKkSN5RLy8avwxv9jntQ4pfiPEfuJ7JDPt2UXGee") { response in
            //Asserting the value is true for getting the response from the server.
            XCTAssertTrue(response)
            //Expectation fulfilled after these asserts pass.
            expectation.fulfill()
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
}
