//
//  NotificationManager.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

protocol NotificationManagerProtocol: AnyObject {
    func add(observer: Any, selector: Selector, notification: LocalNotificationProtocol, object: Any?)
    func post(notification: LocalNotificationProtocol, object: Any?, userInfo: [AnyHashable: Any]?)
    func removeAllObservers(from: Any)
}

final class NotificationManager: NotificationManagerProtocol {
    func add(observer: Any, selector: Selector, notification: LocalNotificationProtocol, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notification.name, object: object)
    }

    func post(notification: LocalNotificationProtocol, object: Any?, userInfo: [AnyHashable: Any]?) {
        guard let name = notification.name else {
            return
        }
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }

    func removeAllObservers(from: Any) {
        NotificationCenter.default.removeObserver(from)
    }
}
