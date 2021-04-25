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

    init(id: Int, product: Product?) {
        self.id = id
        self.product = product
        self.quantity = 0
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
        lhs.id == rhs.id
    }
}
