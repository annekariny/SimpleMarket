//
//  OrderItemRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

protocol OrderItemRepositoryProtocol {
    func createOrderItem(fromProduct product: Product) throws -> OrderItem?
    func fecthOrderItem(for id: Int) throws -> OrderItem?
    func fecthOrderItems(forProductID productID: Int) throws -> [OrderItem]
    func fecthOrderItems(forOrderID orderID: Int) throws -> [OrderItem]
    func fecthOrderItem(forProductID productID: Int, andOrderID orderID: Int) throws -> OrderItem?
    func fetchAll() throws -> [OrderItem]
    func save(orderItem: OrderItem) throws
    func delete(orderItem: OrderItem) throws
    func deleteAll() throws
}

final class OrderItemRepository: OrderItemRepositoryProtocol {
    private let realmFactory: RealmFactoryProtocol
    private var keyValueStorage: KeyValueStorageProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory(),
        keyValueStorage: KeyValueStorageProtocol = KeyValueStorage()
    ) {
        self.realmFactory = realmFactory
        self.keyValueStorage = keyValueStorage
    }

    func createOrderItem(fromProduct product: Product) throws -> OrderItem? {
        let id = keyValueStorage.currentOrderItemID
        keyValueStorage.currentOrderItemID += 1
        let orderItem = OrderItem(id: id, product: product)
        try? save(orderItem: orderItem)
        return orderItem
    }

    func fecthOrderItem(for id: Int) throws -> OrderItem? {
        let realm = try realmFactory.makeRealm()
        guard let orderItem = realm.objects(RealmOrderItem.self).filter("id == %@", id).first else {
            return nil
        }
        return OrderItem(from: orderItem)
    }

    func fecthOrderItems(forProductID productID: Int) throws -> [OrderItem] {
        let realm = try realmFactory.makeRealm()
        let orderItem = realm.objects(RealmOrderItem.self).filter("product.id == %@", productID)
        return orderItem.map { OrderItem(from: $0) }
    }

    func fecthOrderItems(forOrderID orderID: Int) throws -> [OrderItem] {
        let realm = try realmFactory.makeRealm()
        let orderItem = realm.objects(RealmOrderItem.self).filter("ANY orders.id == %@", orderID)
        return orderItem.map { OrderItem(from: $0) }
    }

    func fecthOrderItem(forProductID productID: Int, andOrderID orderID: Int) throws -> OrderItem? {
        let realm = try realmFactory.makeRealm()
        if let orderItem = realm.objects(RealmOrderItem.self).filter("product.id == %@ AND ANY orders.id == %@", productID, orderID).first {
            return OrderItem(from: orderItem)
        } else {
            return nil
        }
    }

    func fetchAll() throws -> [OrderItem] {
        let realm = try realmFactory.makeRealm()
        let realmOrderItems = realm.objects(RealmOrderItem.self)
        return realmOrderItems.map { OrderItem(from: $0) }
    }

    func save(orderItem: OrderItem) throws {
        let realm = try realmFactory.makeRealm()
        let realmOrderItem = RealmOrderItem(from: orderItem)
        try realm.write {
            realm.add(realmOrderItem, update: .modified)
        }
    }

    func delete(orderItem: OrderItem) throws {
        let realm = try realmFactory.makeRealm()
        try realm.write {
            realm.delete(realm.objects(RealmOrderItem.self).filter("id == %@", orderItem.id))
        }
    }

    func deleteAll() throws {
        let realm = try realmFactory.makeRealm()
        let objects = realm.objects(RealmOrderItem.self)

        try? realm.write {
            realm.delete(objects)
        }
    }
}
