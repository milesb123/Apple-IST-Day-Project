//
//  Personality_Similarity_CalculatorApp.swift
//  Personality Similarity Calculator
//
//  Created by Miles Broomfield on 18/11/2020.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Personality_Similarity_CalculatorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
