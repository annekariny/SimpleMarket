//
//  CartPresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol CartPresenterProtocol {
    var title: String { get }
    var numberOfRows: Int { get }
    func getOrderItem(for index: Int) -> OrderItem?
    func sumOrderItemQuantity(_ orderItem: OrderItem?, at index: Int)
    func reduceOrderItemQuantity(_ orderItem: OrderItem?, at index: Int)
    func didTapDone()
    func finishOrder()
    func updateCart()
}

final class CartPresenter {
    private weak var coordinator: CartCoordinatorProtocol?
    weak var view: CartViewProtocol?

    private let logger = Logger()
    private let cartManager: CartManagerProtocol
    private var cart: Order? {
        didSet {
            orderItems = cartManager.getOrderItems()
        }
    }
    private var orderItems = [OrderItem]()

    init(
        coordinator: CartCoordinatorProtocol,
        cartManager: CartManagerProtocol = CartManager()
    ) {
        self.coordinator = coordinator
        self.cartManager = cartManager
    }

    deinit {
        logger.info("CartPresenter deinitialized")
    }
}

// MARK: - CartPresenterProtocol
extension CartPresenter: CartPresenterProtocol {
    var title: String {
        "Cart"
    }

    var numberOfRows: Int {
        orderItems.count
    }

    var totalCart: String {
        "Total: \((cart?.total ?? 0).toCurrencyFormat() ?? "")"
    }

    func getOrderItem(for index: Int) -> OrderItem? {
        guard orderItems.indices.contains(index) else {
            return nil
        }
        return orderItems[index]
    }

    func sumOrderItemQuantity(_ orderItem: OrderItem?, at index: Int) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.sumQuantity(from: orderItem)
        updateCart()
    }

    func reduceOrderItemQuantity(_ orderItem: OrderItem?, at index: Int) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.reduceQuantity(from: orderItem)
        view?.reloadTableView()
        updateCart()
    }

    func updateCart() {
        cart = cartManager.getCart()
        view?.updateTotalCart(total: totalCart)
        view?.reloadTableView()
    }

    func didTapDone() {
        cartManager.saveCart()
        coordinator?.finish()
    }

    func finishOrder() {
        cartManager.finishOrder(cart)
        coordinator?.showFinishOrderAlert()
    }
}
