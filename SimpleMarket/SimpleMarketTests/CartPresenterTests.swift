//
//  CartPresenterTests.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
import RealmSwift
@testable import SimpleMarket
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
final class CartPresenterTests: XCTestCase {
    private var cartManager: CartManagerProtocol!
    private var presenter: CartPresenterProtocol!

    override func setUp() {
        super.setUp()
        cartManager = MockCartManager()
        presenter = CartPresenter(coordinator: nil, cartManager: cartManager)
        presenter.updateCart()
    }

    override func tearDown() {
        cartManager = nil
        presenter = nil
        super.tearDown()
    }
    func testGetOrderItem_forCartIndex_returnsMatchingOrderItem() {
        let cartOrdetItem = cartManager.getOrderItems().first
        let orderItem = presenter.getOrderItem(for: 0)
        XCTAssertEqual(orderItem, cartOrdetItem)
    }

    func testNumberOfRows_macthesOrderItemsCount() {
        let cartOrdetItemCount = cartManager.getOrderItems().count
        let numberOfRows = presenter.numberOfRows
        XCTAssertEqual(numberOfRows, cartOrdetItemCount)
    }

    func testSumOrderItemQuantity_increasesCartOrderItemQuantity() {
        let orderItem = presenter.getOrderItem(for: 0)
        presenter.sumOrderItemQuantity(orderItem, at: 0)

        let cartOrdetItem = cartManager.getOrderItems().first
        XCTAssertEqual(cartOrdetItem?.quantity, 1)
    }

    func testReduceOrderItemQuantity_decreasesCartOrderItemQuantity() {
        let orderItem = presenter.getOrderItem(for: 0)
        presenter.sumOrderItemQuantity(orderItem, at: 0) // Set quantity to 1
        presenter.reduceOrderItemQuantity(orderItem, at: 0) // Set quantity to 0

        let cartOrdetItem = cartManager.getOrderItems().first
        XCTAssertEqual(cartOrdetItem?.quantity, 0)
    }

    func testFinishOrder_createsAnUnfinishedOrder() {
        let cart = cartManager.getCart()
        presenter.finishOrder()

        let newCart = cartManager.getCart()
        XCTAssertNotEqual(cart, newCart)
    }

    func testDeinit_whenPresenterIsNil_isCalled() {
        class CartPresenterUT: CartPresenter {
            var deinitCalled: (() -> Void)?
            deinit { deinitCalled?() }
        }
        let exp = expectation(description: "Deinit is called")
        var presenter: CartPresenterUT? = CartPresenterUT()

        presenter?.deinitCalled = {
            exp.fulfill()
        }
        DispatchQueue.global(qos: .background).async {
            presenter = nil
        }
        waitForExpectations(timeout: 1)
    }
}
