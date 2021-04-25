//
//  RealmProduct.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import RealmSwift

final class RealmProduct: Object {
    @objc dynamic var id = 0
    @objc dynamic var productDescription = ""
    @objc dynamic var price = 0.0
    @objc dynamic var stock = 0
    @objc dynamic var offer = 0.0
    @objc dynamic var imageURLString = ""

    override static func primaryKey() -> String? {
        "id"
    }

    override init() {
        super.init()
    }

    init(from product: Product?) {
        id = product?.id ?? 0
        productDescription = product?.description ?? ""
        price = product?.price ?? 0
        stock = product?.stock ?? 0
        offer = product?.offer ?? 0
        imageURLString = product?.imageURLString ?? ""
        super.init()
    }
}
