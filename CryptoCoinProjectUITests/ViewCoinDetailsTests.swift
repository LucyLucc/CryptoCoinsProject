//
//  ViewCoinDetailsTests.swift
//  CryptoCoinProjectUITests
//
//  Created by Lucy Chetalam on 01/05/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import XCTest

final class ViewCoinDetailsTests: XCTestCase {

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
    
    func testTCoinDetailsPage() throws{
  
        let cellCount = app.tables.cells.count
        XCTAssertTrue(cellCount > 0)

        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        XCTAssert(app.navigationBars["Crypto Coin Details"].exists, " 2nd Navigation Title Not Available")
        app.swipeDown()
        XCTAssertTrue(app.navigationBars["Crypto Coins"].waitForExistence(timeout: 5))
    }
}
