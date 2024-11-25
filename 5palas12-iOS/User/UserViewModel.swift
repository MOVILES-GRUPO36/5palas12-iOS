import SwiftUI
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var userData: UserModel? = nil
    private let userDAO = UserDAO()
    

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
    
    func addPreferences(_ preferences: [String], completion: @escaping (Bool) -> Void) {
        guard let userId = userData?.id else {
            completion(false)
            return
        }
        
        UserDAO().updateUser(userId: userId, with: ["preferences": FieldValue.arrayUnion(preferences)]) { result in
            switch result {
            case .success():
                self.userData?.preferences?.append(contentsOf: preferences)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func updateUser(email: String, with updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        userDAO.updateUserByEmail(email: email, with: updatedData) { result in
            switch result {
            case .success:
                self.userData?.preferences = updatedData["preferences"] as? [String]
                self.objectWillChange.send()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
