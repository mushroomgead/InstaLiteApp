import SwiftUI

struct FeedRowView: View {
    @StateObject private var vm: FeedRowVM
    private let height: CGFloat = 180
    
    init(url: URL) {
        _vm = StateObject(wrappedValue: FeedRowVM(url: url))
    }
    
    var body: some View {
        ZStack {
            if let img = vm.image {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .clipped()
            } else {
                Rectangle()
                    .fill(.gray.opacity(0.15))
                    .frame(height: height)
                    .overlay(ProgressView())
            }
        }
        .onAppear {
            Task {
                await vm.start(height: height)
            }
        }
        .onDisappear {
            Task {
                await vm.cancel()
            }
        }
    }
}

