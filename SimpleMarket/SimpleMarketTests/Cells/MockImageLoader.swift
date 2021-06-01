//
//  MockImageLoader.swift
//  SimpleMarketTests
//
//  Created by Anne Kariny Silva Freitas on 31/05/21.
//

import Foundation
@testable import SimpleMarket
import UIKit

final class MockImageLoader: ImageLoaderProtocol {
    var isImageLoaded = false

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        isImageLoaded = true
        completion(nil)
    }
}
