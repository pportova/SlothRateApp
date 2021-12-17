//
//  StepsCounterViewModel.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 08.12.2021.
//

import Foundation

class StepsCounterViewModel: ObservableObject {
    
    var stepsCounter = StepsCounter()
    
    @Published var countResult = Double()
    @Published var chosenDate = Date()

    func countSteps(chosenDate: Date) {
        stepsCounter.getTodaysSteps(pickedDate: chosenDate, completion: { result in
                        DispatchQueue.main.async {
                            self.countResult = result
                        }
        })

    }

    
    func getSlothRate() -> (Int, String) {
        var slothRate = Int()
        var activityDescription = ""
        if countResult < 1000 {
            //Sleeping sloth
            slothRate = 1
            activityDescription = "Sleeping sloth.\n I'm checking how this looks"
        } else if countResult > 1000 && countResult < 5000 {
            slothRate = 2
            //Hanging on a branch
            activityDescription = "Hanging on a branch"
        } else if countResult > 5000 && countResult < 8000 {
            slothRate = 3
            //Showing "V"
            activityDescription = "Showing V"
        } else if countResult > 8000 && countResult < 14000 {
            slothRate = 4
            //Sitting by a computer
            activityDescription = "Perfectly active\n all-day-by-the-computer sloth"
        } else if countResult > 14000 {
            slothRate = 5
            //Climbing a branch
            activityDescription = "Climbing a branch"
        }
        return (slothRate, activityDescription)
}
    
}
