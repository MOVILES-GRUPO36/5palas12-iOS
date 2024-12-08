import SwiftUI

@main
struct _palas12_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var selectedTab = 0
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject var restaurantsVM: RestaurantViewModel = RestaurantViewModel()
    @StateObject var userVM: UserViewModel = UserViewModel()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @StateObject var ordersVM = OrdersViewModel()
    @StateObject private var timeManager = TimeManager()
    @State private var showAlert = false
    @StateObject private var cartVM : CartViewModel = CartViewModel()

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                if isLoggedIn {
                    if networkMonitor.isConnected {
                        if userVM.userData != nil {
                            // Ensure that the restaurantsVM is passed down to environment objects
                            TabBarView(selectedTab: $selectedTab)
                                .environmentObject(restaurantsVM)
                                .environmentObject(userVM)
                                .environmentObject(networkMonitor)
                                .environmentObject(ordersVM)
                                .environmentObject(timeManager)
                                .environmentObject(cartVM)
                        } else {
                            ProgressView("Loading user data...")
                                .onAppear {
                                    userVM.loadUserFromDefaults()
                                }
                        }
                    } else {
                        OfflineModeView()
                            .environmentObject(ordersVM)
                            .environmentObject(restaurantsVM)
                    }
                } else {
                    if networkMonitor.isConnected {
                        // Inject restaurantsVM to the LoginScreen as well
                        LoginScreen(isLoggedIn: $isLoggedIn)
                            .onAppear {
                                restaurantsVM.locationManager.requestLocation()
                                checkLoginStatus()
                                ordersVM.loadInitialOrders()
                            }
                            .environmentObject(restaurantsVM) // Pass restaurantsVM to LoginScreen here
                    } else {
                        Text("You don't seem to be connected to the internet. Check your connection and try again.")
                            .font(.headline)
                            .padding()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Lost Connection"),
                    message: Text("Some features of this app may not work. Please check your internet connection."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: networkMonitor.isConnected) { isConnected in
                if !isConnected {
                    showAlert = true
                } else {
                    showAlert = false
                }
            }
            .onAppear {
                setupInitialDataFetch()
            }
        }
        .environmentObject(userVM)
        .onChange(of: isLoggedIn) { _ in
            // Reinitialize environment objects after successful login
            if isLoggedIn {
                reinitializeEnvironmentObjects()
            }
        }
    }

    /// Reinitialize environment objects after successful login or re-login.
    func reinitializeEnvironmentObjects() {
        // Ensure that any necessary data is reloaded or reinitialized here
        restaurantsVM.loadRestaurants() // Example: reload restaurants
        userVM.loadUserFromDefaults()  // Load the user data again
        ordersVM.loadInitialOrders()   // Example: load orders again
        
        // You could call any other necessary re-initialization functions here
    }

    /// Triggers login check and initial data fetches.
    func setupInitialDataFetch() {
        checkLoginStatus()
        
        if isLoggedIn, let email = UserDefaults.standard.string(forKey: "currentUserEmail") {
            DispatchQueue.global(qos: .background).async {
                ordersVM.fetchOrders(byUserEmail: email)
            }
        }
    }

    func checkLoginStatus() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            isLoggedIn = true
            userVM.loadUserFromDefaults()
        }
    }
}
