//
//  StepsCountAndLabelView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 10.01.2022.
//

import SwiftUI

struct StepsCountAndLabelView: View {
  @ObservedObject var stepsViewModel: StepsCounterViewModel
    
  var body: some View {
    let stepsValue = Int(stepsViewModel.countResult.rounded())
        
    VStack {
      Text(String(stepsValue))
        .font(.custom("American Typewriter", size: 90))
        .fontWeight(.semibold)
        .foregroundColor(Color("ValueLabelColor"))
        .padding(10)
        .minimumScaleFactor(0.8)

      Text(LocalizedStringKey("main_screen/steps_taken"))
        .font(.custom("Futura", size: 30))
        .foregroundColor(Color("StepsTakenColor"))
        .minimumScaleFactor(0.01)
    }
  }
}

struct ValueStepsTakenView_Previews: PreviewProvider {
  static var previews: some View {
    let stepsViewModel = StepsCounterViewModel()
        
    StepsCountAndLabelView(stepsViewModel: stepsViewModel)
  }
}
