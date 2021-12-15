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
    
    private let today = Date()
    private let animationAmount = 1.0
       
    var body: some View {
        
        let value = Int(stepsViewModel.countResult.rounded())
        
        ZStack {
            Color(red: 0.92, green: 0.80, blue: 0.64)
                .opacity(0.45)
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Button(action: {
                        currentDate = currentDate.dayBefore
                        stepsViewModel.chosenDate = currentDate
                    }) {
                        Text("Day Before")
                            .padding(20.0)
                            .foregroundColor(Color("UpperLabelsColor"))
                            .font(.custom("Futura", size: 20))
//                            .offset(y: -20)
                    }
                    Spacer()
                    Button(action: {
                        currentDate = currentDate.dayAfter
                        stepsViewModel.chosenDate = currentDate
                    }) {
                        Text("Next Day")
                            .padding(20.0)
                            .font(.custom("Futura", size: 20))
                            .foregroundColor(Color("UpperLabelsColor"))
//                            .offset(y: -20)
                        
                    }
                }
                .padding()

                if isPickerVisible {
                    Text("What sloth\n are you today?")
                        .fontWeight(.light)
                        .font(.custom("Futura", size: 50))
                        .foregroundColor(Color(red: 0.04, green: 0.40, blue: 0.53))
                        .multilineTextAlignment(.center)
                        .opacity(0.25)

                        CircleView()
                            .padding(50)
                            .opacity(0.25)

                } else {
                    Text("What sloth\n are you today?")
                        .fontWeight(.light)
                        .font(.custom("Futura", size: 50))
                        .foregroundColor(Color("TitleTextColor"))
                        .multilineTextAlignment(.center)
//                        .offset(y: -30)
                        .frame(width: 400, height: 150)

                    CircleView()
                        .padding(10)
//                        .offset(y: -30)

                    BadgeView()
                        .offset(y: -60)


                }
                Text("Steps taken on \(currentDate, style: .date)")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(Color("StepsTakenColor"))
                    .offset(y: -10)
//

                Text("\(value)")
                    .font(.custom("American Typewriter", size: 70))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("ValueLabelColor"))
                    .padding(10)

                Button(action: {
                    withAnimation {
                        isPickerVisible.toggle()
                            
                    }
                }) {
                    if isPickerVisible {
                        Text("Done")
                            .fontWeight(.light)
                            .font(.custom("Futura", size: 20))
                            .padding(20.0)
                            .background(
                                ZStack {
                                    Color(red: 0.06, green: 0.14, blue: 0.26)
                                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
                                }
                            )
                            .foregroundColor(.white)
                            .cornerRadius(21.0)
                            .animation(.easeIn(duration: 1), value: 2)
                    } else {
                        Text("Go To Calendar")

                            .fontWeight(.light)
                            .font(.custom("Futura", size: 20))
                            .padding(20.0)
                            .background(
                                ZStack {
                                    Color(red: 0.06, green: 0.14, blue: 0.26)
                                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
                                }
                            )
                            .foregroundColor(.white)
                            .cornerRadius(21.0)
                            .animation(.easeIn(duration: 1), value: 2)

                    }
                }
                .padding()
            }

            if isPickerVisible {
                DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(20)
            }
        }
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
        ContentView().preferredColorScheme(.dark)
    }
}
