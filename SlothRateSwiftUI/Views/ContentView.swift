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
    
//    @State private var offset = CGSize.zero
//    @GestureState var dragState = DragState.inactive
    @State private var viewState = CGSize.zero
    
//    @StateObject var stepsViewModel = StepsCounterViewModel()
    @ObservedObject var stepsViewModel = StepsCounterViewModel()

    
    @State private var isPickerVisible = false

    @State var currentDate: Date
    
    @State private var isBadgeVisible = false
    
    private let today = Date()
    private let animationAmount = 1

    private struct OffsetPreferenceKey: PreferenceKey {
      static var defaultValue: CGFloat = .zero
      static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
    }
    
//    enum DragState {
//
//        case inactive
//        case pressing
//        case dragging(translation: CGSize)
//
//        var translation: CGSize {
//            switch self {
//                case .inactive, .pressing:
//                    return .zero
//                case .dragging(let translation):
//                    return translation
//                }
//        }
//
//        var isActive: Bool {
//            switch self {
//                case .inactive:
//                    return false
//                case .pressing, .dragging:
//                    return true
//            }
//        }
//
//        var isDragging: Bool {
//            switch self {
//                case .inactive, .pressing:
//                    return false
//                case .dragging:
//                    return true
//                }
//        }
//
//
//    }
    
//    init() {

//        self.stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
//    }
       
    var body: some View {

//        let minimumLongPressDuration = 0.05
//        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
//            .sequenced(before: DragGesture())
//            .updating($dragState) { value, state, transaction in
//                switch value {
//                // Long press begins.
//                case .first(true):
//                    state = .pressing
//                // Long press confirmed, dragging may begin.
//                case .second(true, let drag):
//                    state = .dragging(translation: drag?.translation ?? .zero)
//
//                // Dragging ended or the long press cancelled.
//                default:
//                    state = .inactive
//                }
//            }
//            .onEnded { value in
//                guard case .second(true, let drag?) = value else { return }
//                self.viewState.width += drag.translation.width
//                if self.viewState.width > 40 {
//                    currentDate = currentDate.dayBefore
//                    stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
//                } else if self.viewState.width < -40 {
//                    if !stepsViewModel.isDateInToday {
//                    currentDate = currentDate.dayAfter
//                    stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
//                    }
//                }
//
//
//            }
        NavigationView {
            
        ZStack {
            Color(red: 0.92, green: 0.80, blue: 0.64)
                .opacity(0.45)
                .ignoresSafeArea()
//               ScrollView(.horizontal){
            GeometryReader { geometryRegular in

                VStack {
                    NavigationButtonsView(currentDate: $currentDate, isPickerVisible: $isPickerVisible, isBadgeVisible: $isBadgeVisible, stepsViewModel: stepsViewModel, isButtonDisabled: stepsViewModel.isDateInToday)
                        .offset(y: 10)

                    Spacer()
                    
//                    if !isPickerVisible {
//                        VStack {
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
                                    .offset(x: -15 ,y: -55)
                                    .transition(.move(edge: .trailing))
                                    .animation(.easeOut, value: animationAmount)
                            }

                            ValueStepsTakenView(stepsViewModel: stepsViewModel)
                                .offset(y: -40)
//                        }
//                    } else {
//                        VStack {
//                            TextAndPictureView(stepsViewModel: stepsViewModel)
//
//                            Spacer()
//                                .frame(height: 95)
//
//                            ValueStepsTakenView(stepsViewModel: stepsViewModel)
//                                .offset(y: -40)
//
//                        }
//                        .blur(radius: 70)
//                        .overlay(
//                            DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
//                                    .datePickerStyle(GraphicalDatePickerStyle())
//                                    .padding(20)
//                                    .offset(y: -60))
//                        .allowsHitTesting(false)
                        }
                        
//                    }//VStack closes
                    .frame(width: geometryRegular.size.width, height: geometryRegular.size.height, alignment: .center)

                }//GR closes
            
        }
        .onAppear {
//            currentDate = Date()
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
        }.gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
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

//        .gesture(longPressDrag)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) {_ in
            currentDate = Date()
            stepsViewModel.countStepsAndCheckDate(currentDate: currentDate)
        }
        .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        
//        .gesture(
//            DragGesture()
//                .onChanged {(value) in
//                    offset = value.translation
//                    if offset.width > 60 {
//                        currentDate = currentDate.dayBefore
//                    } else if offset.width < -60 {
//                        currentDate = currentDate.dayAfter
//                    }
//            }
//                .onEnded{ (value) in
//                    withAnimation{
//                        offset = .zero
//                    }
//                }
//
//        )
        //Overall ZStack closes
        
        
        
    }
        .edgesIgnoringSafeArea(.all)
        
    } //Body closes
    
}


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
}



struct ContentView_Previews: PreviewProvider {
    let testTime = Date(timeIntervalSinceReferenceDate: -152344567894.0)
    
    static var previews: some View {
//        ContentView()
        ContentView(currentDate: Date())
    }
}
