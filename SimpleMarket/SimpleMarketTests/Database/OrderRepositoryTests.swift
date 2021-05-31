//
//  OrderRepositoryTests.swift
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
final class OrderRespositoryTests: XCTestCase {
    private var factory: MockRealmFactory!
    private var repository: OrderRepositoryProtocol!
    private var keyValueStorage: KeyValueStorageProtocol!

    override func setUp() {
        super.setUp()

        factory = MockRealmFactory()
        keyValueStorage = MockKeyValueStorage()
        repository = OrderRepository(
            realmFactory: factory,
            keyValueStorage: keyValueStorage
        )
    }

    override func tearDown() {
        repository = nil
        keyValueStorage = nil
        factory = nil

        super.tearDown()
    }

    func testCreateOrder_returnsExpectedFields() {
        let order = try! repository.createOrder()

        let realm = try! factory.makeRealm()
        let orderCount = realm.objects(RealmOrder.self).count
        XCTAssertEqual(orderCount, 1)

        let persistedOrder = realm.objects(RealmOrder.self).first!
        let orderItems = Array(persistedOrder.orderItems).map { OrderItem(from: $0) }
        XCTAssertEqual(order.id, persistedOrder.id)
        XCTAssertEqual(order.isFinished, persistedOrder.isFinished)
        XCTAssertEqual(order.orderItems, orderItems)

        let orderItem = order.orderItems!.first
        let persistedOrderItem = orderItems.first

        XCTAssertEqual(orderItem?.id, persistedOrderItem?.id)
        XCTAssertEqual(orderItem?.product, persistedOrderItem?.product)
        XCTAssertEqual(orderItem?.quantity, persistedOrderItem?.quantity)
    }

    func testSave_whenNotPreviouslySaved_createsOrder() {
        let order = mockOrder1
        try! repository.save(order: order)

        let realm = try! factory.makeRealm()
        let orderCount = realm.objects(RealmOrder.self).count
        XCTAssertEqual(orderCount, 1)

        let persistedOrder = realm.objects(RealmOrder.self).first!
        let orderItems = Array(persistedOrder.orderItems).map { OrderItem(from: $0) }
        XCTAssertEqual(order.id, persistedOrder.id)
        XCTAssertEqual(order.isFinished, persistedOrder.isFinished)
        XCTAssertEqual(order.orderItems, orderItems)

        let orderItem = order.orderItems!.first
        let persistedOrderItem = orderItems.first

        XCTAssertEqual(orderItem?.id, persistedOrderItem?.id)
        XCTAssertEqual(orderItem?.product, persistedOrderItem?.product)
        XCTAssertEqual(orderItem?.quantity, persistedOrderItem?.quantity)
    }

    func testAddOrderItem_returnsOrderWithOrderItem() {
        let order = try! repository.createOrder()
        let orderItem = mockOrderItem1

        try! repository.addOrderItem(orderItem, intoOrder: order)

        let realm = try! factory.makeRealm()
        let orderCount = realm.objects(RealmOrder.self).count
        XCTAssertEqual(orderCount, 1)

        let persistedOrder = realm.objects(RealmOrder.self).first!
        let orderItems = Array(persistedOrder.orderItems).map { OrderItem(from: $0) }
        XCTAssertEqual(order.id, persistedOrder.id)
        XCTAssertEqual(order.isFinished, persistedOrder.isFinished)
        XCTAssertEqual(orderItems.first, orderItem)
    }

    func testFetchAllOrders_returnsAllPersistedOrder() {
        let order1 = mockOrder1
        let order2 = mockOrder2
        let orders = [order1, order2]

        try! repository.save(order: order1)
        try! repository.save(order: order2)

        let persistedOrders = try! repository.fetchAllOrders()
        XCTAssertEqual(orders, persistedOrders)
    }

    func testFetchOrderForID_returnsPreviouslySavedOrderMatchingID() {
        let order = mockOrder1
        XCTAssertNil(try! repository.fecthOrder(forID: order.id))

        try! repository.save(order: order)
        XCTAssertNotNil(try! repository.fecthOrder(forID: order.id))
    }

    func testFetchOrderForOrderItemID_returnsOrderMatchingID() {
        let order = mockOrder1
        let orderItem = mockOrderItem1

        try! repository.save(order: order)
        let persistedOrder = try! repository.fecthOrder(for: orderItem.id)

        XCTAssertEqual(order, persistedOrder)
    }

    func testFetchUnfinishedOrder_returnsOrderMatchingID() {
        let order1 = mockOrder1
        let order2 = mockOrder1

        try! repository.save(order: order1)
        try! repository.save(order: order2)
        let persistedOrder = try! repository.fecthUnfinishedOrder()

        XCTAssertEqual(order1, persistedOrder)
    }

    func testDeleteAll_removesAllPersistedOrderItems() {
        let order1 = mockOrder1
        let order2 = mockOrder2
        try! repository.save(order: order1)
        try! repository.save(order: order2)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmOrder.self).count
        XCTAssertEqual(beforeCount, 2)

        try! repository.deleteAll()

        let afterCount = realm.objects(RealmOrder.self).count
        XCTAssertEqual(afterCount, 0)
    }
}

private extension OrderRespositoryTests {
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

    var mockOrder1: Order {
        Order(
            id: 1,
            orderItems: [mockOrderItem1],
            isFinished: false
        )
    }

    var mockOrder2: Order {
        Order(
            id: 2,
            orderItems: [mockOrderItem2],
            isFinished: true
        )
    }
}
