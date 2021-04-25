//
//  OrderItemRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

final class OrderItemRepository {
    private let orderRepository: OrderRepository
    private let realmFactory: RealmFactoryProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory(),
        orderRepository: OrderRepository = OrderRepository()
    ) {
        self.realmFactory = realmFactory
        self.orderRepository = orderRepository
    }

    func fecthOrderItem(forID id: Int) throws -> OrderItem? {
        let realm = try realmFactory.makeRealm()
        guard let orderItem = realm.objects(RealmOrderItem.self).filter("id == %@", id).first else {
            return nil
        }
        return OrderItem(from: orderItem)
    }

    func fecthOrderItem(forProductID productID: Int, and orderID: Int) throws -> OrderItem? {
        guard let orderItems = try? fecthOrderItems(from: orderID) else {
            return nil
        }
        return orderItems.first { $0.product?.id == productID }
    }

    func fecthOrderItems(forProductID productID: Int) throws -> [OrderItem] {
        let realm = try realmFactory.makeRealm()
        let orderItem = realm.objects(RealmOrderItem.self).filter("product.id == %@", productID)
        return orderItem.map { OrderItem(from: $0) }
    }

    func fecthOrderItems(from orderID: Int) throws -> [OrderItem]? {
        guard let order = try orderRepository.fecthOrder(forID: orderID) else {
            return nil
        }
        return order.orderItems
    }

    func fetchAll() throws -> [OrderItem] {
        let realm = try realmFactory.makeRealm()
        let realmOrderItems = realm.objects(RealmOrderItem.self)
        return realmOrderItems.map { OrderItem(from: $0) }
    }

    func delete(orderItem: OrderItem) throws {
        let realm = try realmFactory.makeRealm()
        try realm.write {
            realm.delete(realm.objects(RealmOrderItem.self).filter("id == %@", orderItem.id))
        }
    }

    func save(orderItem: OrderItem) throws {
        let realm = try realmFactory.makeRealm()
        let realmOrderItem = RealmOrderItem(from: orderItem)
        try realm.write {
            realm.add(realmOrderItem, update: .modified)
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
