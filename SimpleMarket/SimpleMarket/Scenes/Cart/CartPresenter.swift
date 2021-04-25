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
    func sumOrderItemQuantity(_ orderItem: OrderItem?)
    func decreaseOrderItemQuantity(_ orderItem: OrderItem?)
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
        getOrderItems()
    }

    private func getOrderItems() {
        cart = cartManager.orderInProgress()
        orderItems = cartManager.getOrderItems(from: cartManager.orderInProgress())
        view?.reloadTableView()
    }

    var title: String {
        "Cart"
    }

    var numberOfRows: Int {
        orderItems.count
    }

    func getOrderItem(for index: Int) -> OrderItem? {
        guard orderItems.indices.contains(index) else {
            return nil
        }
        return orderItems[index]
    }

    func sumOrderItemQuantity(_ orderItem: OrderItem?) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.sumOrderItemQuantity(orderItem: orderItem)
        getOrderItems()
    }

    func decreaseOrderItemQuantity(_ orderItem: OrderItem?) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.decreaseOrderItemQuantity(orderItem: orderItem)
        getOrderItems()
    }

    func didTapDone() {
        coordinator?.finish()
    }
}
