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
    func decreaseOrderItemQuantity(_ orderItem: OrderItem?, at index: Int)
    func getOrderItems()
    func didTapDone()
}

final class CartPresenter: CartPresenterProtocol {
    private weak var coordinator: CartCoordinatorProtocol?
    private let cartManager = CartManager()
    weak var view: CartViewProtocol?
    private var cart: Order?
    private var orderItems = [OrderItem]()

    init(coordinator: CartCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func getOrderItems() {
        cart = cartManager.orderInProgress()
        orderItems = cartManager.getOrderItems(from: cartManager.orderInProgress())
        view?.updateTotal(total: totalCart)
        view?.reloadTableView()
    }

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
        cartManager.sumOrderItemQuantity(orderItem: orderItem)
        getOrderItems()
        view?.reloadRow(at: index)
    }

    func decreaseOrderItemQuantity(_ orderItem: OrderItem?, at index: Int) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.decreaseOrderItemQuantity(orderItem: orderItem)
        getOrderItems()
        view?.reloadTableView()
    }

    func didTapDone() {
        coordinator?.finish()
    }
}
