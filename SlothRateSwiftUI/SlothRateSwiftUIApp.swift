//
//  SlothRateSwiftUIApp.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

@main
struct SlothRateSwiftUIApp: App {
    
    @State private var stepsViewModel = StepsCounterViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stepsViewModel)
        }
    }
}
