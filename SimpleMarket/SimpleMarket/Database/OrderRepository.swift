//
//  OrderRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import CoreData
import Foundation

protocol OrderRepositoryProtocol {
    func fetchCartOrder() -> Order?
    func fetchOrders() -> [Order]?
    func save(order: Order)
}

final class OrderRepository: OrderRepositoryProtocol {
    private let orderItemRepository: OrderItemRepositoryProtocol
    private let coreDataStack: CoreDataStackProtocol
    private var keyValueStorage: KeyValueStorageProtocol

    init(
        coreDataStack: CoreDataStackProtocol = CoreDataStack(),
        orderItemRepository: OrderItemRepositoryProtocol = OrderItemRepository(),
        keyValueStorage: KeyValueStorageProtocol = KeyValueStorage()
    ) {
        self.coreDataStack = coreDataStack
        self.orderItemRepository = orderItemRepository
        self.keyValueStorage = keyValueStorage
    }

    private var newOrder: Order {
        let id = keyValueStorage.currentID + 1
        keyValueStorage.currentID = id
        let order = Order(with: id)
        return order
    }

    func fetchCartOrder() -> Order? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderDB")
        fetchRequest.predicate = NSPredicate(format: "isFinished == %@", false)

        do {
            guard let response = try coreDataStack.context.fetch(fetchRequest).first as? OrderDB else {
                return newOrder
            }
            return Order(from: response)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchOrders() -> [Order]? {
        let fetchRequest: NSFetchRequest<OrderDB> = OrderDB.fetchRequest()
        do {
            let result = try coreDataStack.context.fetch(fetchRequest)
            return result.map { Order(from: $0) }
        } catch {
            return nil
        }
    }

    func save(order: Order) {
        let orderDB = OrderDB(context: coreDataStack.context)
        orderDB.id = Int64(order.id)
        orderDB.totalValue = order.totalValue

        if let orderItems = order.orderItems {
            var orderItemsDB = [OrderItemDB]()
            orderItems.forEach { orderItem in
                if let orderItemDB = orderItemRepository.save(orderItem: orderItem) {
                    orderItemsDB.append(orderItemDB)
                }
            }
            orderDB.orderItemsDB = NSSet(array: orderItemsDB)
        }
        coreDataStack.saveContext()
    }
}
