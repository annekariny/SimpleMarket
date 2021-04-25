//
//  OrderItemRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

final class OrderItemRepository {
    private let realmFactory: RealmFactoryProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory()
    ) {
        self.realmFactory = realmFactory
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
