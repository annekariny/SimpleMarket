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

    func orderInProgress() -> Order {
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

    func persistedProduct(for product: Product) -> Product {
        let persistedProduct: Product
        if let product = try? productRepository.fecthProduct(forID: product.id) {
            persistedProduct = product
        } else {
            try? productRepository.save(product: product)
            persistedProduct = product
        }
        return persistedProduct
    }

    func persistedOrderItem(for product: Product, order: Order) -> OrderItem {
        let persistedOrderItem: OrderItem
        if let orderItem = try? orderItemRepository.fecthOrderItem(forProductID: product.id, and: order.id) {
            persistedOrderItem = orderItem
        } else {
            let id = keyValueStorage.currentOrderItemID
            keyValueStorage.currentOrderItemID += 1
            let newOrderItem = OrderItem(id: id, product: product)
            var modifiedOrder = order
            modifiedOrder.orderItems?.append(newOrderItem)
            try? orderItemRepository.save(orderItem: newOrderItem)
            try? orderRepository.save(order: modifiedOrder)
            persistedOrderItem = newOrderItem
        }
        return persistedOrderItem
    }

    func persistedOrderItem(from orderItem: OrderItem) -> OrderItem? {
        let persistedOrderItem: OrderItem
        if let orderItem = try? orderItemRepository.fecthOrderItem(forID: orderItem.id) {
            persistedOrderItem = orderItem
        } else {
            let id = keyValueStorage.currentOrderItemID
            keyValueStorage.currentOrderItemID += 1
            let newOrderItem = OrderItem(id: id, product: orderItem.product)
            try? orderItemRepository.save(orderItem: newOrderItem)
            persistedOrderItem = newOrderItem
        }
        return persistedOrderItem
    }

    func sumProductQuantity(product: Product, order: Order) {
        // Fetch Product from Database, if not exists create a new one
        let modifiedProduct = persistedProduct(for: product)

        // Fetch OrderItem from this Product included on the order
        let orderItem = persistedOrderItem(for: modifiedProduct, order: order)

        // Increase Order Item quantity by 1
        sumOrderItemQuantity(orderItem: orderItem)
    }

    func sumOrderItemQuantity(orderItem: OrderItem) {
        guard var modifiedOrderItem = persistedOrderItem(from: orderItem) else {
            return
        }
        modifiedOrderItem.quantity += 1
        try? orderItemRepository.save(orderItem: modifiedOrderItem)
    }

    func decreaseOrderItemQuantity(orderItem: OrderItem) {
        var modifiedOrderItem = orderItem
        modifiedOrderItem.quantity -= 1

        if modifiedOrderItem.quantity == 0 {
            let product = modifiedOrderItem.product
            removeOrderItem(orderItem)
            deleteProductIfNeeded(product)
        } else {
            try? orderItemRepository.save(orderItem: modifiedOrderItem)
        }
    }

    @discardableResult
    func deleteProductIfNeeded(_ product: Product?) -> Bool {
        guard let product = product else {
            return false
        }
        let orderItems = try? orderItemRepository.fecthOrderItems(forProductID: product.id)
        if orderItems?.isEmpty ?? false {
            try? productRepository.delete(product: product)
            return true
        } else {
            return false
        }
    }

    func removeOrderItem(_ orderItem: OrderItem) {
        guard var order = try? orderRepository.fecthOrder(for: orderItem.id) else {
            return
        }
        order.orderItems?.removeAll { $0.id == orderItem.id }
        try? orderItemRepository.delete(orderItem: orderItem)
        try? orderRepository.save(order: order)
    }

    func getOrderItems(from order: Order) -> [OrderItem] {
        let orderItems = try? orderItemRepository.fecthOrderItems(from: order.id)
        return orderItems ?? []
    }
}
