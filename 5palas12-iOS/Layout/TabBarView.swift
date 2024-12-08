import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var cartVM: CartViewModel
    @State private var showAlert = false
    
    let tabBarHeight: CGFloat = 100
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        NavigationView {
            ZStack {
                // Contenido principal según la pestaña seleccionada
                VStack(spacing: 0) {
                    switch selectedTab {
                    case 0:
                        RestaurantsListView()
                            .padding(.all, 0)
                    case 1:
                        SearchView()
                    case 2:
                        MapView()
                            .padding(.all, 0)
                    case 3:
                        ProfileView()
                            .padding(.all, 0)
                    default:
                        RestaurantsListView()
                            .padding(.all, 0)
                    }
                    
                    // Barra de navegación inferior
                    HStack {
                        TabBarButton(icon: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                        TabBarButton(icon: "magnifyingglass", title: "Search", isSelected: selectedTab == 1) {
                            selectedTab = 1
                        }
                        TabBarButton(icon: "map.fill", title: "Maps", isSelected: selectedTab == 2) {
                            selectedTab = 2
                        }
                        TabBarButton(icon: "person.fill", title: "Profile", isSelected: selectedTab == 3) {
                            selectedTab = 3
                        }
                    }
                    .frame(height: tabBarHeight)
                    .background(Color(hex: "#584C3F"))
                    .cornerRadius(cornerRadius)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -2)
                }
                .edgesIgnoringSafeArea(.vertical)
                .onAppear {
                    restaurantsVM.loadRestaurants()
                }
                
                // Botón flotante del carrito en la esquina superior derecha
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: CartView()) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                
                                Image(systemName: "cart.fill")
                                    .foregroundColor(Color(hex: "#584C3F"))
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 5)
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Lost Connection"),
                    message: Text("Some features of this app may not work. Please check your internet connection."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: networkMonitor.isConnected) { isConnected in
                showAlert = !isConnected
            }
        }
    }
}
