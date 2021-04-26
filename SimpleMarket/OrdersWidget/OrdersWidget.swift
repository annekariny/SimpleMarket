//
//  OrdersWidget.swift
//  OrdersWidget
//
//  Created by Kariny on 26/04/21.
//

import Intents
import SwiftUI
import WidgetKit

@main
struct OrdersWidget: Widget {
    let kind: String = "OrdersWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: OrderWidgetProvider()) { entry -> OrdersWidgetEntryView in
            let viewModel = OrdersViewModel(entry: entry)
            return OrdersWidgetEntryView(viewModel: viewModel)
        }
        .configurationDisplayName(Strings.simpleMarketWidget)
        .description(Strings.seeYourLastOrders)
        .supportedFamilies([.systemSmall])
    }
}

 struct OrdersWidget_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(id: 0, orderItems: [], isFinished: true)
        let entry = OrdersEntry(date: Date(), configuration: ConfigurationIntent(), orders: [order])
        let viewModel = OrdersViewModel(entry: entry)
        OrdersWidgetEntryView(viewModel: viewModel)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
 }
