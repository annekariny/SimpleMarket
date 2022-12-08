//
//  ImageLoadable.swift
//  SimpleMarket
//
//  Created by Anne Kariny Silva Freitas on 31/05/21.
//

import Foundation
import UIKit

protocol ImageLoadable {
    var imageLoader: ImageLoaderProtocol { get set }
    var imageURL: URL? { get set }
    func loadImage(completion: @escaping ((UIImage?) -> Void))
}

extension ImageLoadable {
    func loadImage(completion: @escaping ((UIImage?) -> Void)) {
        guard let url = imageURL else {
            completion(nil)
            return
        }
        imageLoader.loadImage(from: url) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
