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
            .multilineTextAlignment(.trailing)
            .foregroundColor(Color("ButtonColor"))
//            .font(.custom("American Typewriter", size: 18))
            .font(.custom("Bradley Hand", size: 20))

            .background(Color("BackgroundBageColor"))  
            .border(Color("FrameColor"), width: 3)

            .cornerRadius(10)
            .frame(width: 400, height: 80, alignment: .trailing)
            
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
