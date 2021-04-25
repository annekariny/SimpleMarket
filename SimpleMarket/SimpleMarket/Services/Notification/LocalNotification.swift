//
//  LocalNotification.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

protocol LocalNotificationProtocol {
    var name: NSNotification.Name? { get }
}

enum LocalNotification: String, LocalNotificationProtocol {
    case orderSaved

    var name: NSNotification.Name? {
        NSNotification.Name(rawValue)
    }
}
