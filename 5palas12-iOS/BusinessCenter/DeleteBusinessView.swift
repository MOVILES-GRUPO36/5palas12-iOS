import SwiftUI
import FirebaseAuth

struct DeleteBusinessView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BusinessCenterViewModel
    
    @State private var restaurant: RestaurantModel?
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var userRestaurant = ""
    
    private let restaurantDAO = RestaurantSA()
    private let userDAO = UserDAO()
    @EnvironmentObject var userVM: UserViewModel // Ensure UserViewModel is passed as an environment object
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.businessExists, let restaurant = restaurant {
                    Text("Are you sure you wish to delete your restaurant \"\(restaurant.name)\"?")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("No restaurant found.")
                        .foregroundColor(.red)
                }
                
                HStack {
                    Button(action: deleteBusiness) {
                        Text("Yes, I wish to delete it")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .disabled(!viewModel.businessExists)
                    
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("No, cancel")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitle("Delete Business", displayMode: .inline)
            .onAppear {
                if let email = userVM.userData?.email {
                    print("User email: \(email)")
                } else {
                    print("User email is nil or empty")
                }
                if let userEmail = userVM.userData?.email, !userEmail.isEmpty {
                    userRestaurant = userVM.userData?.restaurant ?? "no restaurant"
                    fetchRestaurantDetails()
                } else {
                    print("User email not found or empty")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Restaurant"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage == "Restaurant deleted successfully!" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func fetchRestaurantDetails() {
        guard let userRestaurant = userVM.userData?.restaurant else {
            print("No restaurant associated with the user")
            return
        }

        restaurantDAO.getRestaurantByName(userRestaurant) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let restaurant):
                    self.restaurant = restaurant
                case .failure(let error):
                    print("Failed to fetch restaurant: \(error.localizedDescription)")
                    self.restaurant = nil
                }
            }
        }
    }
    
    private func deleteBusiness() {
        guard let restaurantName = restaurant?.name,
              let userEmail = userVM.userData?.email else {
            alertMessage = "No restaurant or user email found."
            showAlert = true
            print("Restaurant: \(restaurant?.name ?? "nil"), UserEmail: \(userVM.userData?.email ?? "nil")")
            return
        }

        // Offload the task to a worker thread
        DispatchQueue.global(qos: .userInitiated).async {
            restaurantDAO.deleteRestaurantByName(restaurantName) { result in
                switch result {
                case .success:
                    userDAO.removeRestaurantFromUser(email: userEmail) { updateResult in
                        DispatchQueue.main.async {
                            switch updateResult {
                            case .success:
                                alertMessage = "Restaurant deleted successfully!"
                                viewModel.businessExists = false
                                restaurant = nil
                                userVM.userData?.restaurant = nil
                            case .failure(let error):
                                alertMessage = "Failed to update user: \(error.localizedDescription)"
                            }
                            showAlert = true
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        alertMessage = "Failed to delete restaurant: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        }
    }
}
