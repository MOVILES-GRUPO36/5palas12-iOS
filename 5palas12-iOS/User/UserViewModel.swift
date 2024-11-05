import SwiftUI
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var userData: UserModel? = nil    
    

    func loadUserFromDefaults() {
        if let email = UserDefaults.standard.string(forKey: "currentUserEmail") {
            UserDAO().getUserByEmail(email: email) { [weak self] result in
                switch result {
                case .success(let userData):
                    DispatchQueue.main.async {
                        self?.userData = userData
                    }
                case .failure(let error):
                    print("Error loading user data: \(error.localizedDescription)")
                }
            }
        } else {
            print("No email found in UserDefaults")
        }
    }
}
