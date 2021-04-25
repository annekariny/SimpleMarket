//
//  Order.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct Order {
    let id: Int
    let orderItems: [OrderItem]?
    let isFinished: Bool

    var total: Double {
        let totalValueFromOrderItems = orderItems?.compactMap { $0.totalValue }
        return totalValueFromOrderItems?.reduce(0, +) ?? 0
    }

    init(with id: Int) {
        self.id = id
        orderItems = []
        isFinished = false
    }

    init(from realmOrder: RealmOrder) {
        id = realmOrder.id
        isFinished = realmOrder.isFinished
        orderItems = realmOrder.orderItems.map { OrderItem(from: $0) }
    }
}
