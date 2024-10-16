//
//  _palas12_iOSApp.swift
//  5palas12-iOS
//
//  Created by santiago on 03/09/2024.
//

import SwiftUI

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
                TabBarView(selectedTab: $selectedTab)
            }
            
        }
    }
}
