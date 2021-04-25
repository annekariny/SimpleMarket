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

    func fecthUnfinishedOrder() throws -> Order? {
        let realm = try realmFactory.makeRealm()
        guard let order = realm.objects(RealmOrder.self).filter("isFinished == %@", false).first else {
            return nil
        }
        return Order(from: order)
    }

    func fecthOrder(forID id: Int) throws -> Order? {
        let realm = try realmFactory.makeRealm()
        guard let order = realm.objects(RealmOrder.self).filter("id == %@", id).first else {
            return nil
        }
        return Order(from: order)
    }

    func fecthOrder(for orderItemID: Int) throws -> Order? {
        let realm = try realmFactory.makeRealm()
        let orders = realm.objects(RealmOrder.self)
        if let order = orders.filter("ANY orderItems.id == %@", orderItemID).first {
            return Order(from: order)
        } else {
            return nil
        }
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
