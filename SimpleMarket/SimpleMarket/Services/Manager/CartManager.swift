//
//  CartManager.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

protocol CartManagerProtocol {
    func getCart() -> Order?
    func sumProductQuantity(product: Product)
    func sumQuantity(from orderItem: OrderItem)
    func reduceQuantity(from orderItem: OrderItem)
    func getOrderItems(from order: Order?) -> [OrderItem]
    func finishOrder(_ order: Order?)
    func deleteAll()
    func saveCart()
}

final class CartManager {
    private let productRepository: ProductRepositoryProtocol
    private let orderItemRepository: OrderItemRepositoryProtocol
    private let orderRepository: OrderRepositoryProtocol
    private var keyValueStorage: KeyValueStorageProtocol

    init(
        productRepository: ProductRepositoryProtocol = ProductRepository(),
        orderItemRepository: OrderItemRepositoryProtocol = OrderItemRepository(),
        orderRepository: OrderRepositoryProtocol = OrderRepository(),
        keyValueStorage: KeyValueStorageProtocol = KeyValueStorage()
    ) {
        self.productRepository = productRepository
        self.orderItemRepository = orderItemRepository
        self.orderRepository = orderRepository
        self.keyValueStorage = keyValueStorage
    }

    private var persistedOrderInProgress: Order? {
        if let order = try? orderRepository.fecthUnfinishedOrder() {
            return order
        } else {
            return try? orderRepository.createOrder()
        }
    }

    private func persistedProduct(for product: Product) -> Product {
        if let product = try? productRepository.fecthProduct(for: product.id) {
            return product
        } else {
            try? productRepository.createProduct(from: product)
            return product
        }
    }

    private func persistedOrderItem(for product: Product) -> OrderItem? {
        guard let order = persistedOrderInProgress else {
            return nil
        }
        if let orderItems = try? orderItemRepository.fecthOrderItem(forProductID: product.id, andOrderID: order.id) {
            return orderItems
        } else {
            guard let orderItem = try? orderItemRepository.createOrderItem(fromProduct: product) else {
                return nil
            }
            return orderItem
        }
    }

    private func deleteProductIfNeeded(_ product: Product?) {
        guard let product = product else {
            return
        }
        let orderItems = try? orderItemRepository.fecthOrderItems(forProductID: product.id)
        if orderItems?.isEmpty ?? false {
            try? productRepository.delete(product: product)
        }
    }

    private func removeOrderItem(_ orderItem: OrderItem) {
        guard var order = try? orderRepository.fecthOrder(for: orderItem.id) else {
            return
        }
        order.orderItems?.removeAll { $0.id == orderItem.id }
        try? orderItemRepository.delete(orderItem: orderItem)
        try? orderRepository.save(order: order)
    }
}

extension CartManager: CartManagerProtocol {
    func getCart() -> Order? {
        persistedOrderInProgress
    }

    func sumProductQuantity(product: Product) {
        // Fetch Product from Database, if not exists create a new one
        let product = persistedProduct(for: product)

        // Fetch OrderItem from this Product included on the Order
        guard let orderItem = persistedOrderItem(for: product) else {
            return
        }

        // Add Order Item inside Order, if not added yet
        let  order = try? orderRepository.fecthOrder(for: orderItem.id)
        if order == nil, let orderInProgress = persistedOrderInProgress {
            try? orderRepository.addOrderItem(orderItem, intoOrder: orderInProgress)
        }

        // Increase Order Item quantity by 1
        sumQuantity(from: orderItem)

        // Update Order
        saveCart()
    }

    func sumQuantity(from orderItem: OrderItem) {
        try? orderItemRepository.addQuantity(on: orderItem)
    }

    func reduceQuantity(from orderItem: OrderItem) {
        let quantity = orderItem.quantity
        try? orderItemRepository.removeQuantity(on: orderItem)

        // If there was only 1 before delete, remove Order Item and Product
        if quantity == 1 {
            removeOrderItem(orderItem)
            deleteProductIfNeeded(orderItem.product)
        }
    }

    func getOrderItems(from order: Order?) -> [OrderItem] {
        guard let order = order else {
            return []
        }
        let orderItems = try? orderItemRepository.fecthOrderItems(forOrderID: order.id)
        return orderItems ?? []
    }

    func finishOrder(_ order: Order?) {
        guard var modifiedOrder = order else {
            return
        }
        modifiedOrder.isFinished = true
        try? orderRepository.save(order: modifiedOrder)
    }

    func deleteAll() {
        try? productRepository.deleteAll()
        try? orderItemRepository.deleteAll()
        try? orderRepository.deleteAll()
    }

    func saveCart() {
        guard let cart = persistedOrderInProgress else {
            return
        }
        try? orderRepository.save(order: cart)
    }
}
