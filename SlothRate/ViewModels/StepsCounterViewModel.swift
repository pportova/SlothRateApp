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
    
    enum SlothRateDescription: CaseIterable {
      case first
      case second
      case third
      case fourth
      case fifth
      case sixth
      case seventh
      case eighth
      case ninth
      case tenth
      case eleventh
      case twelfth
        
        var description: String {
            switch self {
                case .first: return String(localized: "description/1")
                case .second: return String(localized: "description/2")
                case .third: return String(localized: "description/3")
                case .fourth: return String(localized: "description/4")
                case .fifth: return String(localized: "description/5")
                case .sixth: return String(localized: "description/6")
                case .seventh: return String(localized: "description/7")
                case .eighth: return String(localized: "description/8")
                case .ninth: return String(localized: "description/9")
                case .tenth: return String(localized: "description/10")
                case .eleventh: return String(localized: "description/11")
                case .twelfth: return String(localized: "description/12")
            }
        }
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
        slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.first.description
    } else if countResult >= 1500 && countResult < 3000 {
      slothStructure.slothRateValue = 2
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.second.description
    } else if countResult >= 3000 && countResult < 4500 {
      slothStructure.slothRateValue = 3
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.third.description
    } else if countResult >= 4500 && countResult < 6000 {
      slothStructure.slothRateValue = 4
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.fourth.description
    } else if countResult >= 6000 && countResult < 7500 {
      slothStructure.slothRateValue = 5
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.fifth.description
    } else if countResult >= 7500 && countResult < 9000 {
      slothStructure.slothRateValue = 6
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.sixth.description
    } else if countResult >= 9000 && countResult < 11500 {
      slothStructure.slothRateValue = 7
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.seventh.description
    } else if countResult >= 11500 && countResult < 13500 {
      slothStructure.slothRateValue = 8
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.eighth.description
    } else if countResult >= 13500 && countResult < 15500 {
      slothStructure.slothRateValue = 9
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.ninth.description
    } else if countResult >= 15500 && countResult < 17500 {
      slothStructure.slothRateValue = 10
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.tenth.description
    } else if countResult >= 17500 && countResult < 19500 {
      slothStructure.slothRateValue = 11
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.eleventh.description
    } else if countResult >= 19500 {
      slothStructure.slothRateValue = 12
      slothStructure.slothDescription = SlothCharacteristics.SlothRateDescription.twelfth.description
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
