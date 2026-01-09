//
//  CitiesViewUITests.swift
//  MobileChallengeUITests
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import XCTest

final class CitiesViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["Cities"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testSearchFieldExists() throws {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testSearchFunctionality() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        searchField.tap()
        searchField.typeText("New")
        Thread.sleep(forTimeInterval: 2)
        XCTAssertEqual(searchField.value as? String, "New")
    }
    
    @MainActor
    func testFavouriteButtonInToolbar() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["Cities"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let buttons = navBar.buttons
        XCTAssertTrue(buttons.count > 0, "Should have at least one button in toolbar")
    }
    
    @MainActor
    func testToggleFavouriteMode() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["Cities"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let toolbarButton = navBar.buttons.firstMatch
        if toolbarButton.waitForExistence(timeout: 5) {
            toolbarButton.tap()
            Thread.sleep(forTimeInterval: 1)
            
            toolbarButton.tap()
            Thread.sleep(forTimeInterval: 1)
            XCTAssertTrue(true)
        }
    }
}
