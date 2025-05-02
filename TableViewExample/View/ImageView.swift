//
//  ImageView.swift
//  CoinRanking
//
//  Created by Lucy Chetalam on 26/04/2025.
//
import SwiftUI


struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    func imageFromData(_ data:Data) -> UIImage {
        UIImage(data: data) ?? UIImage()
    }

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {

            if let imageData = imageLoader.data, let uiImage = UIImage(data: imageData) {
                  Image(uiImage: uiImage)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 50, height: 50)
              } else {
                  // Display a default image or a placeholder if data is nil or invalid
                  Image(systemName: "photo.fill") // A system image as a placeholder
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 50, height: 50)
                      .foregroundColor(.gray) // Optional: Change the color of the placeholder
              }
        }
    }

}

class ImageLoader: ObservableObject {
    @Published var dataIsValid = false
    var data:Data?

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.dataIsValid = true
                self.data = data
            }
        }
        task.resume()
    }
}
