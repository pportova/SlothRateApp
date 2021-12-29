//
//  TextAndPictureView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 20.12.2021.
//

import SwiftUI

struct TextAndPictureView: View {
    var body: some View {
        VStack{
            Text("What sloth\nare you today?")
                .fontWeight(.light)
                .font(.custom("Futura", size: 50))
                .foregroundColor(Color("TitleTextColor"))
                .multilineTextAlignment(.center)
//                .fixedSize()
                .frame(width: 400, height: 150)
            
            CircleView()
//                .frame(width: 250, height: 250)
                .padding(20)
        }
    }
}

struct TextAndPictureView_Previews: PreviewProvider {
    static var previews: some View {
        TextAndPictureView()
    }
}
