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
    var slothRate = 4
    
    func getSlothRate() -> Int {
        if countResult < 1000 {
            slothRate = 1
        } else if countResult > 1000 && countResult < 5000 {
            slothRate = 2
        } else if countResult > 5000 && countResult < 8000 {
            slothRate = 3
        } else if countResult > 8000 && countResult < 14000 {
            slothRate = 4
        } else if countResult > 14000 {
            slothRate = 5
        }
        return slothRate
}
    
    func countSteps() {
        stepsCounter.getTodaysSteps(pickedDate: chosenDate, completion: { result in
                        DispatchQueue.main.async {
                            self.countResult = result
                        }
                    })
                }

    
}
