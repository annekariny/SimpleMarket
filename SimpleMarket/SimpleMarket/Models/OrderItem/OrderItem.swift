//
//  OrderItem.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct OrderItem {
    let id: Int
    let product: Product?
    let totalValue: Double

    var unitValue: Double {
        product?.price ?? 0
    }

    init(from orderItemDB: OrderItemDB?) {
        id = Int(orderItemDB?.id ?? 0)
        totalValue = orderItemDB?.totalValue ?? 0
        if let productDB = orderItemDB?.productDB {
            product = Product(from: productDB)
        } else {
            product = nil
        }
    }
}
