//
//  WatchHistroryAndTransactionAPIUserTests.swift
//  NearTests
//
//  Created by Bhushan Mahajan on 11/10/21.
//

import XCTest
@testable import Near

class WatchHistroryAndTransactionAPIUserTests: XCTestCase {
    
    func test_ViewuserHistoryAPI_WithValidAccountnameAndVideoID_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "WithValidAccountnameAndVideoID_ShouldReturnValidResponse")
        NearRestAPI.shared.viewUserWatchHistory(accountName: "testbhushan1.headstraitdev2.testnet", videoId: "1") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertTrue(response)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_SaveUserHistoryAPI_WithValidAccountnameAndVideoID_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "WithValidAccounntnameAndHash_ShouldReturnValiResponse")
        NearRestAPI.shared.saveUserVideoDetails(accountName: "test12345.headstraitdev2.testnet", videoId: "22", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6zp") { result in
            XCTAssertNotNil(result)
            print(result)
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_SaveUserHistoryAPI_WithInvalidAccountnameAndVideoID_ShouldReturnInvalidResponse() {
        let expectation = self.expectation(description: "WithInvalidAccountnameAndVideoID_ShouldReturnInvalidResponse")
        NearRestAPI.shared.saveUserVideoDetails(accountName: "test12345.headstraitdev2.testnet", videoId: "1", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6zt") { result in
            XCTAssertNotNil(result)
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_SendTokenAPI_WithValidAccountnameAndVideoID_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "WithValidAccounntnameAndHash_ShouldReturnValiResponse")
        NearRestAPI.shared.sendToken(accountName: "testbhushan1.headstraitdev2.testnet", videoId: "1", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6zp") { result in
            XCTAssertNotNil(result)
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
