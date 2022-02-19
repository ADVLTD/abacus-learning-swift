import XCTest
@testable import Near

class GenerateLinkDropAPIUserTests: XCTestCase {

    func test_GenerateLinkDrop_WithValidAccountnameAmountAndPrivateKey_ShouldReturnValidResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithValidAccountnameAmountAndPrivateKey_ShouldReturnValidResponse")

        //Server API call for the tests.
        NearRestAPI.shared.generateLinkDrop(accountName: "headstraitdev2.testnet", amount: "2", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6zp") { result in
            switch result {
            case .success(let response):
                //Asserting not nil value for response.
                XCTAssertNotNil(response)
                //Asserting not nil value for publicKey.
                XCTAssertNotNil(response.newKeyPair?.public_key)
                //Asserting not nil value for secretKey.
                XCTAssertNotNil(response.newKeyPair?.secretKey)
                //Asserting not nil value for amount.
                XCTAssertNotNil(response.newKeyPair?.amount)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            case .failure(let error):
                //Asserting for nil error from the response.
                XCTAssertNil(error)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }

    func test_GenerateLinkDrop_WithInvalidAccountnameAmountAndPrivateKey_ShouldReturnNilResponse() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithInvalidAccountnameAmountAndPrivateKey_ShouldReturnNilResponse")

        //Server API call for the tests.
        NearRestAPI.shared.generateLinkDrop(accountName: "headstraitdev2.testnet", amount: "2", privateKey: "ed25519:2MJghFQqjgukaERsp1jTtxgXs1iSJQYDd8Ua6W96YQdr32N7Dg5opnHofuBnna9wkaHZKeUARHKEUuj23KdpQ6z") { result in
            switch result {
            case .success(let response):
                //Asserting nil response for amount.
                XCTAssertNil(response.newKeyPair?.amount)
                //Asserting nil response for secretKey.
                XCTAssertNil(response.newKeyPair?.secretKey)
                //Asserting nil response for publicKey.
                XCTAssertNil(response.newKeyPair?.publicKey)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                //Expectation fulfilled after these asserts pass.
                expectation.fulfill()
            }
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }

    func test_ReclaimNearToken_WithValidccountnameAndSecretkey_ShouldReturnCorrectBoolValue() {
        
        //The api function is called as it is a server request, it takes some time to execute hence using the expectation for the test to wait untill the request is complete.
        let expectation = self.expectation(description: "WithValidccountnameAndSecretkey_ShouldReturnCorrectBoolValue")

        //Server API call for the tests.
        NearRestAPI.shared.reclaimNear(accountName: "headstraitdev2.testnet", secretKey: "ed25519:U18GHbWNddKx2ivg9PBn1dP76oSNSjnRYixakyfKp7bRLX6ahmm1nC3w2E2YCm63HUKF4zjQaiHDx1rJycBjCeQ") { result in
            //Asserting for a false value from the function as output.
            XCTAssertFalse(result)
            //Expectation fulfilled after these asserts pass.
            expectation.fulfill()
        }
        
        //Wait used to wait for 20 seconds to complete the server request.
        waitForExpectations(timeout: 20, handler: nil)
    }
}
