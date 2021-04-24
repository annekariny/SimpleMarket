//
//  ProductAPIManager.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol ProductAPIManagerProtocol {
    func getProducts(completion: @escaping(_ products: [Product], _ error: NetworkError?) -> Void)
}

final class ProductAPIManager: ProductAPIManagerProtocol {
    private let request: RequestProtocol

    init(
        request: RequestProtocol = ProductAPIRequest()
    ) {
        self.request = request
    }

    func getProducts(completion: @escaping ([Product], NetworkError?) -> Void) {
        request.perform(.get, ProductAPI.getProducts) { (result, error) in
            guard let products = result?.items else {
                completion([], error)
                return
            }
            completion(products.map { Product(from: $0) }, error)
        }
    }
}
