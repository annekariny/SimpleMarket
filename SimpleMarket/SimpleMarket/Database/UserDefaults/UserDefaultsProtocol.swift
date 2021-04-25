//
//  UserDefaultsProtocol.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

protocol KeyValueStorageProtocol {
    var currentOrderID: Int { get set }
    var currentOrderItemID: Int { get set }
}

struct KeyValueStorage: KeyValueStorageProtocol {
    private let userDefaults: UserDefaultsProtocol

    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    private enum Keys {
        static let currentID = "SimpleMarket.currentOrderID"
        static let currentOrderItemID = "SimpleMarket.currentOrderItemID"
    }

    var currentOrderID: Int {
        get {
            userDefaults.object(forKey: Keys.currentID) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: Keys.currentID)
        }
    }

    var currentOrderItemID: Int {
        get {
            userDefaults.object(forKey: Keys.currentOrderItemID) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: Keys.currentOrderItemID)
        }
    }
}
