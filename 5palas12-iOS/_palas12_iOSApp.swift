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
    @StateObject var ordersVM = OrdersViewModel()
    @StateObject private var timeManager = TimeManager()
    @State private var showAlert = false


    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0){
                if isLoggedIn {
                    if networkMonitor.isConnected {
                        if let userData = userVM.userData {
                            TabBarView(selectedTab: $selectedTab)
                                .environmentObject(restaurantsVM)
                                .environmentObject(userData)
                                .environmentObject(networkMonitor)
                                .environmentObject(ordersVM)
                                .environmentObject(timeManager)
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
                        LoginScreen(isLoggedIn: $isLoggedIn)
                            .onAppear {
                                restaurantsVM.locationManager.requestLocation()
                                checkLoginStatus() // Check if a session exists
                            }
                    } else {
                        Text("You don't seem to be connected to the internet. Check your connection and try again.")
                            .font(.headline)
                            .padding()
                    }
                    
                }
            }.alert(isPresented: $showAlert) {
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
