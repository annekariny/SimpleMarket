//
//  CartManagerTests.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
final class CartManagerTests: XCTestCase {
    private var productRepository: ProductRepositoryProtocol!
    private var orderRepository: OrderRepositoryProtocol!
    private var orderItemRepository: OrderItemRepositoryProtocol!
    private var cartManager: CartManagerProtocol!

    override func setUp() {
        super.setUp()
        let factory = MockRealmFactory()
        let keyValueStorage = MockKeyValueStorage()
        productRepository = ProductRepository(realmFactory: factory)
        orderRepository = OrderRepository(
            realmFactory: factory,
            keyValueStorage: keyValueStorage
        )
        orderItemRepository = OrderItemRepository(
            realmFactory: factory,
            keyValueStorage: keyValueStorage
        )
        cartManager = CartManager(
            productRepository: productRepository,
            orderItemRepository: orderItemRepository,
            orderRepository: orderRepository
        )
    }

    override func tearDown() {
        productRepository = nil
        orderRepository = nil
        orderItemRepository = nil
        cartManager = nil

        super.tearDown()
    }

    func testGetCart_returnsUnfinishedOrder() {
        let cart = cartManager.getCart()!
        XCTAssertFalse(cart.isFinished)
    }

    func testSumProductQuantity_returnsCartWithAddedProduct() {
        let product = mockProduct1
        cartManager.sumProductQuantity(product: product)

        let cart = cartManager.getCart()!
        let addedProduct = cart.orderItems?.first?.product!
        XCTAssertEqual(product, addedProduct)
    }

    func testSumOrderItemQuantity_returnsCartWithOrderItemAdded() {
        let product = Product(id: 0, price: 1, description: "M1", imageURLString: "img")
        cartManager.sumProductQuantity(product: product)

        let orderItem = cartManager.getOrderItems().first!
        XCTAssertEqual(orderItem.quantity, 1)

        cartManager.sumQuantity(from: orderItem)

        let updatedOrderItem = cartManager.getOrderItems().first!
        XCTAssertEqual(updatedOrderItem.quantity, 2)
    }

    func testReduceOrderItemQuantity_returnsCartWithOrderItemReduced() {
        let product = Product(id: 0, price: 1, description: "M1", imageURLString: "img")
        cartManager.sumProductQuantity(product: product) // Set quantity 1

        let orderItem = cartManager.getOrderItems().first!
        XCTAssertEqual(orderItem.quantity, 1)

        cartManager.sumQuantity(from: orderItem) // Set quantity 2
        let updatedOrderItem = cartManager.getOrderItems().first!
        XCTAssertEqual(updatedOrderItem.quantity, 2)

        cartManager.reduceQuantity(from: updatedOrderItem)
        let updatedOrderItemDelete = cartManager.getOrderItems().first!
        XCTAssertEqual(updatedOrderItemDelete.quantity, 1)
    }

    func testReduceOrderItemQuantity_returnsEmptyOrderItems() {
        let product = Product(id: 0, price: 1, description: "M1", imageURLString: "img")
        cartManager.sumProductQuantity(product: product) // Set quantity 1

        let orderItem = cartManager.getOrderItems().first!
        cartManager.reduceQuantity(from: orderItem)  // Set quantity 0

        let orderItems = cartManager.getOrderItems().first
        XCTAssertNil(orderItems)
    }

    func testReduceOrderItemQuantity_returnsDeletesProduct() {
        let product = Product(id: 0, price: 1, description: "M1", imageURLString: "img")
        cartManager.sumProductQuantity(product: product) // Set quantity 1

        let orderItem = cartManager.getOrderItems().first!
        cartManager.reduceQuantity(from: orderItem) // Set quantity 0

        let persistedProduct = try! productRepository.fecthProduct(for: product.id)
        XCTAssertNil(persistedProduct)
    }

    func testSaveCart_returnFinishedOrder() {
        let cart = cartManager.getCart()!
        cartManager.finishOrder(cart)
        let savedOrder = try! orderRepository.fecthOrder(forID: cart.id)
        XCTAssertTrue(savedOrder!.isFinished)
    }

    func testGetOrderItems_returnSavedOrderItemForProduct() {
        let product = mockProduct1
        cartManager.sumProductQuantity(product: product) // Set quantity 1

        let orderItem = cartManager.getOrderItems().first!
        XCTAssertEqual(orderItem.product, product)
    }
}

extension CartManagerTests {
    var mockProduct1: Product {
        Product(
            id: 1,
            price: 1.00,
            description: "Mock1",
            stock: 1,
            offer: 1,
            imageURLString: "mockURL1"
        )
    }

    var mockProduct2: Product {
        Product(
            id: 2,
            price: 2.00,
            description: "Mock2",
            stock: 2,
            offer: 2,
            imageURLString: "mockURL2"
        )
    }

    var mockOrderItem1: OrderItem {
        OrderItem(
            id: 1,
            product: mockProduct1,
            quantity: 1
        )
    }

    var mockOrderItem2: OrderItem {
        OrderItem(
            id: 2,
            product: mockProduct2,
            quantity: 2
        )
    }
}
