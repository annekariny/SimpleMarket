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
    let description: String
    let stock: Int?
    let offer: Double?
    let imageURLString: String
    var image: UIImage?
    var imageURL: URL? {
        URL(string: imageURLString)
    }

    init(from decodableProduct: DecodableProduct) {
        id = decodableProduct.id
        price = decodableProduct.price
        imageURLString = decodableProduct.image
        description = decodableProduct.description
        stock = decodableProduct.stock
        offer = decodableProduct.offer
    }

    init(from realmProduct: RealmProduct) {
        id = realmProduct.id
        price = realmProduct.price
        imageURLString = realmProduct.imageURLString
        description = realmProduct.productDescription
        stock = realmProduct.stock
        offer = realmProduct.offer
    }
}
