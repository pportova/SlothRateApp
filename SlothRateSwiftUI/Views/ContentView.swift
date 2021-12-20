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
    
    @State var stepsViewModel = StepsCounterViewModel()
    @State private var isPickerVisible = false
    @State private var currentDate = Date()
    @State private var isBadgeVisible = false
    
    private let today = Date()
    private let animationAmount = 1.0
    
    init() {
        self.stepsViewModel.countSteps(chosenDate: currentDate)
    }
       
    var body: some View {
        
        let stepsValue = Int(stepsViewModel.countResult.rounded())
           
        ZStack {
            Color(red: 0.92, green: 0.80, blue: 0.64)
                .opacity(0.45)
                .ignoresSafeArea()

            VStack{
                // Upper buttons stack
                HStack{
                    Button(action: {
                        currentDate = currentDate.dayBefore
                        stepsViewModel.chosenDate = currentDate
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
                            }
                        }) {
                            Text("Back to Rate")
                                .padding(20.0)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("UpperLabelsColor"))
                                .font(.custom("Futura", size: 20))
                            }
                    }
                        
                    Spacer()

                    Button(action: {
                        currentDate = currentDate.dayAfter
                        stepsViewModel.chosenDate = currentDate
                    }) {
                        Text("Next Day")
                            .padding(20.0)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Futura", size: 20))
                            .foregroundColor(Color("UpperLabelsColor"))
                        }
                    }
                    .padding()
                    .frame(width: 400)

                    Spacer()
                
                // Main content
                    if !isPickerVisible{
                        VStack{
                            TextAndPictureView()
                                .onAppear() {
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                                        withAnimation {
                                            self.isBadgeVisible.toggle()
                                        }
                                    }
                                }
                    
                            if !isBadgeVisible {
                                Spacer()
                                    .frame(height: 95)
                            } else {
                                BadgeView()
                                    .offset(y: -45)
                                    .transition(.moveAndFade)
                            }

                            Text("\(stepsValue)")
                                .font(.custom("American Typewriter", size: 90))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("ValueLabelColor"))
                                .padding(10)
                                .offset(y: -30)
                    
                            Text("steps taken on \(currentDate, style: .date)")
                                .font(.custom("Futura", size: 20))
                                .foregroundColor(Color("StepsTakenColor"))
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
                                
                                Text("steps taken on \(currentDate, style: .date)")
                                    .font(.custom("Futura", size: 20))
                                    .foregroundColor(Color("StepsTakenColor"))
                                    .offset(y: -10)
                            
                            }
                            .blur(radius: 20)
                            .overlay(
                                DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding(20)
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
