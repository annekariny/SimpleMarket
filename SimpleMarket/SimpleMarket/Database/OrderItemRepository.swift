//
//  OrderItemRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import CoreData
import Foundation

protocol OrderItemRepositoryProtocol {
    func fetchOrderItems(from order: Order) -> [OrderItem]?
    func save(orderItem: OrderItem) -> OrderItemDB?
}

struct OrderItemRepository: OrderItemRepositoryProtocol {
    private let coreDataStack: CoreDataStackProtocol
    private let productRepository: ProductRepository

    init(
        coreDataStack: CoreDataStackProtocol = CoreDataStack(),
        productRepository: ProductRepository = ProductRepository()
    ) {
        self.coreDataStack = coreDataStack
        self.productRepository = productRepository
    }

    func fetchOrderItems(from order: Order) -> [OrderItem]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderItemDB")
        fetchRequest.predicate = NSPredicate(format: "orderDB.id == %d", order.id)

        do {
            let response = try coreDataStack.context.fetch(fetchRequest)
            return response.map { OrderItem(from: $0 as? OrderItemDB) }
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }

    @discardableResult
    func save(orderItem: OrderItem) -> OrderItemDB? {
        let orderItemDB = OrderItemDB(context: coreDataStack.context)
        orderItemDB.id = Int64(orderItem.id)
        orderItemDB.totalValue = orderItem.totalValue
        orderItemDB.quantity = Int16(orderItem.quantity)
        if let product = orderItem.product {
            orderItemDB.productDB = productRepository.save(product: product)
        }
        coreDataStack.saveContext()
        return orderItemDB
    }
}
