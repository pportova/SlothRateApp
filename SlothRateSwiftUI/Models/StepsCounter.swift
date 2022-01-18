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
    
    private enum HealthKitError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case staticticsQueryNotCreated
    }
        
    func getTodaysSteps(calendar: AppCalendar, healthQueryType: HealthQuery.Type, healthOptionsType: HealthOptions.Type, healthQuantityType: HealthQuantityType.Type, healthTypeIdentifier: HealthTypeIdentifier.Type, healthStaticticsOptions: HealthStaticticsOptions.Type, healthStore: HealthStore, pickedDate: Date, completion: @escaping (Double) -> Void) {
        
            var predicate: NSPredicate
            guard let stepsQuantityType = healthQuantityType.quantityType(forIdentifier: healthTypeIdentifier.stepCount) else { return }
        
            let dateToCalculate = Date()
        
            let formattedPickedDate = formattingDate(date: pickedDate)
            let formattedDateToCalculate = formattingDate(date: dateToCalculate)

            if calendar.isDateInToday(pickedDate) {
                let startOfDay = calendar.startOfDay(for: formattedDateToCalculate)
                predicate = healthQueryType.predicateForSamples(
                    withStart: startOfDay,
                    end: formattedDateToCalculate,
                    options: healthOptionsType.strictStartDate )
            } else {
                let startOfDay = calendar.startOfDay(for: formattedPickedDate)
                let endOfDay = startOfDay.endOfDay(startOfDay: startOfDay)
                predicate = healthQueryType.predicateForSamples(
                    withStart: startOfDay,
                    end: endOfDay,
                    options: healthOptionsType.strictStartDate)
            }
          
        let staticticsQuery = createQuery(quantityType: stepsQuantityType, predicate: predicate, options: healthStaticticsOptions.cumulativeSum) { result in
            completion(result)
        }
        
        self.executeQuery(statisticsQuery: staticticsQuery, store: healthStore)
    }

    
    func executeQuery (statisticsQuery: HealthStaticticsQuery?, store: HealthStore) -> Void {
        if let realQuery = statisticsQuery as? HKStatisticsQuery {
            store.execute(realQuery)
        }
    }
    
    
    func createQuery(quantityType: HealthQuantityType, predicate: NSPredicate?, options: HealthStaticticsOptions, completion: @escaping (Double) -> (Void)) -> HealthStaticticsQuery? {
    
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
 
    
    class func authorizeHealthKit(viewModel: StepsCounterViewModel, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        
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
    


    func formattingDate(date: Date) -> Date {
        var convertedDate = Date()
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = date.timeIntervalSince1970
        let timeZoneWithEpochOffset = epochDate + Double(timezoneOffset)
        convertedDate = Date(timeIntervalSince1970: timeZoneWithEpochOffset)
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

protocol HealthStaticticsQuery { }

protocol HealthQuery {
    static func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HKQueryOptions) -> NSPredicate
}

protocol HealthOptions {
    static var strictStartDate: HKQueryOptions { get }
}
 

//MARK: Extensions

extension Calendar: AppCalendar { }

extension HKHealthStore: HealthStore {
//    func execute(_ query: HealthQuery) {
//        if let realQuery = query as? HKQuery {
//            execute(realQuery)
//        }
//    }
}

extension HKQuery: HealthQuery { }
 
extension HKQueryOptions: HealthOptions { }

extension HKStatisticsOptions: HealthStaticticsOptions{ }

//extension HKQuantity: HealthQuantity{
//    func doubleValue(for unit: HealthUnit) -> Double {
//        var result = Double()
//        if let realUnit = unit as? HKUnit {
//            result = doubleValue(for: realUnit)
//        }
//        return result
//    }
//
//}

extension HKQuantityTypeIdentifier: HealthTypeIdentifier { }

extension HKQuantityType: HealthQuantityType { }

extension HKStatisticsQuery: HealthStaticticsQuery { }

//extension HKUnit: HealthUnit { }

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
