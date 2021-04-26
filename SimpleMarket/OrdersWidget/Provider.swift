//
//  Provider.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let orders: [Order]
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let placeHolderOrder = Order(id: 0, orderItems: [], isFinished: true)
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), orders: [placeHolderOrder])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let placeHolderOrder = Order(id: 0, orderItems: [], isFinished: true)
        let entry = SimpleEntry(date: Date(), configuration: configuration, orders: [placeHolderOrder])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let repository = OrderRepository()
        let orders = (try? repository.fetchAll().prefix(2)) ?? []
        entries.append(SimpleEntry(date: Date(), configuration: configuration, orders: Array(orders)))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
