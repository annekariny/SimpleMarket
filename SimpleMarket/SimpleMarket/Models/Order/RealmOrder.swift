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
    @objc dynamic var isFinished = false
    var orderItems = List<RealmOrderItem>()

    override static func primaryKey() -> String? {
        "id"
    }

    override init() {
        super.init()
    }

    init(from order: Order?) {
        id = order?.id ?? 0
        isFinished = order?.isFinished ?? false

        if let items = order?.orderItems {
            let orderItems = List<RealmOrderItem>()
            items.forEach { orderItem in
                orderItems.append(RealmOrderItem(from: orderItem))
            }
            self.orderItems = orderItems
        }
        super.init()
    }
}
