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
        healthQueryType: Query.Type,
        healthOptionsType: QueryOptions.Type,
        healthQuantityType: QuantityType.Type,
        healthTypeIdentifier: QuantityTypeIdentifier.Type,
        healthStaticticsOptions: StaticticsOptions.Type,
        queryProvider: QueryProviderProtocol,
        healthStore: HealthStore,
        pickedDate: Date,
        completion: @escaping (Double) -> Void
    ) {

        guard let stepsQuantityType = healthQuantityType.quantityType(forIdentifier: healthTypeIdentifier.stepCountIdentifier) else { return }

        let dayIntervals = pickedDate.startAndEndOfDate(calendar: calendar)

        let predicate = healthQueryType.predicateForSamples(
            withStart: dayIntervals.start,
            end: dayIntervals.end,
            options: healthOptionsType.startDate)

        let statisticsQuery = queryProvider.makeQuery(quantityType: stepsQuantityType, predicate: predicate, options: healthStaticticsOptions.cumulativeSumOption, completion: { result in
            completion(result)
        })
        
        self.executeQuery(statisticsQuery: statisticsQuery, store: healthStore)
    }

    
    func executeQuery(statisticsQuery: StaticticsQuery?, store: HealthStore) -> Void {
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
    func makeQuery(quantityType: QuantityType, predicate: NSPredicate?, options: StaticticsOptions, completion: @escaping (Double) -> (Void)) -> StaticticsQuery?
}

struct QueryProvider: QueryProviderProtocol {
    func makeQuery(quantityType: QuantityType, predicate: NSPredicate?, options: StaticticsOptions, completion: @escaping (Double) -> (Void)) -> StaticticsQuery? {
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
//    static var current: Calendar { get }
    func isDateInToday(_ date: Date) -> Bool
    func startOfDay(for date: Date) -> Date
    func nextDate(after date: Date, matching components: DateComponents, matchingPolicy: Calendar.MatchingPolicy, repeatedTimePolicy: Calendar.RepeatedTimePolicy, direction: Calendar.SearchDirection) -> Date?
}




protocol HealthStore {
    func execute(_ query: Query)
}

protocol QuantityType {
    static func quantityType(forIdentifier identifier: QuantityTypeIdentifier) -> QuantityType?
}

protocol QuantityTypeIdentifier {
    static var stepCountIdentifier: QuantityTypeIdentifier { get }
}

protocol StaticticsOptions {
    static var cumulativeSumOption: StaticticsOptions { get }
}

protocol StaticticsQuery { }

protocol Query {
    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: QueryOptions) -> NSPredicate
}

protocol QueryOptions {
    static var startDate: QueryOptions { get }
}


//MARK: Extensions

extension Calendar: AppCalendar {
}

extension HKHealthStore: HealthStore {
    func execute(_ query: Query) {  execute(query as! HKQuery)}
}

extension HKQuery: Query {
    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: QueryOptions) -> NSPredicate {
        return predicateForSamples(withStart: startDate, end: endDate, options: options as! HKQueryOptions)
    }
}

extension HKQueryOptions: QueryOptions {
    static var startDate: QueryOptions { strictStartDate }
}

extension HKStatisticsOptions: StaticticsOptions {
    static var cumulativeSumOption: StaticticsOptions { cumulativeSum }
}

extension HKQuantityTypeIdentifier: QuantityTypeIdentifier {
    static var stepCountIdentifier: QuantityTypeIdentifier { stepCount }
}

extension HKQuantityType: QuantityType {
    static func quantityType(forIdentifier identifier: QuantityTypeIdentifier) -> QuantityType? {
        return quantityType(forIdentifier: identifier as! HKQuantityTypeIdentifier)
    }
}

extension HKStatisticsQuery: StaticticsQuery { }

extension Date {
    
    func startAndEndOfDate(calendar: AppCalendar) -> (start: Date, end: Date)  {
        let startOfDay = calendar.startOfDay(for: self)
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        let nextDate = calendar.nextDate(after: startOfDay, matching: components, matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward) ?? Date()
        
        let endOfDay = calendar.isDateInToday(self) ? Date() : nextDate
        
        return (start: startOfDay, end: endOfDay)
    }

}
