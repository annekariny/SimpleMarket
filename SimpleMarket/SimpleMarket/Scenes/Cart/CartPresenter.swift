//
//  CartPresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol CartPresenterProtocol: CartCellDelegate {
    var title: String { get }
    var numberOfRows: Int { get }
    func getOrderItem(for index: Int) -> OrderItem?
    func sumOrderItemQuantity(at index: Int)
    func reduceOrderItemQuantity(at index: Int)
    func didTapDone()
    func finishOrder()
    func updateCart()
    func getCartProductViewModel(from index: Int) -> CartProductViewModel?
}

class CartPresenter {
    private weak var coordinator: CartCoordinatorProtocol?
    weak var view: CartViewProtocol?

    private let logger = Logger()
    private let cartManager: CartManagerProtocol
    private var orderItems = [OrderItem]()
    private let imageLoader: ImageLoaderProtocol

    init(
        coordinator: CartCoordinatorProtocol? = nil,
        cartManager: CartManagerProtocol = CartManager(),
        imageLoader: ImageLoaderProtocol = ImageLoader()
    ) {
        self.coordinator = coordinator
        self.cartManager = cartManager
        self.imageLoader = imageLoader
    }

    deinit {
        logger.info("CartPresenter deinitialized")
    }
}

// MARK: - CartPresenterProtocol
extension CartPresenter: CartPresenterProtocol {
    var title: String {
        Strings.cart
    }

    var numberOfRows: Int {
        orderItems.count
    }

    var totalCart: String {
        let cart = cartManager.getCart()
        let value = cart?.total ?? 0
        return "\(Strings.total): \(value.toCurrencyFormat())"
    }

    func getOrderItem(for index: Int) -> OrderItem? {
        guard orderItems.indices.contains(index) else {
            return nil
        }
        return orderItems[index]
    }

    func sumOrderItemQuantity(at index: Int) {
        guard orderItems.indices.contains(index) else {
            return
        }
        let orderItem = orderItems[index]
        cartManager.sumQuantity(from: orderItem)
        updateCart()
    }

    func reduceOrderItemQuantity(at index: Int) {
        guard orderItems.indices.contains(index) else {
            return
        }
        let orderItem = orderItems[index]
        cartManager.reduceQuantity(from: orderItem)
        view?.reloadTableView()
        updateCart()
    }

    func updateCart() {
        orderItems = cartManager.getOrderItems()
        view?.updateTotalCart(total: totalCart)
        view?.reloadTableView()
    }

    func didTapDone() {
        cartManager.saveCart()
        coordinator?.finish()
    }

    func finishOrder() {
        cartManager.finishOrder()
        coordinator?.showFinishOrderAlert()
    }

    func getCartProductViewModel(from index: Int) -> CartProductViewModel? {
        guard orderItems.indices.contains(index) else {
            return nil
        }
        return CartProductViewModel(with: orderItems[index], imageLoader: imageLoader)
    }
}

// MARK: - CartCellDelegate
extension CartPresenter {
    func didTapAdd(at index: Int) {
        sumOrderItemQuantity(at: index)
    }

    func didTapRemove(at index: Int) {
        reduceOrderItemQuantity(at: index)
    }
}
