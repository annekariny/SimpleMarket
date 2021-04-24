//
//  ProductRepository.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol ProductRepositoryProtocol {
    func save(product: Product) -> ProductDB?
}

struct ProductRepository: ProductRepositoryProtocol {
    private let coreDataStack: CoreDataStackProtocol

    init(
        coreDataStack: CoreDataStackProtocol = CoreDataStack()
    ) {
        self.coreDataStack = coreDataStack
    }

    @discardableResult
    func save(product: Product) -> ProductDB? {
        let productDB = ProductDB(context: coreDataStack.context)
        productDB.id = Int64(product.id)
        productDB.price = product.price
        productDB.productDescription = product.description
        productDB.stock = Int64(product.stock ?? 0)
        productDB.offer = product.offer ?? 0
        productDB.imageURLString = product.imageURLString

        coreDataStack.saveContext()
        return productDB
    }
}
