//
//  ProductRepositoryTests.swift
//  SimpleMarketTests
//
//  Created by Kariny on 25/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
final class ProductRepositoryTests: XCTestCase {
    private var factory: MockRealmFactory!
    private var repository: ProductRepositoryProtocol!

    override func setUp() {
        super.setUp()

        factory = MockRealmFactory()
        repository = ProductRepository(realmFactory: factory)
    }

    override func tearDown() {
        repository = nil
        factory = nil

        super.tearDown()
    }

    func testSave_whenNotPreviouslySaved_createsProduct() {
        let product = mockProduct
        try! repository.save(product: product)

        let realm = try! factory.makeRealm()
        let productCount = realm.objects(RealmProduct.self).count

        // Test contains only 1 created
        XCTAssertEqual(productCount, 1)

        // Tests fields saved correctly
        let persistedProduct = realm.objects(RealmProduct.self).first!
        XCTAssertEqual(product.id, persistedProduct.id)
        XCTAssertEqual(product.price, persistedProduct.price)
        XCTAssertEqual(product.description, persistedProduct.productDescription)
        XCTAssertEqual(product.stock, persistedProduct.stock)
        XCTAssertEqual(product.offer, persistedProduct.offer)
        XCTAssertEqual(product.imageURLString, persistedProduct.imageURLString)
    }

    func testFetchAllProducts_returnsAllPersistedProducts() {
        let product1 = Product(id: 1, price: 1.00, description: "P1", stock: 0, offer: 0, imageURLString: "imgURL1")
        let product2 = Product(id: 2, price: 2.00, description: "P2", stock: 0, offer: 0, imageURLString: "imgURL2")
        let products = [product1, product2]

        try! repository.save(product: product1)
        try! repository.save(product: product2)

        let persistedProducts = try! repository.fetchAll()
        XCTAssertEqual(products, persistedProducts)
    }

    func testFetchProductForID_returnsPreviouslySavedProductMatchingID() {
        let product = mockProduct
        XCTAssertNil(try! repository.fecthProduct(for: product.id))

        try! repository.save(product: product)
        XCTAssertNotNil(try! repository.fecthProduct(for: product.id))
    }

    func testDeleteProductForID_deletesEquationMatchingID() {
        let product = mockProduct
        try! repository.save(product: product)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmProduct.self).count
        XCTAssertEqual(beforeCount, 1)

        try! repository.delete(product: product)

        let afterCount = realm.objects(RealmProduct.self).count
        XCTAssertEqual(afterCount, 0)
    }

    func testDeleteProductForIDs_deletesSelectedProducts() {
        let product1 = Product(id: 1, price: 1.00, description: "P1", stock: 0, offer: 0, imageURLString: "imgURL1")
        let product2 = Product(id: 2, price: 2.00, description: "P2", stock: 0, offer: 0, imageURLString: "imgURL2")
        let product3 = Product(id: 3, price: 3.00, description: "P3", stock: 0, offer: 0, imageURLString: "imgURL3")

        try! repository.save(product: product1)
        try! repository.save(product: product2)
        try! repository.save(product: product3)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmProduct.self).count
        XCTAssertEqual(beforeCount, 3)

        try! repository.delete(product: product1)
        try! repository.delete(product: product2)

        let remainingProducts = realm.objects(RealmProduct.self)
        let afterCount = remainingProducts.count
        XCTAssertEqual(afterCount, 1)

        XCTAssertEqual(remainingProducts.first?.id, 3)
    }

    func testDeleteAll_removesAllPersistedProducts() {
        let product1 = Product(id: 1, price: 1.00, description: "P1", stock: 0, offer: 0, imageURLString: "imgURL1")
        let product2 = Product(id: 2, price: 2.00, description: "P2", stock: 0, offer: 0, imageURLString: "imgURL2")

        try! repository.save(product: product1)
        try! repository.save(product: product2)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmProduct.self).count
        XCTAssertEqual(beforeCount, 2)

        try! repository.deleteAll()

        let afterCount = realm.objects(RealmProduct.self).count
        XCTAssertEqual(afterCount, 0)
    }
}

private extension ProductRepositoryTests {
    var mockProduct: Product {
        Product(
            id: 0,
            price: 1.00,
            description: "Watter",
            stock: 0,
            offer: 0,
            imageURLString: "watterImageURL"
        )
    }
}
