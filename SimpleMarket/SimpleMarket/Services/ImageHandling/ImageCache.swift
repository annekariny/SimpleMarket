//
//  ImageCache.swift
//  SimpleMarket
//
//  Created by Kariny on 22/05/21.
//

import UIKit

protocol ImageCacheProtocol {
    func set(image: UIImage, for identifier: String)
    func get(for identifier: String) -> UIImage?
}

struct ImageCache: ImageCacheProtocol {
    private let cache = NSCache<NSString, AnyObject>()

    func set(image: UIImage, for identifier: String) {
        cache.setObject(image, forKey: identifier as NSString)
    }

    func get(for identifier: String) -> UIImage? {
        cache.object(forKey: identifier as NSString) as? UIImage
    }
}
