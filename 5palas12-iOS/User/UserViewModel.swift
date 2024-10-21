import SwiftUI
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var userData: UserModel? = nil

    func loadUserFromDefaults() {
        // Retrieve the stored email from UserDefaults
        if let email = UserDefaults.standard.string(forKey: "currentUserEmail") {
            // Fetch the user data from Firestore using the retrieved email
            UserDAO().getUserByEmail(email: email) { [weak self] result in
                switch result {
                case .success(let userData):
                    // Update the userData and trigger a re-render
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
