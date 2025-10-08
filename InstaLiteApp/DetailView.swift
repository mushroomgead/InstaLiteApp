import SwiftUI

struct DetailView: View {
    let url: URL
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            if let img = image {
                ScrollView([.vertical, .horizontal]) {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color(.systemBackground))
            } else {
                ProgressView()
            }
        }
        .task {
            let screen = UIScreen.main.bounds.size
            image = await ImageLoader.shared.load(url, targetSize: screen).value
        }
        .onDisappear {
            Task {
                await ImageLoader.shared.cancel(url)
            }
        }
    }
}
