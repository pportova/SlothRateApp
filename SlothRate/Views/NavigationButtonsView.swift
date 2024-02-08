//
//  NavigationButtonsView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 23.12.2021.
//

import SwiftUI

struct NavigationButtonsView: View {
  @ObservedObject var stepsViewModel: StepsCounterViewModel
    
  @Binding var currentDate: Date
  @Binding var isPickerVisible: Bool
  @Binding var isBadgeVisible: Bool

  var isButtonDisabled: Bool

  var body: some View {
    HStack {

      Button(action: {
        currentDate = currentDate.dayBefore
        stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
      }){
      BackwardArrowView(elementName: "chevron.left")
        .padding(20.0)
        .multilineTextAlignment(.leading)
        .foregroundColor(Color("UpperLabelsColor"))
      }
                
      Spacer()
            
      if !isPickerVisible {
        Button(action: {
          withAnimation {
            isPickerVisible.toggle()
          }
        }) {
          NavigationLink(destination: DatePickerView(stepsViewModel: stepsViewModel, currentDate: $currentDate, isBadgeVisible: $isBadgeVisible, isPickerVisible: $isPickerVisible), label: {
            Text("\(currentDate, style: .date)")
              .padding(20.0)
              .multilineTextAlignment(.center)
              .foregroundColor(Color("UpperLabelsColor"))
              .font(.custom("Futura", size: 20))
              .frame(width: 250, height: 40)
          })
        }
      } else {
        Button(action: {
          withAnimation {
            isPickerVisible.toggle()
            isBadgeVisible = false
            stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
          }
        }) {
          NavigationLink(destination: ContentView(currentDate: currentDate), label: {
            Text(LocalizedStringKey("date_picker/back"))
              .padding(20.0)
              .multilineTextAlignment(.center)
              .foregroundColor(Color("UpperLabelsColor"))
              .font(.custom("Futura", size: 20))
              .frame(width: 250, height: 40)
          })
        }
      }
      
      Spacer()
      
      if !isButtonDisabled {
        Button(action: {
          currentDate = currentDate.dayAfter
          stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
        }) {
          ForwardArrowView(elementName: "chevron.right")
            .padding(20.0)
            .foregroundColor(Color("UpperLabelsColor"))
        }
      } else {
        Button(action: {}) {
          ForwardArrowView(elementName: "chevron.right")
            .padding(20.0)
            .foregroundColor(Color.gray)
        }
          .disabled(isButtonDisabled)
      }
    }
    .padding()
    .frame(width: nil)
  }
}

struct NavigationButtons_Previews: PreviewProvider {
  static var previews: some View {
    let isButtonDisabled = true
    let stepsViewModel = StepsCounterViewModel()
    let testTime = Date(timeIntervalSinceReferenceDate: -152344567894.0)
      
    NavigationButtonsView(stepsViewModel: stepsViewModel, currentDate: .constant(testTime), isPickerVisible: .constant(false), isBadgeVisible: .constant(true), isButtonDisabled: isButtonDisabled)
    }
}
