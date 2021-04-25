//
//  ProductRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

protocol ProductRepositoryProtocol {
    func createProduct(from product: Product) throws
    func fecthProduct(for id: Int) throws -> Product?
    func fetchAll() throws -> [Product]
    func deleteAll() throws
    func delete(product: Product) throws
    func save(product: Product) throws
}

final class ProductRepository: ProductRepositoryProtocol {
    private let realmFactory: RealmFactoryProtocol

    init(
        realmFactory: RealmFactoryProtocol = RealmFactory()
    ) {
        self.realmFactory = realmFactory
    }

    func createProduct(from product: Product) throws {
        try save(product: product)
    }

    func fecthProduct(for id: Int) throws -> Product? {
        let realm = try realmFactory.makeRealm()
        guard let product = realm.objects(RealmProduct.self).filter("id == %@", id).first else {
            return nil
        }
        return Product(from: product)
    }

    func fetchAll() throws -> [Product] {
        let realm = try realmFactory.makeRealm()
        let realmProducts = realm.objects(RealmProduct.self)
        return realmProducts.map { Product(from: $0) }
    }

    func delete(product: Product) throws {
        let realm = try realmFactory.makeRealm()
        try realm.write {
            realm.delete(realm.objects(RealmProduct.self).filter("id == %@", product.id))
        }
    }

    func save(product: Product) throws {
        let realm = try realmFactory.makeRealm()
        let realmProduct = RealmProduct(from: product)
        try realm.write {
            realm.add(realmProduct, update: .modified)
        }
    }

    func deleteAll() throws {
        let realm = try realmFactory.makeRealm()
        let objects = realm.objects(RealmProduct.self)

        try? realm.write {
            realm.delete(objects)
        }
    }
}
