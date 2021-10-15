//
//  GenerateLinkDropAPIUserTests.swift
//  NearTests
//
//  Created by Bhushan Mahajan on 12/10/21.
//

import XCTest
@testable import Near

class GenerateLinkDropAPIUserTests: XCTestCase {

    func test_GenerateLinkDrop_WithValidAccountnameAmountAndPrivateKey_ShouldReturnValidResponse() {
        let expectation = self.expectation(description: "WithValidAccountnameAmountAndPrivateKey_ShouldReturnValidResponse")

        NearRestAPI.shared.generateLinkDrop(accountName: "headstraitdev2.testnet", amount: "2", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6zp") { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertNotNil(response.newKeyPair?.public_key)
                XCTAssertNotNil(response.newKeyPair?.secretKey)
                XCTAssertNotNil(response.newKeyPair?.amount)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

    func test_GenerateLinkDrop_WithInvalidAccountnameAmountAndPrivateKey_ShouldReturnNilResponse() {
        let expectation = self.expectation(description: "WithInvalidAccountnameAmountAndPrivateKey_ShouldReturnNilResponse")

        NearRestAPI.shared.generateLinkDrop(accountName: "headstraitdev2.testnet", amount: "2", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6z") { result in
            switch result {
            case .success(let response):
                XCTAssertNil(response.newKeyPair?.amount)
                XCTAssertNil(response.newKeyPair?.secretKey)
                XCTAssertNil(response.newKeyPair?.publicKey)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

    func test_ReclaimNearToken_WithValidccountnameAndSecretkey_ShouldReturnCorrectBoolValue() {
        let expectation = self.expectation(description: "WithValidccountnameAndSecretkey_ShouldReturnCorrectBoolValue")

        NearRestAPI.shared.reclaimNear(accountName: "headstraitdev2.testnet", secretKey: "ed25519:U18GHbWNddKx2ivg9PBn1dP76oSNSjnRYixakyfKp7bRLX6ahmm1nC3w2E2YCm63HUKF4zjQaiHDx1rJycBjCeQ") { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
