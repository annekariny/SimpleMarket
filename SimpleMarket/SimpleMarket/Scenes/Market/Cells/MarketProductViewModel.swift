//
//  MarketProductViewModel.swift
//  SimpleMarket
//
//  Created by Kariny on 22/05/21.
//

import Foundation
import UIKit

final class MarketProductViewModel: ImageLoadable {
    internal var imageLoader: ImageLoaderProtocol
    internal var imageURL: URL?
    let productName: String
    let price: String

    init(with product: Product, imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
        imageURL = product.imageURL
        productName = product.description
        price = product.price.toCurrencyFormat()
    }
}
