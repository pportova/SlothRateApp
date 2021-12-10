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
//    
//    private let activityManager = CMMotionActivityManager()
//    private let pedometer = CMPedometer()

        
    private let healthStore = HKHealthStore()
        
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
            
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
