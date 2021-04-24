//
//  Product.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import UIKit

struct Product {
    let id: Int
    let price: Double
    let imageURL: URL?
    let description: String
    let stock: Double?
    let offer: Double?
    var image: UIImage?
    
    init(from decodableProduct: DecodableProduct) {
        self.id = decodableProduct.id
        self.price = decodableProduct.price
        self.imageURL = URL(string: decodableProduct.image)
        self.description = decodableProduct.description
        self.stock = decodableProduct.stock
        self.offer = decodableProduct.offer
    }
}
