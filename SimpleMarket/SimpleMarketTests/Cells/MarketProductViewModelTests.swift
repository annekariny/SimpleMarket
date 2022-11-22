//
//  MarketProductViewModelTests.swift
//  SimpleMarketTests
//
//  Created by Anne Kariny Silva Freitas on 31/05/21.
//

import Foundation
@testable import SimpleMarket
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class MarketProductViewModelTests: XCTestCase {
    private var imageLoader: ImageLoaderProtocol!

    override func setUp() {
        imageLoader = MockImageLoader()
    }

    override func tearDown() {
        imageLoader = nil
    }

    func testInitializeViewModel_returns_formattedFields() {
        let vm = MarketProductViewModel(with: mockProduct, imageLoader: imageLoader)
        XCTAssertEqual(vm.productName, mockProduct.description)
        XCTAssertEqual(vm.price, mockProduct.price.toCurrencyFormat())
        XCTAssertEqual(vm.imageURL, mockProduct.imageURL)
    }
}

// MARK: - Mocks
extension MarketProductViewModelTests {
    var mockProduct: Product {
        Product(id: 0, price: 1, description: "Water", imageURLString: "url")
    }
}
