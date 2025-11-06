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
  
  struct SlothCharacteristics {
    var slothRateValue = Int()
    var slothDescription = String()
    
    enum SlothRateDescription: String, CaseIterable {
      case first = "Best of the breed.\n A genuinely stationary sloth."
      case second = "A benchmark for laziness.\n Yet showing evidence of motion."
      case third = "Well, you're up.\n Got the pictures moving in front of you."
      case fourth = "Making progress.\n Went way beyond the morning routine."
      case fifth = "Moderately active.\n Getting some calories burnt in vain."
      case sixth = "Not-so-sloth.\n Making fun of your lazy friends."
      case seventh = "Active.\n Putting those joints to good use."
      case eighth = "Suspiciously active.\n Evolving into other species rapidly."
      case ninth = "A true doer.\n Planned or not planned, got it all done."
      case tenth = "Hyperactive.\n Are you a sloth really?"
      case eleventh = "An energy vortex.\n You're generating new particle types."
      case twelfth = "An undercover cheetah.\n Ran too fast, straight out of juice."
    }
  }
  
//    MARK: Functions
  func countStepsAndCheckDate(currentDate: Date) {
        
    stepsCounter.getTodaysSteps(calendar: Calendar(identifier: .gregorian), healthQueryType: HKQuery.self, healthOptionsType: HKQueryOptions.self, healthQuantityType: HKQuantityType.self, healthTypeIdentifier: HKQuantityTypeIdentifier.self, healthStaticticsOptions: HKStatisticsOptions.self, queryProvider: queryProvider, healthStore: HKHealthStore(), pickedDate: currentDate, completion: { result in
          DispatchQueue.main.async {
            self.countResult = result
            self.slothRate = self.getSlothRate().slothRateValue
            self.activityDescription = self.getSlothRate().slothDescription
          }
    })
    self.checkTheDate(currentDate: currentDate)
  }

  func checkTheDate(currentDate: Date) {
    DispatchQueue.main.async {
      self.isDateInToday = Calendar.current.isDateInToday(currentDate)
    }
  }
    
  func getSlothRate() -> SlothCharacteristics {
    let stepThresholds = [1500.0, 3000.0, 4500.0, 6000.0, 7500.0, 9000.0, 11500.0, 13500.0, 15500.0, 17500.0, 19500.0]
    let descriptions = SlothCharacteristics.SlothRateDescription.allCases

    let rateIndex = stepThresholds.firstIndex(where: { countResult < $0 }) ?? stepThresholds.count
    let rate = rateIndex + 1
    let description = descriptions[rateIndex].rawValue

    return SlothCharacteristics(slothRateValue: rate, slothDescription: description)
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
