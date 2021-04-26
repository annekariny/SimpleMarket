//
//  MockCartManager.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
final class MockCartManager: CartManagerProtocol {
    private let product: Product!
    private var orderItem: OrderItem!
    private var cart: Order!

    init () {
        product = Product(id: 1, price: 1, description: "P", imageURLString: "IMG")
        orderItem = OrderItem(id: 1, product: product, quantity: 0)
        cart = Order(id: 1, orderItems: [orderItem], isFinished: false)
    }

    func getCart() -> Order? {
        cart
    }

    func sumProductQuantity(product: Product) {
        var orderItem = cart.orderItems?.first!
        orderItem?.quantity += 1
        cart.orderItems = [orderItem!]
    }

    func sumQuantity(from orderItem: OrderItem) {
        var orderItem = cart.orderItems?.first!
        orderItem?.quantity += 1
        cart.orderItems = [orderItem!]
    }

    func reduceQuantity(from orderItem: OrderItem) {
        var orderItem = cart.orderItems?.first!
        orderItem?.quantity -= 1
        cart.orderItems = [orderItem!]
    }

    func getOrderItems() -> [OrderItem] {
        cart.orderItems!
    }

    func finishOrder(_ order: Order?) {
        cart.isFinished = true
    }

    func deleteAll() { }
    func saveCart() { }
}
