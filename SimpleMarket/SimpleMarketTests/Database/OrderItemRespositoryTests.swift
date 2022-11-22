//
//  OrderItemRespositoryTests.swift
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
final class OrderItemRespositoryTests: XCTestCase {
    private var factory: MockRealmFactory!
    private var repository: OrderItemRepositoryProtocol!

    override func setUp() {
        super.setUp()

        factory = MockRealmFactory()
        repository = OrderItemRepository(realmFactory: factory)
    }

    override func tearDown() {
        repository = nil
        factory = nil

        super.tearDown()
    }

    func testSave_whenNotPreviouslySaved_createsOrderItem() {
        let orderItem = mockOrderItem
        try! repository.save(orderItem: orderItem)

        let realm = try! factory.makeRealm()
        let orderItemCount = realm.objects(RealmOrderItem.self).count
        XCTAssertEqual(orderItemCount, 1)

        let persistedOrderItem = realm.objects(RealmOrderItem.self).first!
        XCTAssertEqual(orderItem.id, persistedOrderItem.id)
        XCTAssertEqual(orderItem.quantity, persistedOrderItem.quantity)

        XCTAssertEqual(orderItem.product?.id, persistedOrderItem.product?.id)
        XCTAssertEqual(orderItem.product?.price, persistedOrderItem.product?.price)
        XCTAssertEqual(orderItem.product?.description, persistedOrderItem.product?.productDescription)
        XCTAssertEqual(orderItem.product?.stock, persistedOrderItem.product?.stock)
        XCTAssertEqual(orderItem.product?.offer, persistedOrderItem.product?.offer)
        XCTAssertEqual(orderItem.product?.imageURLString, persistedOrderItem.product?.imageURLString)
    }

    func testFetchAllOrderItems_returnsAllPersistedOrderItems() {
        let orderItem1 = OrderItem(id: 1, product: mockProduct1, quantity: 1)
        let orderItem2 = OrderItem(id: 2, product: mockProduct2, quantity: 2)
        let orderItems = [orderItem1, orderItem2]

        try! repository.save(orderItem: orderItem1)
        try! repository.save(orderItem: orderItem2)

        let persistedOrderItems = try! repository.fetchAll()
        XCTAssertEqual(orderItems, persistedOrderItems)
    }

    func testFetchOrderItemForID_returnsPreviouslySavedOrderItemMatchingID() {
        let orderItem = mockOrderItem
        XCTAssertNil(try! repository.fecthOrderItem(for: orderItem.id))

        try! repository.save(orderItem: orderItem)
        XCTAssertNotNil(try! repository.fecthOrderItem(for: orderItem.id))
    }

    func testFetchOrderItemForProductID_returnsOrderItemMatchingID() {
        let product = mockProduct1
        let orderItem = mockOrderItem

        try! repository.save(orderItem: orderItem)
        let persistedOrderItem = try! repository.fecthOrderItems(forProductID: product.id).first

        XCTAssertEqual(orderItem, persistedOrderItem)
    }

    func testFetchOrderItemForOrderID_returnsOrderItemMatchingID() {
        let order = mockOrder
        let orderItem = mockOrderItem

        try! repository.save(orderItem: orderItem)

        let orderRepository = OrderRepository(realmFactory: factory)
        try! orderRepository.save(order: order)

        let persistedOrderItem = try! repository.fecthOrderItems(forOrderID: order.id).first

        XCTAssertEqual(orderItem, persistedOrderItem)
    }

    func testFetchOrderItemForProductIDAndOrderID_returnsOrderItemMatchingID() {
        let product = mockProduct1
        let order = mockOrder
        let orderItem = mockOrderItem

        try! repository.save(orderItem: orderItem)

        let orderRepository = OrderRepository(realmFactory: factory)
        try! orderRepository.save(order: order)

        let persistedOrderItem = try! repository.fecthOrderItem(forProductID: product.id, andOrderID: order.id)!

        XCTAssertEqual(orderItem, persistedOrderItem)
    }

    func testAddQuantity_increaseOrderItemQuantity() {
        let orderItem = OrderItem(id: 0, product: mockProduct1, quantity: 0)

        try! repository.save(orderItem: orderItem)
        try! repository.addQuantity(on: orderItem)

        let persistedOrderItem = try! repository.fecthOrderItem(for: orderItem.id)!
        XCTAssertEqual(persistedOrderItem.quantity, 1)
    }

    func testReduceQuantity_decreaseOrderItemQuantity() {
        let orderItem = OrderItem(id: 0, product: mockProduct1, quantity: 1)

        try! repository.save(orderItem: orderItem)
        try! repository.removeQuantity(on: orderItem)

        let persistedOrderItem = try! repository.fecthOrderItem(for: orderItem.id)!
        XCTAssertEqual(persistedOrderItem.quantity, 0)
    }

    func testDeleteOrderItem_deletesOrderItemMatchingID() {
        let orderItem = mockOrderItem
        try! repository.save(orderItem: orderItem)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmOrderItem.self).count
        XCTAssertEqual(beforeCount, 1)

        try! repository.delete(orderItem: orderItem)

        let afterCount = realm.objects(RealmOrderItem.self).count
        XCTAssertEqual(afterCount, 0)
    }

    func testDeleteOrderItemIDs_deletesSelectedOrderItems() {
        let orderItem1 = OrderItem(id: 1, product: mockProduct1, quantity: 1)
        let orderItem2 = OrderItem(id: 2, product: mockProduct2, quantity: 2)
        let orderItem3 = OrderItem(id: 3, product: mockProduct3, quantity: 3)

        try! repository.save(orderItem: orderItem1)
        try! repository.save(orderItem: orderItem2)
        try! repository.save(orderItem: orderItem3)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmOrderItem.self).count
        XCTAssertEqual(beforeCount, 3)

        try! repository.delete(orderItem: orderItem1)
        try! repository.delete(orderItem: orderItem2)

        let remainingOrderItems = realm.objects(RealmOrderItem.self)
        let afterCount = remainingOrderItems.count
        XCTAssertEqual(afterCount, 1)

        XCTAssertEqual(remainingOrderItems.first?.id, 3)
    }

    func testDeleteAll_removesAllPersistedOrderItems() {
        let orderItem1 = OrderItem(id: 1, product: mockProduct1, quantity: 1)
        let orderItem2 = OrderItem(id: 2, product: mockProduct2, quantity: 2)

        try! repository.save(orderItem: orderItem1)
        try! repository.save(orderItem: orderItem2)

        let realm = try! factory.makeRealm()
        let beforeCount = realm.objects(RealmOrderItem.self).count
        XCTAssertEqual(beforeCount, 2)

        try! repository.deleteAll()

        let afterCount = realm.objects(RealmOrderItem.self).count
        XCTAssertEqual(afterCount, 0)
    }
}

private extension OrderItemRespositoryTests {
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

    var mockProduct3: Product {
        Product(
            id: 3,
            price: 3.00,
            description: "Mock3",
            stock: 3,
            offer: 3,
            imageURLString: "mockURL3"
        )
    }

    var mockOrderItem: OrderItem {
        OrderItem(
            id: 0,
            product: mockProduct1,
            quantity: 0
        )
    }

    var mockOrder: Order {
        Order(
            id: 0,
            orderItems: [mockOrderItem],
            isFinished: false
        )
    }
}
