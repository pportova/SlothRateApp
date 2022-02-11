//
//  SlothRateSwiftUIUITestsLaunchTests.swift
//  SlothRateSwiftUIUITests
//
//  Created by Polina Portova on 01.12.2021.
//

import XCTest

class SlothRateSwiftUIUITestsLaunchTests: XCTestCase {

  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()
    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
