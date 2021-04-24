//
//  Product+Decodable.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct ProductResult: Decodable {
    let items: [DecodableProduct]
}

struct DecodableProduct: Decodable {
    let id: Int
    let price: Double
    let image: String
    let description: String
    let stock: Double?
    let offer: Double?
}
