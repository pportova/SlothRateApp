//
//  BadgeView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 14.12.2021.
//

import SwiftUI

struct BadgeView: View {
    
    let stepsViewModel = StepsCounterViewModel()
    var pictureDescription = ""
    
    init() {
        pictureDescription = stepsViewModel.getSlothRate().1
    }
    
    var body: some View {
    
        Text("\(pictureDescription)")
            .padding(15)
            .background(Color("BackgroundBageColor"))
            .foregroundColor(Color("ButtonColor"))
            .cornerRadius(21.0)
            .multilineTextAlignment(.trailing)
            .font(.custom("Avenir", size: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 21.0)
                    
                    .strokeBorder(Color("FrameColor") , lineWidth: 2.0)
            )
            .frame(width: 400, height: 80, alignment: .trailing)        
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
