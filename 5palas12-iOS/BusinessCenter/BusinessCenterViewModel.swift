//
//  BusinessCenterViewModel.swift
//  5palas12-iOS
//
//  Created by santiago on 4/11/24.
//

import Foundation
import Combine

class BusinessCenterViewModel: ObservableObject {
    @Published var businessExists: Bool = false
    private var userDAO = UserDAO()
    
    func loadUserBusinessStatus(for userEmail: String) {
        userDAO.getUserByEmail(userEmail: userEmail) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.businessExists = user?.restaurant != nil // Check if restaurant is not nil
                    print(user?.restaurant ?? "No restaurant found")
                case .failure(let error):
                    print("Error fetching user: \(error.localizedDescription)")
                    self?.businessExists = false
                }
            }
        }
    }
}
