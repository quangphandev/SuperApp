//
//  UIImageView+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import UIKit

// MARK: - Remote Image Loading

extension UIImageView {

    /// Loads an image from a URL string, caching the result in memory.
    /// Falls back to `placeholder` while loading or on error.
    ///
    /// Usage:
    /// ```swift
    /// avatarImageView.setImage(url: user.avatarURL, placeholder: UIImage(systemName: "person.circle"))
    /// ```
    func setImage(
        url urlString: String?,
        placeholder: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) {
        self.contentMode = contentMode
        self.image       = placeholder

        guard
            let urlString,
            let url = URL(string: urlString)
        else { return }

        // Check in-memory cache first
        if let cached = ImageCache.shared.image(for: url) {
            self.image = cached
            return
        }

        // Tag the view with this URL to discard stale responses on cell reuse
        let tag = url.hashValue
        self.tag = tag

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard
                let self,
                error == nil,
                let data,
                let image = UIImage(data: data),
                self.tag == tag          // still the same URL?
            else { return }

            ImageCache.shared.store(image, for: url)

            DispatchQueue.main.async {
                UIView.transition(
                    with: self,
                    duration: 0.2,
                    options: [.transitionCrossDissolve, .allowUserInteraction],
                    animations: { self.image = image }
                )
            }
        }.resume()
    }

    /// Loads an image from a `URL` directly.
    func setImage(
        url: URL?,
        placeholder: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) {
        setImage(url: url?.absoluteString, placeholder: placeholder, contentMode: contentMode)
    }
}

// MARK: - Circular Clip

extension UIImageView {

    /// Clips the image view to a perfect circle.
    /// Call after layout is finalized (e.g. `viewDidLayoutSubviews`).
    func makeCircular() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        clipsToBounds      = true
    }
}

// MARK: - ImageCache (in-memory, thread-safe)

private final class ImageCache {

    static let shared = ImageCache()

    private let cache: NSCache<NSURL, UIImage> = {
        let c = NSCache<NSURL, UIImage>()
        c.countLimit      = 100   // max 100 images
        c.totalCostLimit  = 50 * 1024 * 1024  // 50 MB
        return c
    }()

    private init() {}

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func store(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * image.scale * 4)
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }

    func clear() {
        cache.removeAllObjects()
    }
}
