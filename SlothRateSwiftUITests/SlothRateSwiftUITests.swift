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

struct MockStaticticsOptions: HealthStaticticsOptions {
    let rawValue: UInt
    
    static var cumulativeSum = MockStaticticsOptions(rawValue: 1 << 0)
}

struct MockHealthTypeIdentifier: HealthTypeIdentifier {
    let rawValue: String
    
    static let stepCount = MockHealthTypeIdentifier(rawValue: "")
}

class MockQuantityType: HealthQuantityType {
    var quantityType: HealthQuantityType?
    func quantityType(forIdentifier identifier: HealthTypeIdentifier) -> HealthQuantityType? {
        return quantityType
    }  
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
    func execute(_ query: HealthQuery) {
    }
}

class MockCalendar: AppCalendar {
    let startOfDay = Date(timeIntervalSinceReferenceDate: 0.0) // 1 jan 2001
    let isToday = false
    func startOfDay(for date: Date) -> Date {
        return startOfDay
    }
    func isDateInToday(_ date: Date) -> Bool {
        return isToday
    }
}

class MockStatistics: HealthStatistics {
}

class MockStatisticsQuery: HealthStaticticsQuery {
    init(quantityType: MockQuantityType, quantitySamplePredicate: NSPredicate?, options: MockStaticticsOptions, completionHandler handler: @escaping (MockStatisticsQuery, MockStatistics?, Error?) -> Void) {
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
        
        let startDate = Date(timeIntervalSinceReferenceDate: 0.0) // 1 jan 2001
        let endDate =  Date(timeIntervalSinceReferenceDate: 100000.0) // 2 jan 2001
        let options = MockOptions(rawValue: 0)
        let query = MockHealthQuery()
        
        let predicate = query.predicateForSamples(withStart: startDate, end: endDate, options: options)
        XCTAssertTrue(query.hasCompleted)
        
    }
    
    func testGetTodaysSteps() {
        
        let pickedDate = Date(timeIntervalSinceReferenceDate: 0.0)
        let store = MockHealthStore()
        let calendar = MockCalendar()
        var countResult = Double()
        let promise = expectation(description: "16000")
        
        sut.getTodaysSteps(calendar: calendar, store: store, pickedDate: pickedDate, completion: { result in
            countResult = result
            promise.fulfill()
         })
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(countResult, 16000, "Something went wrong")

    }


}
