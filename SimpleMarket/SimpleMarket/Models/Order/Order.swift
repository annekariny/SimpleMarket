//
//  Order.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

struct Order {
    let id: Int
    var orderItems: [OrderItem]?
    var isFinished: Bool

    var total: Double {
        let totalValueFromOrderItems = orderItems?.compactMap { $0.totalValue }
        return totalValueFromOrderItems?.reduce(0, +) ?? 0
    }

    init(
        id: Int,
        orderItems: [OrderItem] = [],
        isFinished: Bool = false
    ) {
        self.id = id
        self.orderItems = orderItems
        self.isFinished = isFinished
    }

    init(from realmOrder: RealmOrder) {
        id = realmOrder.id
        isFinished = realmOrder.isFinished
        orderItems = realmOrder.orderItems.map { OrderItem(from: $0) }
    }
}

extension Order: Equatable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id && lhs.isFinished == rhs.isFinished && lhs.orderItems == rhs.orderItems
    }
}

extension Order: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
