//
//  MarketProductViewModel.swift
//  SimpleMarket
//
//  Created by Kariny on 22/05/21.
//

import Foundation
import UIKit

final class MarketProductViewModel {
    private let imageLoader: ImageLoaderProtocol
    private let imageURL: URL?
    let productName: String
    let price: String

    init(with product: Product, imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
        productName = product.description
        price = product.price.toCurrencyFormat()
        imageURL = product.imageURL
    }

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
