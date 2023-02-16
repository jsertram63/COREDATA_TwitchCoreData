//
//  TwichCoreData_swift_4fev2023UITestsLaunchTests.swift
//  TwichCoreData_swift_4fev2023UITests
//
//  Created by Lunack on 04/02/2023.
//

import XCTest

final class TwichCoreData_swift_4fev2023UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
