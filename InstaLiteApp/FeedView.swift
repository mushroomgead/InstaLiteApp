import SwiftUI

struct FeedView: View {
    @StateObject private var vm = FeedViewModel()
    
    var body: some View {
        NavigationStack {
                List(vm.items, id: \.self) { url in
                NavigationLink(value: url) {
                    FeedRowView(url: url).listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
            .navigationTitle("InstaLite (SwiftUI)")
            .navigationDestination(for: URL.self) { url in
                DetailView(url: url).navigationBarTitleDisplayMode(.inline)
            }
            .task { await vm.load() }
            .refreshable {
                await vm.reload()
            }
        }
    }
}
