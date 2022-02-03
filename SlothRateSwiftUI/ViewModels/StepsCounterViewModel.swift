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
  
  @Published var currentDate = Date()
  @Published var countResult = Double()
  @Published var isDateInToday = Bool()
  @Published var slothRate = Int()
  @Published var activityDescription = String()
    
  private var stepsCounter = StepsCounter()
  private var queryProvider = QueryProvider()
  private var today = Date()
  
//    MARK: Functions
  func countStepsAndCheckDate(currentDate: Date) {
        
    stepsCounter.getTodaysSteps(calendar: Calendar(identifier: .gregorian), healthQueryType: HKQuery.self, healthOptionsType: HKQueryOptions.self, healthQuantityType: HKQuantityType.self, healthTypeIdentifier: HKQuantityTypeIdentifier.self, healthStaticticsOptions: HKStatisticsOptions.self, queryProvider: queryProvider, healthStore: HKHealthStore(), pickedDate: currentDate, completion: { result in
          DispatchQueue.main.async {
            self.countResult = result
            self.slothRate = self.getSlothRate().0
            self.activityDescription = self.getSlothRate().1
          }
    })
    self.checkTheDate(currentDate: currentDate)
  }

  func checkTheDate(currentDate: Date) {
    DispatchQueue.main.async {
      self.isDateInToday = Calendar.current.isDateInToday(currentDate)
    }
  }
    
  func getSlothRate() -> (Int, String) {
    if countResult < 1500 {
      slothRate = 1
      activityDescription = "Best of the breed.\n A genuinely stationary sloth."
    } else if countResult >= 1500 && countResult < 3000 {
      slothRate = 2
      activityDescription = "A benchmark for laziness.\n Yet showing evidence of motion."
    } else if countResult >= 3000 && countResult < 4500 {
      slothRate = 3
      activityDescription = "Well, you're up.\n Got the pictures moving in front of you."
    } else if countResult >= 4500 && countResult < 6000 {
      slothRate = 4
      activityDescription = "Making progress.\n Went way beyond the morning routine."
    } else if countResult >= 6000 && countResult < 7500 {
      slothRate = 5
      activityDescription = "Moderately active.\n Getting some calories burnt in vain."
    } else if countResult >= 7500 && countResult < 9000 {
      slothRate = 6
      activityDescription = "Not-so-sloth.\n Making fun of your lazy friends."
    } else if countResult >= 9000 && countResult < 11500 {
      slothRate = 7
      activityDescription = "Active.\n Putting those joints to good use."
    } else if countResult >= 11500 && countResult < 13500 {
      slothRate = 8
      activityDescription = "Suspiciously active.\n Evolving into other species rapidly."
    } else if countResult >= 13500 && countResult < 15500 {
      slothRate = 9
      activityDescription = "A true doer.\n Planned or not planned, got it all done."
    } else if countResult >= 15500 && countResult < 17500 {
      slothRate = 10
      activityDescription = "Hyperactive.\n Are you a sloth really?"
    } else if countResult >= 17500 && countResult < 19500 {
      slothRate = 11
      activityDescription = "An energy vortex.\n You're generating new particle types."
    } else if countResult >= 19500 {
      slothRate = 12
      activityDescription = "An undercover cheetah.\n Ran too fast, straight out of juice."
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
