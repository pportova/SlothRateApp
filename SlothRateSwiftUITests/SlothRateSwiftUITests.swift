//
//  SlothRateSwiftUITests.swift
//  SlothRateSwiftUITests
//
//  Created by Polina Portova on 01.12.2021.
//

import XCTest
@testable import SlothRateSwiftUI

// 1 parameter
//class MockCalendar: AppCalendar {
//    static var current: Calendar {
//        get {
//            return self.current
//        }
//    }
//
//    let startOfDay = Date(timeIntervalSinceReferenceDate: 0.0) // 1 jan 2001
//    let isToday = false
//    func startOfDay(for date: Date) -> Date {
//        return startOfDay
//    }
//    func isDateInToday(_ date: Date) -> Bool {
//        return isToday
//    }
//}

//// 2 parameter
//class MockHealthQuery: HealthQuery {
//    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HealthOptions) -> NSPredicate {
//        NSPredicate()
//    }
//}



//
//struct MockOptions: HealthOptions {
//    static var strictStartDate = MockOptions(rawValue: 1 << 0)
//
//}
//
//struct MockStaticticsOptions: HealthStaticticsOptions {
//    let rawValue: UInt
//
//    static var cumulativeSum = MockStaticticsOptions(rawValue: 1 << 0)
//}
//
//struct MockHealthTypeIdentifier: HealthTypeIdentifier {
//    let rawValue: String
//
//    static let stepCount = MockHealthTypeIdentifier(rawValue: "")
//}
//
//class MockQuantityType: HealthQuantityType {
//    var quantityType: HealthQuantityType?
//    func quantityType(forIdentifier identifier: HealthTypeIdentifier) -> HealthQuantityType? {
//        return quantityType
//    }
//}


//class MockHealthStore: HealthStore {
//    func execute(_ query: HKQuery) {
//        <#code#>
//    }
//
//    func execute(_ query: HealthQuery) {
//    }
//}


class MockStatisticsQuery: HealthStaticticsQuery {
//    init(quantityType: MockQuantityType, quantitySamplePredicate: NSPredicate?, options: MockStaticticsOptions, completionHandler handler: @escaping (MockStatisticsQuery, MockStatistics?, Error?) -> Void) {
//    }
}

struct MockQueryProvider: QueryProviderProtocol {
    func makeQuery(quantityType: HealthQuantityType, predicate: NSPredicate?, options: HealthStaticticsOptions, completion: @escaping (Double) -> (Void)) -> HealthStaticticsQuery? {
        return MockStatisticsQuery()
    }
}

class SlothRateSwiftUITests: XCTestCase {
    
    var sutViewModel: StepsCounterViewModel!
    
    
    
    
//    var sut: StepsCounter!
//    var mockHealthStore: MockHealthStore!
//    
//
    override func setUpWithError() throws {
        try super.setUpWithError()
        sutViewModel = StepsCounterViewModel()
//        sut = StepsCounter()
//        mockHealthStore = MockHealthStore()
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
    
    
//    func testGetTodaysSteps() {
//
//        let pickedDate = Date(timeIntervalSinceReferenceDate: 0.0)
//        let calendar = MockCalendar()
//        var countResult: Double
//        let promise = expectation(description: "16000")
//
//
//        sut.getTodaysSteps(
//            calendar: calendar,
//            healthQueryType: MockHealthQuery.self,
//            healthOptionsType: MockOptions.self,
//            healthQuantityType: MockQuantityType.self,
//            healthTypeIdentifier: MockHealthTypeIdentifier.self,
//            healthStaticticsOptions: MockStaticticsOptions.self,
//            queryProvider: MockQueryProvider.self as! QueryProviderProtocol,
//            healthStore: mockHealthStore,
//            pickedDate: pickedDate
//        ) { (result) in
//            countResult = result
//        }
//
//        wait(for: [promise], timeout: 5)
//
//        XCTAssertEqual(countResult, 16000, "Something went wrong")
//
//    }


}
