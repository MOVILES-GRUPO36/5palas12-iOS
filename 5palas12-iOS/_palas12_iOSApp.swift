//
//  _palas12_iOSApp.swift
//  5palas12-iOS
//
//  Created by santiago on 03/09/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct _palas12_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var selectedTab = 0
    @State var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabBarView(selectedTab: $selectedTab)
            } else {
                LoginScreen(isLoggedIn: $isLoggedIn)
            }
            
        }
    }
}
