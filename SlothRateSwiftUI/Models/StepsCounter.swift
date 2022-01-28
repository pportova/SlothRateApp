//
//  StepsCounter.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 07.12.2021.
//

import CoreMotion
import HealthKit

class StepsCounter: NSObject, ObservableObject {
    
    private enum HealthKitError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case staticticsQueryNotCreated
    }

    func getTodaysSteps(
        calendar: AppCalendar,
        healthQueryType: HealthQuery.Type,
        healthOptionsType: HealthOptions.Type,
        healthQuantityType: HealthQuantityType.Type,
        healthTypeIdentifier: HealthTypeIdentifier.Type,
        healthStaticticsOptions: HealthStaticticsOptions.Type,
        queryProvider: QueryProviderProtocol,
        healthStore: HealthStore,
        pickedDate: Date,
        completion: @escaping (Double) -> Void
    ) {

        guard let stepsQuantityType = healthQuantityType.quantityType(forIdentifier: healthTypeIdentifier.stepCount) else { return }

        let dayIntervals = pickedDate.startAndEndOfDate(calendar: calendar)
//        
//        let now = Date()
//        let startOfDay = calendar.startOfDay(for: pickedDate)
//        let endOfDay = calendar.isDateInToday(pickedDate) ? now : startOfDay.endOfDay(startOfDay: startOfDay)
//        let predicate = healthQueryType.predicateForSamples(
//            withStart: startOfDay,
//            end: endOfDay,
//            options: healthOptionsType.strictStartDate)
        
        let predicate = healthQueryType.predicateForSamples(
            withStart: dayIntervals.start,
            end: dayIntervals.end,
            options: healthOptionsType.strictStartDate)

        let statisticsQuery = queryProvider.makeQuery(quantityType: stepsQuantityType, predicate: predicate, options: healthStaticticsOptions.cumulativeSum) { result in
            completion(result)
        }
        
        self.executeQuery(statisticsQuery: statisticsQuery, store: healthStore)
    }

    
    func executeQuery(statisticsQuery: HealthStaticticsQuery?, store: HealthStore) -> Void {
        if let realQuery = statisticsQuery as? HKStatisticsQuery {
            store.execute(realQuery)
        }
    }

    
    class func authorizeHealthKit(viewModel: StepsCounterViewModel, date: Date, completion: @escaping (Bool, Error?) -> (Void)) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitError.notAvailableOnDevice)
            return
        }
        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthKitError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepsQuantityType]
        HKHealthStore().requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
            if success {
                viewModel.countStepsAndCheckDate(currentDate: date)
            }
            completion(success, error)
        }
    }
}

//MARK: Protocols

protocol QueryProviderProtocol {
    func makeQuery(quantityType: HealthQuantityType, predicate: NSPredicate?, options: HealthStaticticsOptions, completion: @escaping (Double) -> (Void)) -> HealthStaticticsQuery?
}

struct QueryProvider: QueryProviderProtocol {
    func makeQuery(quantityType: HealthQuantityType, predicate: NSPredicate?, options: HealthStaticticsOptions, completion: @escaping (Double) -> (Void)) -> HealthStaticticsQuery? {
        if let realQuantityType = quantityType as? HKQuantityType, let realOptions = options as? HKStatisticsOptions {

            let query = HKStatisticsQuery(quantityType: realQuantityType, quantitySamplePredicate: predicate, options: realOptions) {
                _, statictics, _ in
                guard let statistics = statictics, let sum = statistics.sumQuantity() else {
                    completion(0.0)
                    return}
                completion(sum.doubleValue(for: HKUnit.count()))
            }
            return query
        }
        return nil
    }
}

protocol AppCalendar {
    static var current: Calendar { get }
    func isDateInToday(_ date: Date) -> Bool
    func startOfDay(for date: Date) -> Date
    func nextDate(after date: Date, matching components: DateComponents, matchingPolicy: Calendar.MatchingPolicy, repeatedTimePolicy: Calendar.RepeatedTimePolicy, direction: Calendar.SearchDirection) -> Date?
    
}

protocol HealthStore {
    func execute(_ query: HKQuery)
}

protocol HealthQuantityType {
    static func quantityType(forIdentifier identifier: HKQuantityTypeIdentifier) -> HKQuantityType?
}


protocol HealthTypeIdentifier {
    static var stepCount: HKQuantityTypeIdentifier { get }
}

protocol HealthStaticticsOptions {
    static var cumulativeSum: HKStatisticsOptions { get }
}

protocol HealthStaticticsQuery { }

protocol HealthQuery {
    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HKQueryOptions) -> NSPredicate
}

protocol HealthOptions {
    static var strictStartDate: HKQueryOptions { get }
}


//MARK: Extensions

extension Calendar: AppCalendar { }

extension HKHealthStore: HealthStore { }

extension HKQuery: HealthQuery { }

extension HKQueryOptions: HealthOptions { }

extension HKStatisticsOptions: HealthStaticticsOptions{ }

extension HKQuantityTypeIdentifier: HealthTypeIdentifier { }

extension HKQuantityType: HealthQuantityType { }

extension HKStatisticsQuery: HealthStaticticsQuery { }

extension Date {
    
    func startAndEndOfDate(calendar: AppCalendar) -> (start: Date, end: Date)  {
        let startOfDay = calendar.startOfDay(for: self)
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        let nextDate = calendar.nextDate(after: startOfDay, matching: components, matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward)
        
        let endOfDay = calendar.isDateInToday(self) ? Date() : nextDate ?? Date()
        
        return (start: startOfDay, end: endOfDay)

    }
    
    
    
    func endOfDay(startOfDay: Date) -> Date{
        var components = DateComponents()
        components.day = 1
        components.second = -1
        guard let resultDate = Calendar.current.date(byAdding: components, to: startOfDay) else {
            print("Issues with getting end of the day.")
            return startOfDay
        }
        return resultDate
    }
    
}
