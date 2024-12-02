//
//  AppDelegate.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 07/10/24.
//
import FirebaseCore
import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        //FirebaseConfiguration.shared.setLoggerLevel(.debug)
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
