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
        let expectation = self.expectation(description: "WithValidRequest_ShouldReturnValidResponse")
        NearRestAPI.shared.getAccountActivity(accountName: "testbhushan1.headstraitdev2.testnet") { activityArray in
            XCTAssertNotNil(activityArray)
            XCTAssertNotNil(activityArray[0].hash)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_AccountActivityAPI_WithInvalidAccountname_ShouldReturnInvalidResponse() {
        let expectation = self.expectation(description: "WithInvalidAccountname_ShouldReturnInvalidResponse")
        NearRestAPI.shared.getAccountActivity(accountName: "testhushan1.headstraitdev2.testnet") { activityArray in
            XCTAssertEqual(0, activityArray.count)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_TransactionStatusAPI_WithValidAccounntnameAndHash_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "WithValidAccounntnameAndHash_ShouldReturnValiResponse")
        NearRestAPI.shared.transactionStatus(accountName: "testbhushan1.headstraitdev2.testnet", hash: "3DP8UKkSN5RLy8avwxv9jntQ4pfiPEfuJ7JDPt2UXGee") { response in
            XCTAssertTrue(response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
