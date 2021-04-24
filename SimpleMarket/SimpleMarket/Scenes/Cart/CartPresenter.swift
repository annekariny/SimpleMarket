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
    func didTapDone()
}

final class CartPresenter: CartPresenterProtocol {
    private weak var coordinator: CartCoordinatorProtocol?
    weak var view: CartViewProtocol?
    private var orderItems = [OrderItem]()

    init(coordinator: CartCoordinatorProtocol) {
        self.coordinator = coordinator
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

    func didTapDone() {
        coordinator?.finish()
    }
}
