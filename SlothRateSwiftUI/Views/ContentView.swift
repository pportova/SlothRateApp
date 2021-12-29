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
        self.stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
    }
       
    var body: some View {
        
        let stepsValue = Int(stepsViewModel.countResult.rounded())
         
        ZStack {
            Color(red: 0.92, green: 0.80, blue: 0.64)
                .opacity(0.45)
                .ignoresSafeArea()

            VStack{
                
                NavigationButtonsView(currentDate: $currentDate, isPickerVisible: $isPickerVisible, isBadgeVisible: $isBadgeVisible, stepsViewModel: stepsViewModel, isButtonDisabled: stepsViewModel.result)

                    Spacer()
                
                    if !isPickerVisible{
                        VStack{
                            TextAndPictureView()
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
                                BadgeView()
                                    .offset(y: -45)
                                    .transition(.move(edge: .trailing))
                                    .animation(.easeOut, value: animationAmount)
                            }

                            Text("\(stepsValue)")
                                .font(.custom("American Typewriter", size: 90))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("ValueLabelColor"))
                                .padding(10)
                                .offset(y: -30)
                    
                            Text("steps taken")
                                .font(.custom("Futura", size: 30))
                                .foregroundColor(Color("UpperLabelsColor"))
                                .offset(y: -10)
                
                        }
                        } else {
                            VStack{
                                TextAndPictureView()

                                Spacer()
                                    .frame(height: 95)

                                Text("\(stepsValue)")
                                    .font(.custom("American Typewriter", size: 90))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("ValueLabelColor"))
                                    .padding(10)
                                    .offset(y: -30)
                                
                                Text("steps taken")
                                    .font(.custom("Futura", size: 30))
                                    .foregroundColor(Color("UpperLabelsColor"))
                                    .offset(y: -10)
                            
                            }
                            .blur(radius: 70)
                            .overlay(
                                DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding(20)
                                        .offset(y: -60)
                            )
                    }
                }
            //VStack closes
        }
        //Overall ZStack closes
    }
    //Body closes
    
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

}


struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
        ContentView()
    }
}
