//
//  BadgeView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 14.12.2021.
//

import SwiftUI

struct BadgeView: View {
    var body: some View {
        Text("Perfectly active\n all-day-by-the-computer sloth")
            .padding(10)
            .multilineTextAlignment(.trailing)
            .foregroundColor(.black)
            .background(Color("BackgroundBageColor"))
            .border(Color("CircleViewFrame"), width: 3)
            .cornerRadius(10)
            .frame(width: 400, height: 80, alignment: .trailing)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
