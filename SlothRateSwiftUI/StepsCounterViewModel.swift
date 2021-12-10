//
//  StepsCounterViewModel.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 08.12.2021.
//

import Foundation

class StepsCounterViewModel: ObservableObject {
    
    var stepsCounter = StepsCounter()
    var countResult = Double()
    
    func countSteps(){
        stepsCounter.getTodaysSteps(completion: { result in
                DispatchQueue.main.async {
                    self.countResult = result
                }
        })
    }
    
}
