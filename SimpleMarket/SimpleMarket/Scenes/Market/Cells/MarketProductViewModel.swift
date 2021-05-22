//
//  MarketProductViewModel.swift
//  SimpleMarket
//
//  Created by Kariny on 22/05/21.
//

import Foundation
import UIKit

final class MarketProductViewModel {
    let productName: String
    let price: String
    var image: UIImage?

    init(with product: Product, imageLoader: ImageLoaderProtocol) {
        productName = product.description
        price = product.price.toCurrencyFormat()

        if let url = product.imageURL {
            imageLoader.loadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
