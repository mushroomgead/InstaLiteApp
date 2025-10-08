import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript (url: URL) -> UIImage? {
        get {
            return cache.object(forKey: url as NSURL)
        }
        set {
            if let img = newValue {
                cache.setObject(img, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }    
}
