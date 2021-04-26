//
//  OrdersEntry.swift
//  OrdersWidgetExtension
//
//  Created by Kariny on 26/04/21.
//

import Intents
import WidgetKit

struct OrdersEntry: TimelineEntry {
    let date: Date
    let orders: [Order]
}
