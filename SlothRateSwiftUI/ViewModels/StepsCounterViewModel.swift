//
//  StepsCounterViewModel.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 08.12.2021.
//

import Foundation
import SwiftUI

class StepsCounterViewModel: ObservableObject {
    
    private var stepsCounter = StepsCounter()
    private var today = Date()
    
    @Published var countResult = Double()
    @Published var result = Bool()

    
//    MARK: Functions
    func countStepsAndCheckDate(currentDate: Date) {
        stepsCounter.getTodaysSteps(pickedDate: currentDate, completion: { result in
                        DispatchQueue.main.async {
                            self.countResult = result
                        }
        })
        self.checkTheDate(currentDate: currentDate)
    }

    func checkTheDate(currentDate: Date) {
        result = Calendar.current.isDateInToday(currentDate)
    }
    
    func getSlothRate() -> (Int, String) {
        var slothRate = Int()
        var activityDescription = ""
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
