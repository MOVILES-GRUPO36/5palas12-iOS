import SwiftUI

@main
struct _palas12_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var selectedTab = 0
    @State var isLoggedIn: Bool = false
    @StateObject var restaurantsVM: RestaurantViewModel = RestaurantViewModel()
    @StateObject var userVM: UserViewModel = UserViewModel() // ViewModel to handle user data

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if let userData = userVM.userData {
                    // Show the TabBarView when user data is available
                    TabBarView(selectedTab: $selectedTab)
                        .environmentObject(restaurantsVM)
                        .environmentObject(userData)
                } else {
                    // Show a loading view or placeholder until `userData` is loaded
                    ProgressView("Loading user data...")
                        .onAppear {
                            userVM.loadUserFromDefaults()
                        }
                }
            } else {
                // Show login screen
                LoginScreen(isLoggedIn: $isLoggedIn)
                    .onAppear {
                        restaurantsVM.locationManager.requestLocation()
                        checkLoginStatus() // Check if a session exists
                    }
            }
        }
    }
    
    func checkLoginStatus() {
        // Retrieve isLoggedIn from UserDefaults
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            isLoggedIn = true
            // Optionally, trigger loading the user data
            userVM.loadUserFromDefaults()
        }
    }
}
