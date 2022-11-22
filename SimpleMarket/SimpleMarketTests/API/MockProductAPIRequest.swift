//
//  MockProductAPIRequest.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

@testable import SimpleMarket

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
final class MockProductAPIRequest: RequestProtocol {
    var decodableProduct: DecodableProduct? = DecodableProduct(id: 0, price: 1, image: "img", description: "mock", stock: 1, offer: 1)

    func perform(_ method: HttpMethod, _ route: EndPointType, completion: @escaping (ProductResult?, NetworkError?) -> Void) {
        if let product = decodableProduct {
            completion(ProductResult(items: [product]), nil)
        } else {
            completion(nil, .unexpectedDataError)
        }
    }

    func cancel() { }
}
