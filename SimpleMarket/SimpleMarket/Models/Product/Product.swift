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

    init(
        id: Int,
        price: Double,
        description: String,
        stock: Int? = nil,
        offer: Double? = nil,
        imageURLString: String
    ) {
        self.id = id
        self.price = price
        self.description = description
        self.stock = stock
        self.offer = offer
        self.imageURLString = imageURLString
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

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.price == rhs.price &&
            lhs.description == rhs.description &&
            lhs.stock == rhs.stock &&
            lhs.offer == rhs.offer &&
            lhs.imageURLString == rhs.imageURLString
    }
}
