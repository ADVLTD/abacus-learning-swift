//
//  NearUITests.swift
//  NearUITests
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import XCTest

class SignInUITests: XCTestCase {
    
    func testSignInWithValidCredentials() {
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project human"
        
        let app = XCUIApplication()
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signInButton.exists)
        signInButton.tap()

        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        XCTAssertTrue(enterPassphraseTextField.exists)
        enterPassphraseTextField.tap()
        enterPassphraseTextField.typeText(passPhrase)
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        let homeNavigationBar = app.navigationBars["Home"]
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: homeNavigationBar, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testSignInWithinvalidCredentials() {
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project"
        
        let app = XCUIApplication()
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signInButton.exists)
        signInButton.tap()

        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        XCTAssertTrue(enterPassphraseTextField.exists)
        enterPassphraseTextField.tap()
        enterPassphraseTextField.typeText(passPhrase)
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        app.alerts["Error"].scrollViews.otherElements.buttons["ok"].tap()
    }
    
    func testLogout() {
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project human"
        
        let app = XCUIApplication()
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signInButton.exists)
        signInButton.tap()

        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        XCTAssertTrue(enterPassphraseTextField.exists)
        enterPassphraseTextField.tap()
        enterPassphraseTextField.typeText(passPhrase)
        
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        
        let homeNavigationBar = app.navigationBars["Home"]
        
        waitForExpectations(timeout: 20, handler: nil)
        
        let logoutButton = app.navigationBars["Home"].buttons["rectangle.portrait.and.arrow.right"]
        XCTAssertTrue(logoutButton.exists)
        logoutButton.tap()
    }
    
    func testAllNavigationsInApp() {
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project human"
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        enterPassphraseTextField.tap()
        enterPassphraseTextField.typeText(passPhrase)
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Near Video 2").element.tap()
        
        let homeNavigationBar = app.navigationBars["Home"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: homeNavigationBar, handler: nil)
        waitForExpectations(timeout: 70, handler: nil)
        
        homeNavigationBar.buttons["settings"].tap()
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Activity: Method called"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Done"]/*[[".buttons[\"Done\"].staticTexts[\"Done\"]",".staticTexts[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Invite Friend"]/*[[".buttons[\"Invite Friend\"].staticTexts[\"Invite Friend\"]",".staticTexts[\"Invite Friend\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let generateTextfield = app.textFields["Enter Amount"]
        XCTAssertTrue(generateTextfield.exists)
        generateTextfield.tap()
        generateTextfield.typeText("2")
        
        let generateButton = app.buttons["Generate"]
        generateButton.tap()
        let expectation = self.expectation(description: "It should fail or pass to create a link drop!")
        expectation.fulfill()
        waitForExpectations(timeout: 20, handler: nil)
    }
}
