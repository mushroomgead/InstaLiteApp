import UIKit
import ImageIO

actor ImageLoader {
    static let shared = ImageLoader()

    private var inFlight: [URL: Task<UIImage?, Never>] = [:]

    func load(_ url: URL,
              targetSize: CGSize? = nil,
              scale: CGFloat = UIScreen.main.scale) -> Task<UIImage?, Never> {
        if let cached = ImageCache.shared[url] {
            return Task { cached }
        }
        if let existing = inFlight[url] {
            return existing
        }

        let task = Task(priority: .utility) { [url] () async -> UIImage? in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let image: UIImage?
                if let targetSize {
                    image = Self.downsample(data: data, to: targetSize, scale: scale)
                } else {
                    image = UIImage(data: data)
                }
                if let img = image {
                    ImageCache.shared[url] = img
                }
                self.finish(url)
                return image
            } catch {
                self.finish(url)
                return nil
            }
        }

        inFlight[url] = task
        return task
    }

    func cancel(_ url: URL) {
        inFlight[url]?.cancel()
        inFlight[url] = nil
    }

    private func finish(_ url: URL) {
        inFlight[url] = nil
    }

    private static func downsample(data: Data, to size: CGSize, scale: CGFloat) -> UIImage? {
        let maxDim = max(size.width, size.height) * scale
        let opts: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDim
        ]
        guard
            let src = CGImageSourceCreateWithData(data as CFData, nil),
            let cg = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary)
        else { return nil }
        return UIImage(cgImage: cg)
    }
}
