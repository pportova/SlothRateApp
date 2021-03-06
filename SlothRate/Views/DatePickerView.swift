//
//  DatePickerView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 27.01.2022.
//

import SwiftUI

struct DatePickerView: View {
  @ObservedObject var stepsViewModel: StepsCounterViewModel
    
  @Binding var currentDate: Date
  @Binding var isBadgeVisible: Bool
  @Binding var isPickerVisible: Bool
  
  @State var navigationActive = false
    
  private let today = Date()
    
  var body: some View {
    ZStack {
      Color(red: 0.92, green: 0.80, blue: 0.64)
        .opacity(0.45)
        .ignoresSafeArea()
      
      VStack {
        NavigationButtonsView(stepsViewModel: stepsViewModel, currentDate: $currentDate, isPickerVisible: $isPickerVisible, isBadgeVisible: $isBadgeVisible, isButtonDisabled: stepsViewModel.isDateInToday)
          .offset(y: 10)
        
        Spacer()
     
        DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
          .datePickerStyle(GraphicalDatePickerStyle())
          .padding(20)
          .frame(width: 333)
          .offset(y: -60)
          .onChange(of: currentDate, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              navigationActive = true
            }
          })
        
          NavigationLink("", destination: ContentView(currentDate: currentDate).navigationBarTitle("")
            .navigationBarHidden(true), isActive: $navigationActive)
                
          Spacer()
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
  }
}

struct DatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    let testTime = Date.distantPast
    let stepsViewModel = StepsCounterViewModel()
    
    DatePickerView(stepsViewModel: stepsViewModel, currentDate: .constant(testTime), isBadgeVisible: .constant(true), isPickerVisible: .constant(false))
  }
}
