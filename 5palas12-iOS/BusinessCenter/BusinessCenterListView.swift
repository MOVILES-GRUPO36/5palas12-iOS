import SwiftUI
import FirebaseAuth

struct BusinessCenterListView: View {
    @ObservedObject var viewModel: BusinessCenterViewModel
    @State var restaurant: RestaurantModel?
    @State private var selectedSetting: SettingItem? = nil
    @State private var settings: [SettingItem] = [
        SettingItem(title: "Create a business", icon: "building", type: .navigation),
        SettingItem(title: "View and edit my business", icon: "pencil.circle.fill", type: .navigation),
        SettingItem(title: "My orders", icon: "cart.fill", type: .navigation),
        SettingItem(title: "My products", icon: "carrot.fill", type: .navigation),
        SettingItem(title: "Help & Support", icon: "questionmark", type: .navigation),
        SettingItem(title: "Delete my business", icon: "trash.fill", type: .navigation)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Welcome to Business Center")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                
                Spacer()
                
                List {
                    ForEach(viewModel.businessExists ? 1..<settings.count : 0..<1, id: \.self) { index in
                        let item = settings[index]
                        
                        Button(action: {
                            selectedSetting = item
                        }) {
                            settingRow(item: item)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.timberwolf)
            .onAppear {
                if let userEmail = Auth.auth().currentUser?.email {
                    print(userEmail)
                    viewModel.loadUserBusinessStatus(for: userEmail) // Load business status on appear
                }
            }
            .sheet(item: $selectedSetting) { item in
                destinationView(for: item)
            }
        }
    }
    
    private func settingRow(item: SettingItem) -> some View {
        HStack {
            if let iconName = item.icon {
                Image(systemName: iconName)
                    .foregroundColor(item.title == "Delete my business" ? .red : .fernGreen)
            }
            
            Text(item.title)
                .foregroundColor(item.title == "Delete my business" ? .red : .primary)
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
        )
    }
    
    private func destinationView(for item: SettingItem) -> some View {
        switch item.title {
        case "Create a business":
            return AnyView(CreateBusinessView(viewModel: viewModel))
        case "View and edit my business":
            return AnyView(Text("View and edit my business view"))
        case "My orders":
            return AnyView(Text("My orders view"))
        case "My products":
            return AnyView(BusinessProductListView(productVM: ProductViewModel(restaurant: restaurant!)))
        case "Help & Support":
            return AnyView(Text("Help & Support view"))
        case "Delete my business":
            return AnyView(DeleteBusinessView(viewModel: viewModel))
        default:
            return AnyView(EmptyView())
        }
    }
}
