//
//  CircleView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

struct CircleView: View {
    
    var slothRateData = StepsCounterViewModel()

    var body: some View {
        Image("\(slothRateData.slothRate)" as String)
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
        CircleView()

    }
}
