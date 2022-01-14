//
//  StepsCounter.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 07.12.2021.
//

import Foundation
import CoreMotion
import HealthKit

class StepsCounter: NSObject, ObservableObject {
    
    private enum HealthKitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
        
    func getTodaysSteps(calendar: AppCalendar, healthQueryType: HealthQuery.Type, healthOptionsType: HealthOptions.Type, healthQuantityType: HealthQuantityType.Type, healthTypeIdentifier: HealthTypeIdentifier.Type, healthStaticticsOptions: HKStatisticsOptions.Type, healthStore: HealthStore, pickedDate: Date, completion: @escaping (Double) -> Void) {
        
        var predicate: NSPredicate
        guard let stepsQuantityType = healthQuantityType.quantityType(forIdentifier: healthTypeIdentifier.stepCount) else { return }
        
        let dateToCalculate = Date()
        
        let formattedPickedDate = formattingDate(date: pickedDate)
        let formattedDateToCalculate = formattingDate(date: dateToCalculate)

        if calendar.isDateInToday(pickedDate)
        {
            let startOfDay = calendar.startOfDay(for: formattedDateToCalculate)
            predicate = healthQueryType.predicateForSamples(
                withStart: startOfDay,
                end: formattedDateToCalculate,
                options: healthOptionsType.strictStartDate
            )
        } else {
            let startOfDay = calendar.startOfDay(for: formattedPickedDate)
            let endOfDay = startOfDay.endOfDay(startOfDay: startOfDay)
            predicate = healthQueryType.predicateForSamples(
                withStart: startOfDay,
                end: endOfDay,
                options: healthOptionsType.strictStartDate)
        }
//        let sum = createStatisticQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: healthStaticticsOptions.cumulativeSum).0
//        let query = createStatisticQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: healthStaticticsOptions.cumulativeSum).1
//        var query: HealthStaticticsQuery
//
//        createStatisticQuery(
//            quantityType: stepsQuantityType,
//            quantitySamplePredicate: predicate,
//            options: healthStaticticsOptions.cumulativeSum
//        ){ statisticQuery in
//            query = statisticQuery
//        }
        
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: healthStaticticsOptions.cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
                
        healthStore.execute(query)
        }
//    
//    func createStatisticQuery(quantityType: HealthQuantityType, quantitySamplePredicate: NSPredicate?, options: HealthStaticticsOptions, completion: @escaping (HealthStaticticsQuery) -> ()) {
//
////        var sumResult: HKQuantity
//        var queryResult: HKStatisticsQuery
//
//        if let realQuantityType = quantityType as? HKQuantityType, let realOptions = options as? HKStatisticsOptions {
//            let query = HKStatisticsQuery(
//                quantityType: realQuantityType,
//                quantitySamplePredicate: quantitySamplePredicate,
//                options: realOptions) { _, result, _ in
//                    guard let result = result , let sum = result.sumQuantity() else { return }
//            }
//            queryResult = query
//            completion(queryResult)
//
//    }
//
//    }
 
    
    
    //    init(quantityType: HKQuantityType, quantitySamplePredicate: NSPredicate?, options: HKStatisticsOptions, completionHandler handler: @escaping (HKStatisticsQuery, HKStatistics?, Error?) -> Void)
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
          completion(false, HealthKitSetupError.notAvailableOnDevice)
          return
        }
        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
                    return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepsQuantityType]
        
        HKHealthStore().requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
          completion(success, error)
        }
//        HKHealthStore().handleAuthorizationForExtension(completion: {(success, error) in
//            completion(success, error) })
    }
    


    func formattingDate(date: Date) -> Date {
//        let currentLocale = NSLocale.current.identifier
//        let dayFormatter = DateFormatter()
        var convertedDate = Date()
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        
//        if date != nil {
            let epochDate = date.timeIntervalSince1970
            let timeZoneWithEpochOffset = epochDate + Double(timezoneOffset)
            convertedDate = Date(timeIntervalSince1970: timeZoneWithEpochOffset)
//        }
         return convertedDate
    }
    
}

//MARK: Protocols

protocol AppCalendar {
    static var current: Calendar { get }
    func isDateInToday(_ date: Date) -> Bool
    func startOfDay(for date: Date) -> Date
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

//protocol HealthStatistics {
//    static func sumQuantity() -> HKQuantity?
//}

protocol HealthStaticticsQuery {
    
}

protocol HealthUnit {
    static func count() -> Self
}

protocol HealthQuantity {
    func doubleValue(for unit: HealthUnit) -> Double
    
}

protocol HealthQuery {
    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HKQueryOptions) -> NSPredicate
}

protocol HealthOptions {
    static var strictStartDate: HKQueryOptions { get }
}
 

//MARK: Extensions

extension Calendar: AppCalendar { }

extension HKHealthStore: HealthStore {
    func execute(_ query: HealthQuery) {
        if let realQuery = query as? HKQuery {
            execute(realQuery)
        }
    }
}

extension HKQuery: HealthQuery { }
 
extension HKQueryOptions: HealthOptions { }

extension HKStatisticsOptions: HealthStaticticsOptions{ }

extension HKQuantity: HealthQuantity{
    func doubleValue(for unit: HealthUnit) -> Double {
        var result = Double()
        if let realUnit = unit as? HKUnit {
            result = doubleValue(for: realUnit)
        }
        return result
    }
    
}

extension HKQuantityTypeIdentifier: HealthTypeIdentifier { }

extension HKQuantityType: HealthQuantityType { }

extension HKStatisticsQuery: HealthStaticticsQuery { }

extension HKUnit: HealthUnit { }
//
//extension HKStatistics: HealthStatistics { }
    


extension Date {
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
    
    func formattingDate(date: inout Date) {
        let current = NSLocale.current.identifier
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: current)
        let conversionResult = dayFormatter.string(from: date)
        date = dayFormatter.date(from: conversionResult) ?? date
    }
}
