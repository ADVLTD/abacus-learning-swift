//
//  NearUITests.swift
//  NearUITests
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import XCTest

class SignInUITests: XCTestCase {
    
    func testSignInWithValidCredentials() {
        //Data to be passed in the textfield.
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project human"
        
        let app = XCUIApplication()
        //SignIn button object
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //Asserting if signin button is present on screen.
        XCTAssertTrue(signInButton.exists)
        //Signin button tapped.
        signInButton.tap()

        //PassphraseTextfield object.
        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        //Asserting if the textField is persent or not.
        XCTAssertTrue(enterPassphraseTextField.exists)
        //PassphraseTextfield tapped for typing.
        enterPassphraseTextField.tap()
        //The passPhrase given above is typed.
        enterPassphraseTextField.typeText(passPhrase)
        //SignIn button tapped.
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        //Asserting if homeController is present after successfull SignIn.
        let homeNavigationBar = app.navigationBars["Home"]
        //Expectation for making sure the amount of time is given for server to respond back.
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: homeNavigationBar, handler: nil)
        //Wait for fulfilling the expectations.
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testSignInWithinvalidCredentials() {
        //Data to be passed in the textfield.
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project"
        
        let app = XCUIApplication()
        //SignIn button object
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //Asserting if signin button is present on screen.
        XCTAssertTrue(signInButton.exists)
        //Signin button tapped.
        signInButton.tap()

        //PassphraseTextfield object.
        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        //Asserting if the textField is persent or not.
        XCTAssertTrue(enterPassphraseTextField.exists)
        //PassphraseTextfield tapped for typing.
        enterPassphraseTextField.tap()
        //The passPhrase given above is typed.
        enterPassphraseTextField.typeText(passPhrase)
        //SignIn button tapped.
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        //Error alert shown for wrong passPhrase.
        app.alerts["Error"].scrollViews.otherElements.buttons["ok"].tap()
    }
    
    func testLogout() {
        //Data to be passed in the textfield.
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project human"
        
        let app = XCUIApplication()
        //SignIn button object
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //Asserting if signin button is present on screen.
        XCTAssertTrue(signInButton.exists)
        //Signin button tapped.
        signInButton.tap()

        //PassphraseTextfield object.
        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        //Asserting if the textField is persent or not.
        XCTAssertTrue(enterPassphraseTextField.exists)
        //PassphraseTextfield tapped for typing.
        enterPassphraseTextField.tap()
        //The passPhrase given above is typed.
        enterPassphraseTextField.typeText(passPhrase)
        //SignIn button tapped.
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        //Asserting if homeController is present after successfull SignIn.
        let homeNavigationBar = app.navigationBars["Home"]
        //Waiting for expectation to fullFill.
        waitForExpectations(timeout: 20, handler: nil)
        //Logout button object.
        let logoutButton = app.navigationBars["Home"].buttons["rectangle.portrait.and.arrow.right"]
        //Asserting if logout button exists on screen or not.
        XCTAssertTrue(logoutButton.exists)
        //Logout button tapped to logout from the account.
        logoutButton.tap()
    }
    
    func testAllNavigationsInApp() {
        //Data to be passed in the textfield.
        let passPhrase = "next morning badge tomato walk banner behind little holiday invest project human"
        
        let app = XCUIApplication()
        //SignIn button object
        let signInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Already have an account?  Sign In"]/*[[".buttons[\"Already have an account?  Sign In\"].staticTexts[\"Already have an account?  Sign In\"]",".staticTexts[\"Already have an account?  Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //Asserting if signin button is present on screen.
        XCTAssertTrue(signInButton.exists)
        //Signin button tapped.
        signInButton.tap()

        //PassphraseTextfield object.
        let enterPassphraseTextField = app.textFields["Enter PassPhrase"]
        //Asserting if the textField is persent or not.
        XCTAssertTrue(enterPassphraseTextField.exists)
        //PassphraseTextfield tapped for typing.
        enterPassphraseTextField.tap()
        //The passPhrase given above is typed.
        enterPassphraseTextField.typeText(passPhrase)
        //SignIn button tapped.
        app.buttons["Sign In"].staticTexts["Sign In"].tap()
        //Playing the 2nd video in the home screen.
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Near Video 2").element.tap()
        //Asserting if homeController is present after successfull playing of the video.
        let homeNavigationBar = app.navigationBars["Home"]
        //Expectation for waiting for the video to finish
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: homeNavigationBar, handler: nil)
        //Wait for 70 secs as the vdeo will play.
        waitForExpectations(timeout: 70, handler: nil)
        //Tapping the settings button on nav bar.
        homeNavigationBar.buttons["settings"].tap()
        //Tapping on the activity in the recent Activity table.
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Activity: Method called"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Done"]/*[[".buttons[\"Done\"].staticTexts[\"Done\"]",".staticTexts[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //Tapping on the invite friend button.
        app/*@START_MENU_TOKEN@*/.staticTexts["Invite Friend"]/*[[".buttons[\"Invite Friend\"].staticTexts[\"Invite Friend\"]",".staticTexts[\"Invite Friend\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //Generate link drop object.
        let generateTextfield = app.textFields["Enter Amount"]
        //Asserting if generateLinkDropTextFields is present or not
        XCTAssertTrue(generateTextfield.exists)
        //Tapping on the textfield to type the text.
        generateTextfield.tap()
        //Typing in the required text.
        generateTextfield.typeText("2")
        //Generate LinkDRop button object.
        let generateButton = app.buttons["Generate"]
        //GenerateLinkDropButton tapped.
        generateButton.tap()
        //Expectation to complete the server call for generating the link drop.
        let expectation = self.expectation(description: "It should fail or pass to create a link drop!")
        //Expectation fullfilled.
        expectation.fulfill()
        //Wait for 20secs or untill the expectation is fullfilled.
        waitForExpectations(timeout: 20, handler: nil)
    }
}
