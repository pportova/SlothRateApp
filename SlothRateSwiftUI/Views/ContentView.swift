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
  
  @State private var viewState = CGSize.zero
  @State private var isPickerVisible = false
  @State var currentDate: Date
  @State private var isBadgeVisible = false
    
  private let today = Date()
  private let animationAmount = 1
       
  var body: some View {
    NavigationView {
      
      ZStack {
        Color(red: 0.92, green: 0.80, blue: 0.64)
          .opacity(0.45)
          .ignoresSafeArea()
          GeometryReader { geometryRegular in
            
            VStack {
              NavigationButtonsView(stepsViewModel: stepsViewModel, currentDate: $currentDate, isPickerVisible: $isPickerVisible, isBadgeVisible: $isBadgeVisible, isButtonDisabled: stepsViewModel.isDateInToday)
                .offset(y: 10)

              Spacer()
              
              TitleAndPictureView(stepsViewModel: stepsViewModel)
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
                  .offset(x: -15 ,y: -55)
                  .transition(.move(edge: .trailing))
                  .animation(.easeOut, value: animationAmount)
              }

              StepsCountAndLabelView(stepsViewModel: stepsViewModel)
                .offset(y: -40)
            }
            .frame(width: geometryRegular.size.width, height: geometryRegular.size.height, alignment: .center)
          }
      }
      .onAppear {
        StepsCounter.authorizeHealthKit(viewModel: stepsViewModel, date: currentDate) { (authorized, error) in
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
        stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
        }
      .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
        .onEnded({value in
          if value.translation.width < -40 {
            if !stepsViewModel.isDateInToday {
              currentDate = currentDate.dayAfter
              stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
            }
          } else if value.translation.width > 40 {
            currentDate = currentDate.dayBefore
            stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
          }
        })
      )
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) {_ in
        currentDate = Date()
        stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
      }
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
    }
    .edgesIgnoringSafeArea(.all)
  }
}

extension AnyTransition {
  static var moveAndFade: AnyTransition {
    AnyTransition.move(edge: .trailing)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
  
    ContentView(currentDate: Date())
  }
}
