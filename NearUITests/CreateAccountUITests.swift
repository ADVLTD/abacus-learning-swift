//
//  CreateAccountUITests.swift
//  NearUITests
//
//  Created by Bhushan Mahajan on 15/10/21.
//

import XCTest

class CreateAccountUITests: XCTestCase {

    func testCreateAccountWithValidCredentials() {
        let accountName = "testaccount1469"
        let app = XCUIApplication()
        
        let createAccountTextfield = app.textFields["Enter AccountName"]
        XCTAssertTrue(createAccountTextfield.exists)
        createAccountTextfield.tap()
        createAccountTextfield.typeText(accountName)
        
        let createAccountButton = app.buttons["Create Account"].staticTexts["Create Account"]
        XCTAssertTrue(createAccountButton.exists)
        createAccountButton.tap()
        
        let continueButton = app.buttons["Continue"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: continueButton, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        continueButton.tap()
        
        let homeNavigationBar = app.navigationBars["Home"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: homeNavigationBar, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreateAccountWithInvalidCredentials() {
        let accountName = "testaccount0011"
        let app = XCUIApplication()
        
        let createAccountTextfield = app.textFields["Enter AccountName"]
        XCTAssertTrue(createAccountTextfield.exists)
        createAccountTextfield.tap()
        createAccountTextfield.typeText(accountName)
        
        let createAccountButton = app.buttons["Create Account"].staticTexts["Create Account"]
        XCTAssertTrue(createAccountButton.exists)
        createAccountButton.tap()
        
        let alert = app.alerts["Error"].scrollViews.otherElements.buttons["ok"]
        alert.tap()
    }

}
