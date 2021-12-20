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
            Text("What sloth\n are you today?")
                .fontWeight(.light)
                .font(.custom("Futura", size: 50))
                .foregroundColor(Color("TitleTextColor"))
                .multilineTextAlignment(.center)
                .frame(width: 400, height: 150)
            
            CircleView()
                .padding(10)
        }
    }
}

struct TextAndPictureView_Previews: PreviewProvider {
    static var previews: some View {
        TextAndPictureView()
    }
}
