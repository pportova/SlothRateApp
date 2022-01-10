//
//  ValueStepsTakenView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 10.01.2022.
//

import SwiftUI

struct ValueStepsTakenView: View {
    @ObservedObject var stepsViewModel: StepsCounterViewModel
    
    var body: some View {
        
        let stepsValue = Int(stepsViewModel.countResult.rounded())
        
        VStack{
            Text(String(stepsValue))
                .font(.custom("American Typewriter", size: 90))
                .fontWeight(.semibold)
                .foregroundColor(Color("ValueLabelColor"))
                .padding(10)
                .minimumScaleFactor(0.8)
//                .offset(y: -30)

            Text("steps taken")
                .font(.custom("Futura", size: 30))
                .foregroundColor(Color("StepsTakenColor"))
                .minimumScaleFactor(0.01)
//                .padding(.bottom, 30)
//                .offset(y: -30)
        }
    }
}

struct ValueStepsTakenView_Previews: PreviewProvider {
    static var previews: some View {
        let stepsViewModel = StepsCounterViewModel()
        
        ValueStepsTakenView(stepsViewModel: stepsViewModel)
    }
}
