//
//  SmallOrderWidgetView.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import WidgetKit
import SwiftUI

struct SmallOrderWidgetView: View {
    let orders: [Order]

    var body: some View {
        HStack {
            VStack {
                ForEach(orders, id: \.self) { order in
                    OrderRow(order: order)
                    Spacer()
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct OrderRow: View {
    var order: Order

    var body: some View {
        VStack(alignment: .leading) {
            Text("Order #\(order.id)")
                .font(Font.system(.headline))

            Text("Total: \(order.total.toCurrencyFormat() ?? "")")
                .font(Font.system(.subheadline))
                .foregroundColor(.green)
        }
    }
}

struct SmallOrderWidgetView_Previews: PreviewProvider {
    static let previewOrder = Order(id: 0, orderItems: [], isFinished: true)
    static let previewOrder1 = Order(id: 1, orderItems: [], isFinished: true)
    static let previewOrder2 = Order(id: 2, orderItems: [], isFinished: true)
    static var previews: some View {
        SmallOrderWidgetView(
            orders: [previewOrder, previewOrder1, previewOrder2]
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
