//
//  CircleView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

struct CircleView: View {
  @ObservedObject var stepsViewModel: StepsCounterViewModel
  
  var body: some View {
    Image(String(stepsViewModel.slothRate) as String)
      .resizable()
      .scaledToFit()
      .frame(minWidth: 180, idealWidth: 250, maxWidth: 250, minHeight: 180, idealHeight: 250, maxHeight: 250)
      .clipShape(Circle())
      .overlay {
        Circle().stroke(
        Color("CircleViewFrame"))
      }
      .shadow(radius: 5)
  }
}

struct CircleView_Previews: PreviewProvider {
  static var previews: some View {
    let stepsViewModel = StepsCounterViewModel()
        
    VStack {
      BadgeView(stepsViewModel: stepsViewModel)
        .offset(y: -45)
    }
  }
}
