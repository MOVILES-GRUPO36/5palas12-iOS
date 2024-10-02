import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int
    
    let tabBarHeight: CGFloat = 100
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        VStack {
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
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarButton: View {
    var icon: String
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
        }
    }
}

