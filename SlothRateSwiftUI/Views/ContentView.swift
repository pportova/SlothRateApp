//
//  ContentView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI
import Foundation
import UIKit

struct ContentView: View {
    
    @ObservedObject var stepsViewModel = StepsCounterViewModel()
    
    @State private var isPickerVisible = false
    @State private var currentDate = Date()
    @State private var isBadgeVisible = false
    
    
    private let today = Date()
    private let animationAmount = 1
    
    init() {
        StepsCounter.authorizeHealthKit{ (authorized, error) in
            guard authorized else {
              let resultMessage = "HealthKit Authorization Failed"
              if let error = error {
                print("\(resultMessage). Reason: \(error.localizedDescription)")
              } else {
                print(resultMessage)
              }
              return
            }
            print("HealthKit Successfully Authorized.")
          }
        
        self.stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
    }
       
    var body: some View {

        ZStack {
            Color(red: 0.92, green: 0.80, blue: 0.64)
                .opacity(0.45)
                .ignoresSafeArea()
            
            GeometryReader { geometryRegular in
                    
                VStack {
                    NavigationButtonsView(currentDate: $currentDate, isPickerVisible: $isPickerVisible, isBadgeVisible: $isBadgeVisible, stepsViewModel: stepsViewModel, isButtonDisabled: stepsViewModel.isDateInToday)
                        .offset(y: 10)

                    Spacer()
                    
                    if !isPickerVisible {
                        VStack {
                            TextAndPictureView(stepsViewModel: stepsViewModel)
                                .onAppear() {
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                                        withAnimation {
                                            isBadgeVisible = true
                                        }
                                    }
                                }
        
                            if !isBadgeVisible {
                                Spacer()
                                    .frame(height: 95)
                            } else {
                                BadgeView(stepsViewModel: stepsViewModel)
                                    .offset(y: -55)
                                    .transition(.move(edge: .trailing))
                                    .animation(.easeOut, value: animationAmount)
                            }

                            ValueStepsTakenView(stepsViewModel: stepsViewModel)
                                .offset(y: -40)
                        }
                    } else {
                        VStack {
                            TextAndPictureView(stepsViewModel: stepsViewModel)

                            Spacer()
                                .frame(height: 95)
                            
                            ValueStepsTakenView(stepsViewModel: stepsViewModel)
                                .offset(y: -40)

                        }
                        .blur(radius: 70)
                        .overlay(
                            DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(20)
                                    .offset(y: -60))
                        }
                    }//VStack closes
                    .frame(width: geometryRegular.size.width, height: geometryRegular.size.height, alignment: .center)
          
                }//GR closes
        }
        //Overall ZStack closes
    } //Body closes
    
}
    

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
}

struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
        ContentView()
    }
}
