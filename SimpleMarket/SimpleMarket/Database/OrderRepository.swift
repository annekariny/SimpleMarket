//
//  OrderRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

protocol OrderRepositoryProtocol {
    func createOrder() throws -> Order
    func addOrderItem(_ orderItem: OrderItem, intoOrder order: Order) throws
    func fecthUnfinishedOrder() throws -> Order?
    func fecthOrder(forID id: Int) throws -> Order?
    func fecthOrder(for orderItemID: Int) throws -> Order?
    func fetchFinishedOrders() throws -> [Order]
    func fetchAllOrders() throws -> [Order]
    func fetchOrders(limit: Int, isFinished: Bool) throws -> [Order]
    func save(order: Order) throws
    func deleteAll() throws
}

final class OrderRepository: OrderRepositoryProtocol {
    private let realmFactory: RealmFactoryProtocol
    private var keyValueStorage: KeyValueStorageProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory(),
        keyValueStorage: KeyValueStorageProtocol = KeyValueStorage()
    ) {
        self.realmFactory = realmFactory
        self.keyValueStorage = keyValueStorage
    }

    func createOrder() throws -> Order {
        let id = keyValueStorage.currentOrderID
        keyValueStorage.currentOrderID += 1
        let order = Order(id: id)
        try save(order: order)
        return order
    }

    func addOrderItem(_ orderItem: OrderItem, intoOrder order: Order) throws {
        var modifierOrder = order
        modifierOrder.orderItems?.append(orderItem)
        try save(order: modifierOrder)
    }

    func fecthUnfinishedOrder() throws -> Order? {
        try fetchAll(isFinished: false).first
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

    func fetchFinishedOrders() throws -> [Order] {
        try fetchAll(isFinished: true)
    }

    func fetchAllOrders() throws -> [Order] {
        try fetchAll()
    }

    func fetchOrders(limit: Int, isFinished: Bool) throws -> [Order] {
        try fetchAll(limit: limit, isFinished: isFinished)
    }

    private func fetchAll(limit: Int? = nil, isFinished: Bool = false) throws -> [Order] {
        let realm = try realmFactory.makeRealm()
        let realmOrders = realm.objects(RealmOrder.self).filter("isFinished == %@", isFinished)
        if let limit = limit {
            return Array(realmOrders.prefix(limit)).map { Order(from: $0) }
        } else {
            return realmOrders.map { Order(from: $0) }
        }
    }

    func save(order: Order) throws {
        let realm = try realmFactory.makeRealm()
        let realmOrder = RealmOrder(from: order)
        try realm.write {
            realm.add(realmOrder, update: .modified)
        }
    }

    func deleteAll() throws {
        let realm = try realmFactory.makeRealm()
        let objects = realm.objects(RealmOrder.self)

        try? realm.write {
            realm.delete(objects)
        }
    }
}
