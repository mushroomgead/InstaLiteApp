import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var items: [URL] = []

    func load() async {
        items = (0..<200).compactMap { URL(string: "https://picsum.photos/id/\($0)/600/400") }
    }

    func reload() async { await load() }

    deinit { print("FeedViewModel deinit") }
}
