//
//  OrdersPresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import Foundation

protocol OrdersPresenterProtocol {
    var title: String { get }
    var numberOfRows: Int { get }
    func getOrder(at index: Int) -> Order?
    func fetchOrders()
    func didTapDone()
}

final class OrdersPresenter {
    private let orderRepository: OrderRepositoryProtocol
    private weak var coordinator: OrdersCoordinatorProtocol?
    weak var view: OrdersViewProtocol?
    private let logger = Logger()
    private var orders: [Order] = []

    init(
        coordinator: OrdersCoordinatorProtocol? = nil,
        orderRepository: OrderRepositoryProtocol = OrderRepository()
    ) {
        self.coordinator = coordinator
        self.orderRepository = orderRepository
    }

    deinit {
        logger.info("OrdersPresenter deinitialized")
    }
}

// MARK: - CartPresenterProtocol
extension OrdersPresenter: OrdersPresenterProtocol {
    var title: String {
        "Orders"
    }

    var numberOfRows: Int {
        orders.count
    }

    func getOrder(at index: Int) -> Order? {
        guard orders.indices.contains(index) else {
            return nil
        }
        return orders[index]
    }

    func fetchOrders() {
        do {
            orders = try orderRepository.fetchFinishedOrders()
            view?.reloadTableView()
        } catch {
            logger.error("Error: ", error.localizedDescription)
        }
    }

    func didTapDone() {
        coordinator?.finish()
    }
}
