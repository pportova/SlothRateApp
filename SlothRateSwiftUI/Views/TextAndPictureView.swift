//
//  TextAndPictureView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 20.12.2021.
//

import SwiftUI

struct TextAndPictureView: View {
    
    @ObservedObject var stepsViewModel: StepsCounterViewModel
    
    var body: some View {
        VStack{
            Text("What sloth\nare you today?")
                .fontWeight(.light)
                .font(.custom("Futura", size: 50))
                .foregroundColor(Color("TitleTextColor"))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
//                .fixedSize()
                .frame(minHeight: 110, idealHeight: 150, maxHeight: 150, alignment: .center)
//                .frame(height: 150)
//
            CircleView(stepsViewModel: stepsViewModel)
                
//            CircleView()
//                .frame(width: 250, height: 250)
                .padding(20)
        }
        .frame(width: nil)
    }
}

struct TextAndPictureView_Previews: PreviewProvider {
    
    static var previews: some View {
        let stepsViewModel = StepsCounterViewModel()
        
        TextAndPictureView(stepsViewModel: stepsViewModel)
//        TextAndPictureView()
    }
}
