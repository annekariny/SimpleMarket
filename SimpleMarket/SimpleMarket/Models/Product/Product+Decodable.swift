//
//  Product+Decodable.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct ProductResult: Decodable {
    let products: [DecodableProduct]
}

struct DecodableProduct: Decodable {
    let id: String
    let price: Double
    let image: String
    let description: String
    let stock: Double
    let offer: Double
}
