//
//  ProductAPIManagerTests.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class ProductAPIManagerTests: XCTestCase {
    private var productRequest: RequestProtocol!
    private var productAPIManager: ProductAPIManagerProtocol!

    override func setUp() {
        super.setUp()
        productRequest = MockProductAPIRequest()
        productAPIManager = ProductAPIManager(request: productRequest)
    }

    override func tearDown() {
        productRequest = nil
        productAPIManager = nil
        super.tearDown()
    }

    func testGetProduct_whenFinishes_returnDecodableProduct() {
        let request = productRequest as? MockProductAPIRequest
        productAPIManager.getProducts { (product, error) in
            XCTAssertEqual(request?.decodableProduct?.id, product.first?.id)
            XCTAssertNil(error)
        }
    }
}
