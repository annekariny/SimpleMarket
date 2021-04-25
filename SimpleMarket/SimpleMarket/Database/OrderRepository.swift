//
//  OrderRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

final class OrderRepository {
    private let realmFactory: RealmFactoryProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory()
    ) {
        self.realmFactory = realmFactory
    }

    func fetchAll() throws -> [Order] {
        let realm = try realmFactory.makeRealm()
        let realmOrders = realm.objects(RealmOrder.self)
        return realmOrders.map { Order(from: $0) }
    }

    func save(order: Order) throws {
        let realm = try realmFactory.makeRealm()
        let realmOrder = RealmOrder(from: order)
        try realm.write {
            realm.add(realmOrder, update: .modified)
        }
    }
}
