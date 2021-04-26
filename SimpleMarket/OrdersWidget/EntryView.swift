//
//  EntryView.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import WidgetKit
import SwiftUI

struct OrdersWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}
