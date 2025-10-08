import UIKit
import Combine

@MainActor
final class FeedRowVM: ObservableObject {
    @Published var image: UIImage?
    private var task: Task<UIImage?, Never>?
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func start(height: CGFloat) async {
        let size = CGSize(width: UIScreen.main.bounds.width, height: height)
        let task = await ImageLoader.shared.load(url, targetSize: size)
        self.task = task
        self.image = await task.value
    }

    func cancel() async {
        await ImageLoader.shared.cancel(url)
        task?.cancel()
        task = nil
    }

    deinit {
        task?.cancel()
        task = nil
    }
    
}
