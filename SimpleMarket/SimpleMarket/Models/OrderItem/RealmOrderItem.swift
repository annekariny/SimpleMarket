//
//  RealmOrderItem.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import RealmSwift

final class RealmOrderItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var product: RealmProduct?
    @objc dynamic var quantity = 0

    override static func primaryKey() -> String? {
        "id"
    }

    override init() {
        super.init()
    }

    init(from orderItem: OrderItem) {
        id = orderItem.id
        product = RealmProduct(from: orderItem.product)
        quantity = orderItem.quantity
        super.init()
    }
}
