import SwiftUI

struct ProductCartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    var product: ProductModel

    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100)
                        .clipped()
                } else {
                    AsyncImage(url: URL(string: product.photo)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "fork.knife")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .foregroundColor(.fernGreen)
                        case .success(let downloadedImage):
                            downloadedImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .clipped()
                                .onAppear {

                                    if image == nil {
                                        downloadImageAndCache()
                                    }
                                }
                        case .failure:

                            Image(systemName: "fork.knife")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .foregroundColor(.fernGreen)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.headline)

                    Text(product.category)
                        .opacity(0.5)

                    Text("Weight: \(product.weight, specifier: "%.2f") kg")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("CO2 Emissions: \(product.co2Emissions, specifier: "%.2f") kg")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding([.leading, .bottom, .trailing])

                HStack {
                    Spacer()
                    Button {
                        cartVM.removeProduct(product)
                    } label: {
                        Text("Delete")
                            .bold()
                            .padding(.all, 8)
                            .foregroundColor(.white)
                            .background(Color("FernGreen"))
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
        .onAppear {
            if let cachedImage = cartVM.getCachedImage(for: product.photo) {
                self.image = cachedImage
            } else {
                downloadImageAndCache()
            }
        }
    }

    private func downloadImageAndCache() {
        guard let url = URL(string: product.photo) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    cartVM.cacheImage(downloadedImage, for: product.photo)
                }
            } else {
                print("Error al descargar la imagen: \(error?.localizedDescription ?? "Desconocido")")
            }
        }.resume()
    }
}
