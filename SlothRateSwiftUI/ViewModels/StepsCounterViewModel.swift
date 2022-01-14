//
//  StepsCounterViewModel.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 08.12.2021.
//

import Foundation
import SwiftUI
import HealthKit

class StepsCounterViewModel: ObservableObject {
    
    private var stepsCounter = StepsCounter()
    private var today = Date()
    
    @Published var countResult = Double()
    @Published var isDateInToday = Bool()
    @Published var slothRate = Int()
    @Published var activityDescription = String()

    
//    MARK: Functions
    func countStepsAndCheckDate(currentDate: Date) {
        
        stepsCounter.getTodaysSteps(calendar: Calendar(identifier: .gregorian), healthQueryType: HKQuery.self, healthOptionsType: HKQueryOptions.self, healthQuantityType: HKQuantityType.self, healthTypeIdentifier: HKQuantityTypeIdentifier.self, healthStaticticsOptions: HKStatisticsOptions.self, healthStore: HKHealthStore(), pickedDate: currentDate, completion: { result in
                        DispatchQueue.main.async {
                            self.countResult = result
                            self.slothRate = self.getSlothRate().0
                            self.activityDescription = self.getSlothRate().1
                        }
        })
        self.checkTheDate(currentDate: currentDate)
//        slothRate = self.getSlothRate().0
//        activityDescription = self.getSlothRate().1
    }

    func checkTheDate(currentDate: Date) {
        isDateInToday = Calendar.current.isDateInToday(currentDate)
    }
    
    func getSlothRate() -> (Int, String) {
//        var slothRate = Int()
//        var activityDescription = ""
        if countResult < 5000 {
            //Sleeping sloth
            slothRate = 1
            activityDescription = "Best of the breed.\n A genuinely stationary sloth."
        } else if countResult > 5000 && countResult < 7500 {
            slothRate = 2
            //Hanging on a branch
            activityDescription = "A benchmark for laziness.\n Yet showing evidence of motion."
        } else if countResult > 7500 && countResult < 10000 {
            slothRate = 3
            //Showing "V"
            activityDescription = "Moderately active.\n Getting some calories burnt in vain."
        } else if countResult > 10000 && countResult < 12500 {
            slothRate = 4
            //Sitting by a computer
            activityDescription = "Suspiciously active.\n Evolving into other species rapidly."
        } else if countResult > 12500 {
            slothRate = 5
            //Climbing a branch
            activityDescription = "Hyperactive.\n Are you a sloth really?"
        }
        return (slothRate, activityDescription)
}
    
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

}
