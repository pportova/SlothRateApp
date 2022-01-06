//
//  ContentView.swift
//  WatchSlothRate WatchKit Extension
//
//  Created by Polina Portova on 06.01.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var stepsViewModel = StepsCounterViewModel()
    @State private var currentDate = Date()
    var isButtonDisabled = true

    init() {

        self.stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
    }
    
    var body: some View {
        
        let stepsValue = Int(stepsViewModel.countResult.rounded())
        
        ScrollView {
            
            VStack {
                ZStack(alignment: .bottom) {
                    CircleView(stepsViewModel: stepsViewModel)
                        .scaledToFit()
                        .padding(5)
                        .offset(y: -16)
                           
                    HStack{
                        Button(action: {
                            currentDate = currentDate.dayBefore
                            stepsViewModel.checkTheDate(currentDate: currentDate)
                        }){
                            BackwardArrowView(elementName: "chevron.left")
                                .foregroundColor(.white)
                        }
        
                        Spacer(minLength: 120)


                        if !stepsViewModel.isDateInToday {
                            Button(action: {
                                currentDate = currentDate.dayAfter
                                stepsViewModel.checkTheDate(currentDate: currentDate)
                            }) {
                                ForwardArrowView(elementName: "chevron.right")
//                                    .padding(20.0)
                                    .foregroundColor(.white)
                                }

                        } else {
                            Button(action: {
                            }) {
                                ForwardArrowView(elementName: "chevron.right")
//                                    .padding(20.0)
                                    .foregroundColor(Color.gray)
                                }

                            .disabled(isButtonDisabled)
                        }
                    }
//                    .offset(y: 30)
                }
                
                Spacer()
                
                Text("\(currentDate, style: .date)")
                    .font(.custom("American Typewriter", size: 15))
                    .multilineTextAlignment(.center)
                    .padding(10)
                
                Text("\(stepsValue)")
                    .font(.custom("American Typewriter", size: 50))
                    .fontWeight(.semibold)
                    .padding(10)
                
                Text("steps taken")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(Color("FrameColor"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
            .previewDevice("Apple Watch Series 7 - 41mm")
      
    }
}
