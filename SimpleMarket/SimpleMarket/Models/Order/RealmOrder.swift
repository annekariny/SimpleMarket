//
//  RealmOrder.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import RealmSwift

final class RealmOrder: Object {
    @objc dynamic var id = 0
    @objc dynamic var orderItems = [RealmOrderItem]()
    @objc dynamic var isFinished = false

    override static func primaryKey() -> String? {
        "id"
    }

    override init() {
        super.init()
    }

    init(from order: Order) {
        id = order.id
        isFinished = order.isFinished
        if let items = order.orderItems {
            self.orderItems = items.map { RealmOrderItem( from: $0) }
        }
        super.init()
    }
}
