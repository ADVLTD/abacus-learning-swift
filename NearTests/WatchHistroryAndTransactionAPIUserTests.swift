//
//  WatchHistroryAndTransactionAPIUserTests.swift
//  NearTests
//
//  Created by Bhushan Mahajan on 11/10/21.
//

import XCTest
@testable import Near

class WatchHistroryAndTransactionAPIUserTests: XCTestCase {
    
    func test_WatchHistorySavedHistroyAndSendToken_WithValidVideoID() {
        let expectation = self.expectation(description: "WatchHistorySavedHistroyAndSendToken_WithValidVideoID")
        
        NearRestAPI.shared.rewardUser(accountName: "testaccount0011.headstraitdev2.testnet", privateKey: "ed25519:5T4PruYjciFuJY1LoSJP5yG2K2DXdhgbHAM5oGTKVDKTpuWvnR7oCcw9My9zJAZPHw9jTHXZE9vgs7RyRCfjcTXU", videoId: "000000") { result in
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
    
    func test_WatchHistorySavedHistroyAndSendToken_WithInvalidVideoID() {
        let expectation = self.expectation(description: "WatchHistorySavedHistroyAndSendToken_WithInvalidVideoID")
        
        NearRestAPI.shared.rewardUser(accountName: "testaccount0011.headstraitdev2.testnet", privateKey: "ed25519:5T4PruYjciFuJY1LoSJP5yG2K2DXdhgbHAM5oGTKVDKTpuWvnR7oCcw9My9zJAZPHw9jTHXZE9vgs7RyRCfjcTXU", videoId: "000000") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                XCTAssertFalse(response)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
