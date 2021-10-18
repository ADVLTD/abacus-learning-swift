//
//  CreateAccountUITests.swift
//  NearUITests
//
//  Created by Bhushan Mahajan on 15/10/21.
//

import XCTest

class CreateAccountUITests: XCTestCase {

    func testCreateAccountWithValidCredentials() {
        //Data to be passed in the textfield.
        let accountName = "testaccount1469"
        let app = XCUIApplication()
        //Object for createAccountTextField
        let createAccountTextfield = app.textFields["Enter AccountName"]
        //Asserting if createAccountTextfield exists or not.
        XCTAssertTrue(createAccountTextfield.exists)
        //Textfield tapped for entering data.
        createAccountTextfield.tap()
        //The data given above is typed into the textfield.
        createAccountTextfield.typeText(accountName)
        //CreateAccountButton Object.
        let createAccountButton = app.buttons["Create Account"].staticTexts["Create Account"]
        //Asserting if createAccountButton exists or not.
        XCTAssertTrue(createAccountButton.exists)
        //CreateAccountButton tapped
        createAccountButton.tap()
        //Continue button object in the passPhraseController.
        let continueButton = app.buttons["Continue"]
        //Expectation for the completion of server call to generate pass pharse and pass it to the passPhraseController.
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: continueButton, handler: nil)
        //Wait for the expectation to complete.
        waitForExpectations(timeout: 20, handler: nil)
        //Continue button tapped.
        continueButton.tap()
        //Asserting if homeController is present after successfull AccountCreation and SignIn.
        let homeNavigationBar = app.navigationBars["Home"]
        //Expectation for making sure the amount of time is given for server to respond back.
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: homeNavigationBar, handler: nil)
        //Wait for fulfilling the expectations.
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreateAccountWithInvalidCredentials() {
        //Data to be passed in the textfield.
        let accountName = "testaccount0011"
        let app = XCUIApplication()
        //Object for createAccountTextField
        let createAccountTextfield = app.textFields["Enter AccountName"]
        //Asserting if createAccountTextfield exists or not.
        XCTAssertTrue(createAccountTextfield.exists)
        //Textfield tapped for entering data.
        createAccountTextfield.tap()
        //The data given above is typed into the textfield.
        createAccountTextfield.typeText(accountName)
        //CreateAccount button object.
        let createAccountButton = app.buttons["Create Account"].staticTexts["Create Account"]
        //Asserting if createAccountButton exists or not.
        XCTAssertTrue(createAccountButton.exists)
        //CreateAccountButton tapped
        createAccountButton.tap()
        //Error alert shown for account alredy exists.
        let alert = app.alerts["Error"].scrollViews.otherElements.buttons["ok"]
        //Ok button tapped on alert to dissmiss it.
        alert.tap()
    }

}
