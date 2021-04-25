//
//  MockRealmFactory.swift
//  SimpleMarketTests
//
//  Created by Kariny on 25/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket

final class MockRealmFactory: RealmFactoryProtocol {
    private let memoryId = "MockRealm"

    func makeRealm() throws -> Realm {
        let configuration = Realm.Configuration(inMemoryIdentifier: memoryId)
        return try Realm(configuration: configuration)
    }
}
