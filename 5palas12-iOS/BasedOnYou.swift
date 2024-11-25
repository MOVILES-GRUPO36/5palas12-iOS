//
//  BasedOnYou.swift
//  5palas12-iOS
//
//  Created by santiago on 24/11/24.
//

import SwiftUI

struct BasedOnYouView: View {
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @State private var availableCategories = ["Vegetariano", "Vegano", "Mediterránea", "Organica", "Postres", "Mariscos", "Colombiana", "A la carte", "gluten-free", "Buffet", "Típica", "China", "Parrilla"]
    @State private var selectedCategories: [String] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isEditingPreferences = false

    let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]

    var body: some View {
        VStack(spacing: 20) {
            if isEditingPreferences || (userVM.userData?.preferences?.isEmpty ?? true) {
                Text(isEditingPreferences ? "Edit Your Preferences" : "Let’s Personalize Your Experience")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Text("Choose up to 3 categories you like:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(availableCategories, id: \.self) { category in
                            Button(action: {
                                toggleCategorySelection(category)
                            }) {
                                Text(category)
                                    .font(.body)
                                    .foregroundColor(selectedCategories.contains(category) ? .white : .primary)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background(selectedCategories.contains(category) ? Color.fernGreen : Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .disabled(selectedCategories.count >= 3 && !selectedCategories.contains(category))
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: savePreferences) {
                    Text("Save Preferences")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.fernGreen)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(selectedCategories.isEmpty || selectedCategories.count > 3)
            } else {
                // Restaurants view
                Text("Showing restaurants based on your preferred categories.")
                    .font(.title3)
                    .padding()

                Button(action: {
                    enterEditMode()
                }) {
                    Text("Edit My Preferences")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.fernGreen)
                        .cornerRadius(8)
                }
                .padding()

                // Show the filtered restaurants based on the user's selected preferences
                let filteredRestaurants = restaurantsVM.filterRestaurants(by: userVM.userData?.preferences ?? [])
                let sortedFilteredRestaurants = sortRestaurants(filteredRestaurants)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(sortedFilteredRestaurants, id: \.id) { restaurant in
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                RestaurantCardView(restaurant: restaurant)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Preferences Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            preloadUserPreferences()
        }
    }
    

    private func toggleCategorySelection(_ category: String) {
        if let index = selectedCategories.firstIndex(of: category) {
            selectedCategories.remove(at: index)
        } else {
            if selectedCategories.count < 3 {
                selectedCategories.append(category)
            } else {
                alertMessage = "You can only select a maximum of 3 categories."
                showAlert = true
            }
        }
    }

    private func savePreferences() {
        guard !selectedCategories.isEmpty else {
            showAlert = true
            alertMessage = "Please select at least one category."
            return
        }

        let preferences = selectedCategories
        let updatedData: [String: Any] = ["preferences": preferences]

        if let email = userVM.userData?.email {
            userVM.updateUser(email: email, with: updatedData) { result in
                switch result {
                case .success:
                    print("Preferences saved successfully!")
                    isEditingPreferences = false
                case .failure(let error):
                    print("Failed to save preferences: \(error.localizedDescription)")
                }
            }
        } else {
            alertMessage = "User email is not available."
            showAlert = true
        }
    }

    private func enterEditMode() {
        selectedCategories = userVM.userData?.preferences ?? []
        isEditingPreferences = true
    }

    private func preloadUserPreferences() {
        selectedCategories = userVM.userData?.preferences ?? []
    }

    private func sortRestaurants(_ restaurants: [RestaurantModel]) -> [RestaurantModel] {
        return restaurants.sorted { (restaurant1, restaurant2) -> Bool in
            guard let distance1 = restaurant1.distance, let distance2 = restaurant2.distance else {
                return false
            }
            return distance1 < distance2
        }
    }
}
