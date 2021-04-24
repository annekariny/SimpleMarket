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
    let totalValue: Double
    let isFinished: Bool

    init(with id: Int) {
        self.id = id
        orderItems = []
        totalValue = 0
        isFinished = false
    }

    init(from orderDB: OrderDB) {
        id = Int(orderDB.id)
        totalValue = orderDB.totalValue
        isFinished = orderDB.isFinished
        if let orderItemsDB = orderDB.orderItemsDB {
            orderItems = orderItemsDB.map { OrderItem(from: $0 as? OrderItemDB) }
        } else {
            orderItems = nil
        }
    }
}
