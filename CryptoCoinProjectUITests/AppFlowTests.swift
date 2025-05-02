//
//  AppFlowTests.swift
//  CryptoCoinProjectUITests
//
//  Created by Lucy Chetalam on 01/05/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import XCTest

final class AppFlowTests: XCTestCase {
    private var app = XCUIApplication()

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDown(){
       super.tearDown()
        
    }

    @MainActor
    func testLaunch() throws {
        app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testNavigationSelection() throws{
        
        XCTAssert(app.navigationBars["Crypto Coins"].exists, "Navigation Title Not Available")
        
    }
    func testNavigationToFavouriteView() {
          
        let favButton = app.buttons["Favourites"]
        XCTAssertTrue(favButton.exists)
        favButton.tap()

        XCTAssert(app.navigationBars["Favourites"].exists, "Favourites Navigation Title Not Available")
       }
   
}
