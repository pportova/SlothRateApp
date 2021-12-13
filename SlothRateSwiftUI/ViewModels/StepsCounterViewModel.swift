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

    
    func countSteps() {
        stepsCounter.getTodaysSteps(pickedDate: chosenDate, completion: { result in
                        DispatchQueue.main.async {
                            self.countResult = result
                        }
                    })
                }

    
}
