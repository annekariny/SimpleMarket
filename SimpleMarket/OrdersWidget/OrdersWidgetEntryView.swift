//
//  OrdersWidgetEntryView.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import WidgetKit
import SwiftUI

struct OrdersWidgetEntryView: View {
    let viewModel: OrdersViewModel

    var body: some View {
        SmallOrderWidgetView(orders: viewModel.orders)
    }
}
