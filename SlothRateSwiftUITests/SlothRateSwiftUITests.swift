//
//  SlothRateSwiftUITests.swift
//  SlothRateSwiftUITests
//
//  Created by Polina Portova on 01.12.2021.
//

import XCTest
@testable import SlothRateSwiftUI

// 1 parameter
class MockCalendar: AppCalendar {
    func isDateInToday(_ date: Date) -> Bool { true }
    func startOfDay(for date: Date) -> Date { Date() }
    func nextDate(after date: Date, matching components: DateComponents, matchingPolicy: Calendar.MatchingPolicy, repeatedTimePolicy: Calendar.RepeatedTimePolicy, direction: Calendar.SearchDirection) -> Date? { nil }

}

// 2 parameter
class MockHealthQuery: Query {
    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: QueryOptions) -> NSPredicate {
        NSPredicate()
    }
}




struct MockQueryOptions: QueryOptions, OptionSet {
    let rawValue: Int
    static var startDate: QueryOptions = MockQueryOptions(rawValue: 1 << 0)
}

struct MockStaticticsOptions: StaticticsOptions {
    let rawValue: UInt

    static var cumulativeSumOption: StaticticsOptions = MockStaticticsOptions(rawValue: 1 << 0)
}

struct MockQuantityTypeIdentifier: QuantityTypeIdentifier {
    let rawValue: String

    static let stepCountIdentifier: QuantityTypeIdentifier = MockQuantityTypeIdentifier(rawValue: "")
}

class MockQuantityType: QuantityType {
    static func quantityType(forIdentifier identifier: QuantityTypeIdentifier) -> QuantityType? {
        return MockQuantityType()
    }
}


class MockHealthStore: HealthStore {
    func execute(_ query: Query) { }
}


class MockStatisticsQuery: StaticticsQuery {
}

struct MockQueryProvider: QueryProviderProtocol {
    func makeQuery(quantityType: QuantityType, predicate: NSPredicate?, options: StaticticsOptions, completion: @escaping (Double) -> (Void)) -> StaticticsQuery? {
        return nil//MockStatisticsQuery()
    }
}

class SlothRateSwiftUITests: XCTestCase {
    
    var sutViewModel: StepsCounterViewModel!
    
    
    
    
    var sut: StepsCounter!
    var mockHealthStore: MockHealthStore!
//    
//
    override func setUpWithError() throws {
        try super.setUpWithError()
        sutViewModel = StepsCounterViewModel()
        sut = StepsCounter()
        mockHealthStore = MockHealthStore()
    }

    override func tearDownWithError() throws {
//        sut = nil
//        mockHealthStore = nil
        sutViewModel = nil
        try super.tearDownWithError()
    }
    
    func testGetSlothRate() {
        sutViewModel.countResult = 2000
        
        let result = sutViewModel.getSlothRate()
        
        XCTAssertEqual(result.0, 1)
        XCTAssertEqual(result.1, "Best of the breed.\n A genuinely stationary sloth.")
    }
    
    func testcheckTheDate() {
        let currentDate = Date(timeIntervalSinceReferenceDate: 0.0)
        
        sutViewModel.checkTheDate(currentDate: currentDate)
        
        XCTAssertFalse(sutViewModel.isDateInToday)
    }
    
    
    func testGetTodaysSteps() {

        let pickedDate = Date(timeIntervalSinceReferenceDate: 0.0)
        let calendar = MockCalendar()
        var countResult = 0.0
        let promise = expectation(description: "16000")

        sut.getTodaysSteps(
            calendar: calendar,
            healthQueryType: MockHealthQuery.self,
            healthOptionsType: MockQueryOptions.self,
            healthQuantityType: MockQuantityType.self,
            healthTypeIdentifier: MockQuantityTypeIdentifier.self,
            healthStaticticsOptions: MockStaticticsOptions.self,
            queryProvider: MockQueryProvider(),
            healthStore: mockHealthStore,
            pickedDate: pickedDate
        ) { (result) in
            countResult = result
        }

        wait(for: [promise], timeout: 5)

        XCTAssertEqual(countResult, 16000, "Something went wrong")
    }
}
