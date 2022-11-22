//
//  ImageLoader.swift
//  SimpleMarket
//
//  Created by Kariny on 22/05/21.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

struct ImageLoader: ImageLoaderProtocol {
    private let imageCache: ImageCacheProtocol
    private let urlHelper: URLHelperProtocol

    init(imageCache: ImageCacheProtocol = ImageCache(), urlHelper: URLHelperProtocol = URLHelper()) {
        self.imageCache = imageCache
        self.urlHelper = urlHelper
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.get(for: url.absoluteString) {
            completion(cachedImage)
            return
        } else {
            urlHelper.downloadImage(withURL: url) { downloadedImage in
                guard let image = downloadedImage else {
                    return
                }
                imageCache.set(image: image, for: url.absoluteString)
                completion(downloadedImage)
            }
        }
    }
}
