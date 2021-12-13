//
//  CircleView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

struct CircleView: View {
    var body: some View {
        Image("4")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay{
                Circle().stroke(
                    Color(red: 0.27, green: 0.24, blue: 0.20) , lineWidth: 3).opacity(0.5)
//                Circle().stroke(
//                    .gray , lineWidth: 3).opacity(0.5)
            }
            .shadow(radius: 5)
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
