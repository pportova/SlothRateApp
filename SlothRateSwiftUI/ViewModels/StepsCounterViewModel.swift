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
    var slothStructure = SlothCharacteristics()
    if countResult < 1500 {
      slothStructure.slothRateValue = 1
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.first.rawValue
    } else if countResult >= 1500 && countResult < 3000 {
      slothStructure.slothRateValue = 2
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.second.rawValue
    } else if countResult >= 3000 && countResult < 4500 {
      slothStructure.slothRateValue = 3
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.third.rawValue
    } else if countResult >= 4500 && countResult < 6000 {
      slothStructure.slothRateValue = 4
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.fourth.rawValue
    } else if countResult >= 6000 && countResult < 7500 {
      slothStructure.slothRateValue = 5
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.fifth.rawValue
    } else if countResult >= 7500 && countResult < 9000 {
      slothStructure.slothRateValue = 6
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.sixth.rawValue
    } else if countResult >= 9000 && countResult < 11500 {
      slothStructure.slothRateValue = 7
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.seventh.rawValue
    } else if countResult >= 11500 && countResult < 13500 {
      slothStructure.slothRateValue = 8
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.eighth.rawValue
    } else if countResult >= 13500 && countResult < 15500 {
      slothStructure.slothRateValue = 9
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.ninth.rawValue
    } else if countResult >= 15500 && countResult < 17500 {
      slothStructure.slothRateValue = 10
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.tenth.rawValue
    } else if countResult >= 17500 && countResult < 19500 {
      slothStructure.slothRateValue = 11
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.eleventh.rawValue
    } else if countResult >= 19500 {
      slothStructure.slothRateValue = 12
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.twelfth.rawValue
    }
    return slothStructure
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
