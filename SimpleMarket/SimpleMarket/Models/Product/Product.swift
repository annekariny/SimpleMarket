//
//  Product.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct Product {
    let id: String
    let price: Double
    let imageURL: String
    let description: String
    let stock: Double
    let offer: Double
    
    init(from decodableProduct: DecodableProduct) {
        self.id = decodableProduct.id
        self.price = decodableProduct.price
        self.imageURL = decodableProduct.image
        self.description = decodableProduct.description
        self.stock = decodableProduct.stock
        self.offer = decodableProduct.offer
    }
}
