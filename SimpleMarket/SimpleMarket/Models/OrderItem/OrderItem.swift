//
//  OrderItem.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct OrderItem {
    let id: Int
    var quantity: Int
    var product: Product?

    var unitValue: Double {
        product?.price ?? 0
    }

    var totalValue: Double {
        Double(quantity) * unitValue
    }

    init(
        id: Int,
        product: Product?,
        quantity: Int = 0
    ) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }

    init(from realmOrderItem: RealmOrderItem) {
        id = realmOrderItem.id
        quantity = realmOrderItem.quantity
        if let realmProduct = realmOrderItem.product {
            product = Product(from: realmProduct)
        } else {
            product = nil
        }
    }
}

extension OrderItem: Equatable {
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.quantity == rhs.quantity &&
            lhs.product == rhs.product
    }
}
