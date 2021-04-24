//
//  Double+Formatting.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

extension Double {
    func toCurrencyFormat() -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = .current
        return currencyFormatter.string(from: NSNumber(value: self))
    }
}
