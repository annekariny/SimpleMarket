//
//  OrderWidgetProvider.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import Intents
import SwiftUI
import WidgetKit

struct OrdersEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let orders: [Order]
}

struct OrderWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> OrdersEntry {
        makeTemporaryEntry()
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (OrdersEntry) -> Void) {
        completion(makeTemporaryEntry())
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<OrdersEntry>) -> Void) {
        var entries: [OrdersEntry] = []

        let repository = OrderRepository()
        if let orders = try? repository.fetchOrders(limit: 3, isFinished: true) {
            entries.append(OrdersEntry(date: Date(), configuration: configuration, orders: orders))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func makeTemporaryEntry() -> OrdersEntry {
        let order = Order(id: 0, orderItems: [], isFinished: true)
        return OrdersEntry(date: Date(), configuration: ConfigurationIntent(), orders: [order])
    }
}
