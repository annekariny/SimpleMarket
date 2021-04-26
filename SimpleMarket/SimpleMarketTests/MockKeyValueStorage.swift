//
//  MockKeyValueStorage.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket

final class MockKeyValueStorage: KeyValueStorageProtocol {
    var currentOrderID: Int = 0
    var currentOrderItemID: Int = 0
}
