//
//  AppDelegate.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 07/10/24.
//
import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
