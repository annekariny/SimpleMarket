//
//  ProductRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

final class ProductRepository {
    private let realmFactory: RealmFactoryProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory()
    ) {
        self.realmFactory = realmFactory
    }

    func fetchAll() throws -> [Product] {
        let realm = try realmFactory.makeRealm()
        let realmProducts = realm.objects(RealmProduct.self)
        return realmProducts.map { Product(from: $0) }
    }

    func save(product: Product) throws {
        let realm = try realmFactory.makeRealm()
        let realmProduct = RealmProduct(from: product)
        try realm.write {
            realm.add(realmProduct, update: .modified)
        }
    }
}
