//
//  MarketProductViewModel.swift
//  SimpleMarket
//
//  Created by Kariny on 22/05/21.
//

import Foundation
import UIKit

struct MarketProductViewModel {
    let productName: String
    let price: String
    var image: UIImage?

    init(with product: Product) {
        productName = product.description
        price = product.price.toCurrencyFormat()
        image = nil
    }
}
