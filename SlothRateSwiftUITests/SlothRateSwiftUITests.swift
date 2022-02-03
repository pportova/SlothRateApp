//
//  SlothRateSwiftUITests.swift
//  SlothRateSwiftUITests
//
//  Created by Polina Portova on 01.12.2021.
//

import XCTest
@testable import SlothRateSwiftUI

class MockCalendar: AppCalendar {
  func isDateInToday(_ date: Date) -> Bool { true }
  func startOfDay(for date: Date) -> Date { Date() }
  func nextDate(after date: Date, matching components: DateComponents, matchingPolicy: Calendar.MatchingPolicy, repeatedTimePolicy: Calendar.RepeatedTimePolicy, direction: Calendar.SearchDirection) -> Date? { Date() }
}

class MockHealthQuery: Query {
  static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: QueryOptions) -> NSPredicate {
    return NSPredicate()
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

class MockStatisticsQuery: StaticticsQuery { }

struct MockQueryProvider: QueryProviderProtocol {
  let steps: Double = 30.0
  func makeQuery(quantityType: QuantityType, predicate: NSPredicate?, options: StaticticsOptions, completion: @escaping (Double) -> (Void)) -> StaticticsQuery? {
    completion(steps)
    return MockStatisticsQuery()
  }

class SlothRateSwiftUITests: XCTestCase {
  var sutViewModel: StepsCounterViewModel!
  var sutModel: StepsCounter!
  var mockHealthStore: MockHealthStore!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sutViewModel = StepsCounterViewModel()
    sutModel = StepsCounter()
    mockHealthStore = MockHealthStore()
  }

  override func tearDownWithError() throws {
    sutViewModel = nil
    sutModel = nil
    mockHealthStore = nil
    try super.tearDownWithError()
  }
    
  func testGetSlothRate() {
    sutViewModel.countResult = 2000
        
    let result = sutViewModel.getSlothRate()
        
    XCTAssertEqual(result.0, 2)
    XCTAssertEqual(result.1, "A benchmark for laziness.\n Yet showing evidence of motion.")
  }
    
  func testcheckTheDate() {
    let currentDate = Date(timeIntervalSinceReferenceDate: 0.0)
        
    sutViewModel.checkTheDate(currentDate: currentDate)
        
    XCTAssertFalse(sutViewModel.isDateInToday)
  }
    
  func testCalendar() {
    let calendar = MockCalendar()
    let today = Date()
    let dayInPast = today.addingTimeInterval(-1728009)
    let tomorrow = today.addingTimeInterval(86400)
    let dayAfterTomorrow = today.addingTimeInterval(172800)
    let components = DateComponents(hour: 12, minute: 0, second: 0)
    var resultDate = Date()
        
    let tomorrowCheckFails = calendar.isDateInToday(tomorrow)
    resultDate = calendar.nextDate(after: tomorrow, matching: components, matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward) ?? tomorrow

    XCTAssertTrue(tomorrowCheckFails, "MockCalendar always returns true")
        
    XCTAssertLessThan(dayInPast, resultDate, "The day in the past should be less than current date.")

    XCTAssertGreaterThan(dayAfterTomorrow, resultDate, "The function nextDate dailed - its result is tomorrow while it should be today.")
  }
    
  func testGetTodaysSteps() {
    let pickedDate = Date(timeIntervalSinceReferenceDate: 0.0)
    let calendar = MockCalendar()
    let expectation = expectation(description: "Completion handler isn't called")

    sutModel.getTodaysSteps(
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
        XCTAssertTrue(result == 30.0, "Completion wasn't called.")
        expectation.fulfill()
      }
      wait(for: [expectation], timeout: 5)
    }
    }
}
