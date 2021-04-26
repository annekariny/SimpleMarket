//
//  OrdersWidget.swift
//  OrdersWidget
//
//  Created by Kariny on 26/04/21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct OrdersWidget: Widget {
    let kind: String = "OrdersWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            OrdersWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct OrdersWidget_Previews: PreviewProvider {
    static var previews: some View {
        OrdersWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
