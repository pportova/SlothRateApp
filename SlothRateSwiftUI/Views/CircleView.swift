//
//  CircleView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

struct CircleView: View {
    
//    var slothRateData = StepsCounterViewModel()
    @ObservedObject var stepsViewModel: StepsCounterViewModel
//    var imageNumber: Int
    
//    init() {
//        imageNumber = slothRateData.getSlothRate().0
//    }

    var body: some View {
//        Image("\(imageNumber)" as String)
        Image(String(stepsViewModel.slothRate) as String)
        
            .resizable()
            .scaledToFit()
        
            .frame(minWidth: 180, idealWidth: 250, maxWidth: 250, minHeight: 180, idealHeight: 250, maxHeight: 250)
//            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay{
                Circle().stroke(
                    Color("CircleViewFrame"))
            }
            .shadow(radius: 5)
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        let stepsViewModel = StepsCounterViewModel()
        
        VStack{
//            CircleView()
//            CircleView(stepsViewModel: stepsViewModel)
            BadgeView(stepsViewModel: stepsViewModel)
//            BadgeView()
                .offset(y: -45)
        }
    }
}
