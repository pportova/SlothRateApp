//
//  CircleView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

struct CircleView: View {
    
    var slothRateData = StepsCounterViewModel()
    var imageNumber: Int
    
    init() {
        imageNumber = slothRateData.getSlothRate().0
    }

    var body: some View {
        Image("\(imageNumber)" as String)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
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
        VStack{
            CircleView()
            BadgeView()
                .offset(y: -45)
        }
    }
}
