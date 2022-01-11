//
//  SlothRateSwiftUITests.swift
//  SlothRateSwiftUITests
//
//  Created by Polina Portova on 01.12.2021.
//

import XCTest
@testable import SlothRateSwiftUI

struct MockOptions: HealthOptions {
    let rawValue: Int
    
    static let strictStartDate = MockOptions(rawValue: 1 << 0)
    static let strictEndDate  = MockOptions(rawValue: 1 << 1)
}

class MockHealthQuery: HealthQuery {
    let predicate = NSPredicate()
    var hasCompleted = false
    func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HealthOptions) -> NSPredicate {
        hasCompleted = true
        return predicate
    }
    
    
}

class MockHealthStore: HealthStore {
    var steps = 0
    func execute(_ query: HealthQuery) {
        steps += 1000
    }
}

class MockCalendar: AppCalendar {
    let resultDate = Date(timeIntervalSinceReferenceDate: -123456789.0) // Feb 2, 1997
    func startOfDay(for date: Date) -> Date {
        return resultDate
    }
    
    
}

class SlothRateSwiftUITests: XCTestCase {
    
    var sut: StepsCounter!
    var mockHealthStore: MockHealthStore!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StepsCounter()
        mockHealthStore = MockHealthStore()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockHealthStore = nil
        try super.tearDownWithError()
    }

    func testGetPredicate() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: -123456789.0) // Feb 2, 1997
        let endDate =  Date(timeIntervalSinceReferenceDate: -12345640.0) //11 aug 2000
        let options = MockOptions(rawValue: 0)
        let query = MockHealthQuery()
        
        let predicate = query.predicateForSamples(withStart: startDate, end: endDate, options: options)
        XCTAssertTrue(query.hasCompleted)
        
    }


}
