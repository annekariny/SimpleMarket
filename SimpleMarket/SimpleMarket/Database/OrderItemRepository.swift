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

    func save(orderItem: OrderItem) throws {
        let realm = try realmFactory.makeRealm()
        let realmOrderItem = RealmOrderItem(from: orderItem)
        try realm.write {
            realm.add(realmOrderItem, update: .modified)
        }
    }
}
