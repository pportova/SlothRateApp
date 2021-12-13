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
    

    private let healthStore = HKHealthStore()
        
    func getTodaysSteps(pickedDate: Date, completion: @escaping (Double) -> Void) {
        var predicate = NSPredicate()
        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
            
        let dateToCalculate = Date()
        if pickedDate == dateToCalculate {
            let startOfDay = Calendar.current.startOfDay(for: dateToCalculate)
            predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: dateToCalculate,
                options: .strictStartDate
            )
        } else {
            let startOfDay = Calendar.current.startOfDay(for: pickedDate)
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

}
