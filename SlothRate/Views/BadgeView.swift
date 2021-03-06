//
//  BadgeView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 14.12.2021.
//

import SwiftUI

struct BadgeView: View {
  @ObservedObject var stepsViewModel: StepsCounterViewModel
  
  var body: some View {
    Text(String(stepsViewModel.activityDescription))
      .padding(15)
      .background(Color("BackgroundBageColor"))
      .foregroundColor(Color("ButtonColor"))
      .cornerRadius(21.0)
      .multilineTextAlignment(.trailing)
      .font(.custom("Avenir", size: 18))
      .overlay(
        RoundedRectangle(cornerRadius: 21.0)
          .strokeBorder(Color("FrameColor") , lineWidth: 2.0))
          .frame(width: 400, height: 80, alignment: .trailing)
    }
}

struct BadgeView_Previews: PreviewProvider {
  static var previews: some View {
    let stepsViewModel = StepsCounterViewModel()
        
    BadgeView(stepsViewModel: stepsViewModel)
  }
}
