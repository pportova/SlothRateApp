//
//  NavigationButtons.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 23.12.2021.
//

import SwiftUI

struct NavigationButtons: View {
    
    @Binding var currentDate: Date
    @Binding var isPickerVisible: Bool
    @Binding var isBadgeVisible: Bool
    @ObservedObject var stepsViewModel: StepsCounterViewModel
    var isButtonDisabled: Bool
    private let today = Date()
    
    
    var body: some View {
        HStack{
            
            Button(action: {
                currentDate = currentDate.dayBefore
                stepsViewModel.checkTheDate(currentDate: currentDate)
            }){
                Text("Day Before")
                    .padding(20.0)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("UpperLabelsColor"))
                    .font(.custom("Futura", size: 20))
            }
                
            Spacer()
            
            if !isPickerVisible{
                Button(action: {
                    withAnimation {
                        isPickerVisible.toggle()
                    }
                }) {
                    Text("Go to Calendar")
                        .padding(20.0)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("UpperLabelsColor"))
                        .font(.custom("Futura", size: 20))
                }
            } else {
                Button(action: {
                    withAnimation {
                        isPickerVisible.toggle()
                        isBadgeVisible = false
                        stepsViewModel.checkTheDate(currentDate: currentDate)
                    }
                }) {
                    Spacer()
                    Text("Back\n to Rate")
                        .padding(20.0)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("UpperLabelsColor"))
                        .font(.custom("Futura", size: 20))
                    Spacer()
                    }
            }
                
            Spacer()

            if !isButtonDisabled {
            Button(action: {
                currentDate = currentDate.dayAfter
                stepsViewModel.checkTheDate(currentDate: currentDate)
            }) {
                Text("Next Day")
                    .padding(20.0)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(Color("UpperLabelsColor"))
                }
            } else {
                Button(action: {
                }) {
                    Text("Next Day")
                        .padding(20.0)
                        .multilineTextAlignment(.trailing)
                        .font(.custom("Futura", size: 20))
                        .foregroundColor(Color.gray)
                    }
                .disabled(isButtonDisabled)
            }
            
            
        }
        .padding()
        .frame(width: 400)
    }
}

struct NavigationButtons_Previews: PreviewProvider {

    static var previews: some View {
        let isButtonDisabled = true
        let stepsViewModel = StepsCounterViewModel()
      
        NavigationButtons(currentDate: .constant(Date()), isPickerVisible: .constant(true), isBadgeVisible: .constant(true), stepsViewModel: stepsViewModel, isButtonDisabled: isButtonDisabled)
    }
}
