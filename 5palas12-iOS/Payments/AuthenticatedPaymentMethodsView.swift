//
//  AuthenticatedPaymentMethodsView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI
import LocalAuthentication

struct AuthenticatedPaymentMethodsView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                PaymentMethodsView()
            } else {
                Text("Authenticating...")
                    .onAppear(perform: authenticate)
            }
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to access your payment methods."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        // Handle authentication failure
                        print("Authentication failed")
                    }
                }
            }
        } else {
            // No biometrics available
            print("No biometrics available")
        }
    }
}
