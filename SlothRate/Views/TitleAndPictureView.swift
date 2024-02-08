//
//  TitleAndPictureView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 20.12.2021.
//

import SwiftUI

struct TitleAndPictureView: View {
  @ObservedObject var stepsViewModel: StepsCounterViewModel
    
  var body: some View {
    VStack {
      Text(LocalizedStringKey("main_screen/title"))
        .fontWeight(.light)
        .font(.custom("Futura", size: 50))
        .foregroundColor(Color("TitleTextColor"))
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.6)
        .frame(minHeight: 110, idealHeight: 150, maxHeight: 150, alignment: .center)
      
      CircleView(stepsViewModel: stepsViewModel)
        .padding(20)
    }
    .frame(width: nil)
  }
}

struct TextAndPictureView_Previews: PreviewProvider {
  static var previews: some View {
    let stepsViewModel = StepsCounterViewModel()
        
    TitleAndPictureView(stepsViewModel: stepsViewModel)
  }
}
