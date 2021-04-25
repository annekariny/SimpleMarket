//
//  CartManager.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

final class CartManager {
    private let productRepository: ProductRepository
    private let orderItemRepository: OrderItemRepository
    private let orderRepository: OrderRepository
    private var keyValueStorage: KeyValueStorageProtocol

    init(
        productRepository: ProductRepository = ProductRepository(),
        orderItemRepository: OrderItemRepository = OrderItemRepository(),
        orderRepository: OrderRepository = OrderRepository(),
        keyValueStorage: KeyValueStorageProtocol = KeyValueStorage()
    ) {
        self.productRepository = productRepository
        self.orderItemRepository = orderItemRepository
        self.orderRepository = orderRepository
        self.keyValueStorage = keyValueStorage
    }

    func orderInProgress() -> Order? {
        if let unfinishedOrder = try? orderRepository.fecthUnfinishedOrder() {
            return unfinishedOrder
        } else {
            let id = keyValueStorage.currentOrderID
            keyValueStorage.currentOrderID += 1
            let newOrder = Order(with: id)
            try? orderRepository.save(order: newOrder)
            return newOrder
        }
    }
}
