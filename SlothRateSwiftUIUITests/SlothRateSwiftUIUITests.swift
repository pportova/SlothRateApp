//
//  SlothRateSwiftUIUITests.swift
//  SlothRateSwiftUIUITests
//
//  Created by Polina Portova on 01.12.2021.
//

import XCTest

class SlothRateSwiftUIUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testNavigationButtons() throws {

        let leftButton = app.buttons["Back"]
        let rightButton = app.buttons["Forward"]
                
        XCTAssert(leftButton.exists)
        XCTAssert(rightButton.exists)

    }
    
    func testLabelsExist() throws {
        let mainLabel = app.staticTexts["What sloth\nare you today?"]
        let stepsLabel = app.staticTexts["steps taken"]
        
        XCTAssertEqual(mainLabel.label, "What sloth\nare you today?")
        XCTAssertEqual(stepsLabel.label, "steps taken")
        
    }
    

    
        
}
