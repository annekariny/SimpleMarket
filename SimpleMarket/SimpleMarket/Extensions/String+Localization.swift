//
//  String+Localization.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: "Localizable", bundle: Bundle(for: Localization.self as AnyClass), value: "", comment: "")
    }
}
