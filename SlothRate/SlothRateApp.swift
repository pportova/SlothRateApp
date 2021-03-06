//
//  SlothRateApp.swift
//  SlothRate
//
//  Created by Polina Portova on 01.12.2021.
//

import SwiftUI

@main
struct SlothRateApp: App {
  @State private var stepsViewModel = StepsCounterViewModel()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView(currentDate: Date())
        .environmentObject(stepsViewModel)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  static var orientationLock = UIInterfaceOrientationMask.portrait
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
    
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window:UIWindow?) -> UIInterfaceOrientationMask {
    return AppDelegate.orientationLock
  }
}

