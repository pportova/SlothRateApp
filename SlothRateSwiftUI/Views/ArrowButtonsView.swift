//
//  ArrowButtonsView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 29.12.2021.
//

import SwiftUI

struct BackwardArrowView: View {
    var elementName: String
    
    var body: some View {
        Image(systemName: elementName)
            .font(.largeTitle)
    }
}

struct ForwardArrowView: View {
    var elementName: String
    
    var body: some View {
        Image(systemName: elementName)
            .font(.largeTitle)
    }
}

struct ArrowButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20){
            BackwardArrowView(elementName: "chevron.left")
            ForwardArrowView(elementName: "chevron.right")
        }
    }
}
