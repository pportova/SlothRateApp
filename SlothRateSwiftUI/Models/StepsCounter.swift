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
    
    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
        
    func getTodaysSteps(calendar: AppCalendar,store: HealthStore, pickedDate: Date, completion: @escaping (Double) -> Void) {
        let healthStore = HKHealthStore()
        
        var predicate = NSPredicate()
        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
                
        let dateToCalculate = Date()
        
        let formattedPickedDate = formattingDate(date: pickedDate)
        let formattedDateToCalculate = formattingDate(date: dateToCalculate)
            
        if Calendar.current.isDateInToday(pickedDate) {
            let startOfDay = Calendar.current.startOfDay(for: formattedDateToCalculate)
            predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: formattedDateToCalculate,
                options: .strictStartDate
            )
        } else {
            let startOfDay = Calendar.current.startOfDay(for: formattedPickedDate)
            let endOfDay = startOfDay.endOfDay(startOfDay: startOfDay)
            predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: endOfDay,
                options: .strictStartDate)
        }
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
                
            healthStore.execute(query)
        }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
          completion(false, HealthkitSetupError.notAvailableOnDevice)
          return
        }
        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
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

//func formattedDate(date: inout Date) {
//    let current = NSLocale.current.identifier
//    let dayFormatter = DateFormatter()
//    dayFormatter.locale = Locale(identifier: current)
//    let conversionResult = dayFormatter.string(from: date)
//    date = dayFormatter.date(from: conversionResult) ?? date
//}

protocol AppCalendar {
    func startOfDay(for date: Date) -> Date
}

//protocol HealthStore {
//    func execute(_ query: HKQuery)
//}

protocol HealthStore {
    func execute(_ query: HealthQuery)
}

protocol HealthQuery {
    func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HealthOptions) -> NSPredicate
}

protocol HealthOptions {
    
}
//extension HealthStore {
//    func execute(_ query: HealthQuery) {
//        if let realQuery == query as? HKQuery {
//            execute(realQuery)
//        }
//    }
//}


extension Calendar: AppCalendar { }

//extension HKHealthStore: HealthStore { }
extension HKHealthStore: HealthStore {
    func execute(_ query: HealthQuery) {
        if let realQuery = query as? HKQuery {
            execute(realQuery)
        }
    }
}

extension HKQuery: HealthQuery {
    func predicateForSamples(withStart startDate: Date?, end endDate: Date?, options: HealthOptions) -> NSPredicate {
        var predicate = NSPredicate()
        if let realOptions = options as? HKQueryOptions {
           predicate = predicateForSamples(withStart: startDate, end: endDate, options: realOptions)
        }
        return predicate
    }
}
 
extension HKQueryOptions: HealthOptions {
    init(){
        self = []
    }
}



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
