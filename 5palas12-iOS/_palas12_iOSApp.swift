import SwiftUI

@main
struct _palas12_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var selectedTab = 0
//    @State var isLoggedIn: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject var restaurantsVM: RestaurantViewModel = RestaurantViewModel()
    @StateObject var userVM: UserViewModel = UserViewModel() // ViewModel to handle user data
    @StateObject private var networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if let userData = userVM.userData {
                    // Show the TabBarView when user data is available
                    TabBarView(selectedTab: $selectedTab)
                        .environmentObject(restaurantsVM)
                        .environmentObject(userData)
                        .environmentObject(networkMonitor)
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
        .environmentObject(userVM)
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
