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

    
    @State private var singleDate = Date()
    @State private var anyDays = [Date]()
    @State private var dateRange: ClosedRange<Date>? = nil
    
    private let today = Date()
    private let animationAmount = 1.0
       
    var body: some View {
        
        let value = Int(stepsViewModel.countResult.rounded())
        
        ZStack {
            Color(red: 0.98, green: 0.81, blue: 0.7)
                .opacity(0.45)
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Button(action: {
                        singleDate = singleDate.dayBefore
                        stepsViewModel.chosenDate = singleDate
                    }) {
                        Text("Yesterday")
                            .padding(20.0)
                            .foregroundColor(Color(red: 0.06, green: 0.14, blue: 0.26))
                            .font(.custom("Futura", size: 20))
                    }
                    Spacer()
                    Button(action: {
                        singleDate = singleDate.dayAfter
                        stepsViewModel.chosenDate = singleDate
                    }) {
                        Text("Next Day")
                            .padding(20.0)
                            .foregroundColor(Color(red: 0.06, green: 0.14, blue: 0.26))
                            .font(.custom("Futura", size: 20))
                    }
                }
                .padding()

                if isPickerVisible {
                    Text("What sloth\n are you today?")
                        .fontWeight(.light)
                        .font(.custom("Futura", size: 50))
                        .foregroundColor(Color(red: 0.04, green: 0.39, blue: 0.71))
                        .multilineTextAlignment(.center)
                        .opacity(0.25)
                    
                        CircleView()
                            .padding(50)
                            .opacity(0.25)
                        
                } else {
                    Text("What sloth\n are you today?")
                        .fontWeight(.light)
                        .font(.custom("Futura", size: 50))
                        .foregroundColor(Color(red: 0.04, green: 0.39, blue: 0.71))
                        .multilineTextAlignment(.center)
                    
                    CircleView()
                        .padding(10)
                }
                Spacer()
                Text("Steps taken on \(singleDate, style: .date)")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(Color(red: 0.43, green: 0.37, blue: 0.30))

                Text("\(value)")
                    .font(.custom("Futura", size: 50))
                    .fontWeight(.thin)
                    .foregroundColor(Color(red: 0.19, green: 0.17, blue: 0.12))
                    .padding(20)
 
            
                Button(action: {
//                    isPickerVisible.toggle()
                    withAnimation{
                        isPickerVisible.toggle()
                    }
                }) {
                    if isPickerVisible {
                    Text("Done")
                        .fontWeight(.light)
                        .font(.custom("Futura", size: 20))
                        .padding(20.0)
    //                    .frame(maxHeight: 40, alignment: .bottom)
                        .background(
                            ZStack {
                                Color(red: 0.06, green: 0.14, blue: 0.26)
                                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
                            }
                        )
                        .foregroundColor(.white)
                        .cornerRadius(21.0)
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
                    }
                }
                .padding()
                          
            }
            if isPickerVisible{
                TabView{
                    
                    VStack{
                        Text("Single date").font(.title).padding()
                        MultiDatePicker(singleDay: $singleDate)
                            Button(action: {
                                isPickerVisible.toggle()
                            }){
                                Text("Done")
                            }.padding()
                    }
                    .tabItem{
                        Text("Pick a single date")
                            .padding()
                    }
                    
                    VStack{
                        Text("Several dates").font(.title).padding()
                        MultiDatePicker(anyDays: $anyDays)
                        Button(action: {
                            isPickerVisible.toggle()
                        }) {
                            Text("Details")
                        }
                        
                        
                    }
                    .tabItem{
                        Text("Pick several dates")
                            .padding()
                    }
                    
                    VStack{
                        Text("Date Range").font(.title).padding()
                        MultiDatePicker(dateRange: $dateRange)
                        if let range = dateRange {
                            Text("\(range)").padding()
                        } else {
                            Text("Select two dates")
                                .padding()
                        }
                        Button(action: {
                            isPickerVisible.toggle()
//                            ComparisonView()
                        }){
                            Text("Details")
                        }
                        .padding()
                    }
                    .tabItem{
                        Text("Range of dates")
                    }
                    
                }
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
    }
}


//red: 51/255, green: 96/255, blue: 255/255
