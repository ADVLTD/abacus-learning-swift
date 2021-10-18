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
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WatchHistorySavedHistroyAndSendToken_WithValidVideoID")
        
        //Server API call for the tests.
        NearRestAPI.shared.rewardUser(accountName: "testaccount0011.headstraitdev2.testnet", privateKey: "ed25519:5T4PruYjciFuJY1LoSJP5yG2K2DXdhgbHAM5oGTKVDKTpuWvnR7oCcw9My9zJAZPHw9jTHXZE9vgs7RyRCfjcTXU", videoId: "000000") { result in
            //Asserting for not nil response from the server.
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                //Asserting for a true value from the function as output.
                XCTAssertTrue(response)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            case .failure(let error):
                //Asserting for nil erro response from the server.
                XCTAssertNil(error)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_WatchHistorySavedHistroyAndSendToken_WithInvalidVideoID() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WatchHistorySavedHistroyAndSendToken_WithInvalidVideoID")
        
        //Server API call for the tests.
        NearRestAPI.shared.rewardUser(accountName: "testaccount0011.headstraitdev2.testnet", privateKey: "ed25519:5T4PruYjciFuJY1LoSJP5yG2K2DXdhgbHAM5oGTKVDKTpuWvnR7oCcw9My9zJAZPHw9jTHXZE9vgs7RyRCfjcTXU", videoId: "000000") { result in
            //Asserting for not nil response from the server.
            XCTAssertNotNil(result)
            switch result {
            case .success(let response):
                //Asserting for a false value from the function as output.
                XCTAssertFalse(response)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            case .failure(let error):
                //Asserting for nil response from the server.
                XCTAssertNil(error)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
}
