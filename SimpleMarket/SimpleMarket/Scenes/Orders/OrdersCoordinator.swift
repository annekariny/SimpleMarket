//
//  OrdersCoordinator.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import Foundation
import UIKit

protocol OrdersCoordinatorProtocol: Coordinator {
    func finish()
}

final class OrdersCoordinator: OrdersCoordinatorProtocol {
    var childCoordinators = [Coordinator]()
    private weak var parent: Coordinator?
    private let parentNavigationController: UINavigationController
    private var navigationController: UINavigationController?
    private let logger = Logger()

    init(navigationController: UINavigationController, parent: Coordinator) {
        self.parentNavigationController = navigationController
        self.parent = parent
    }

    deinit {
        logger.info("OrdersCoordinator deinitialized")
    }

    func start() {
        let presenter = OrdersPresenter(coordinator: self)
        let viewController = OrdersViewController(presenter: presenter)
        presenter.view = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        parentNavigationController.present(navigationController, animated: true)
    }

    func finish() {
        guard let viewController = parentNavigationController.presentedViewController else {
            return
        }
        finishModal(viewController: viewController, parent: parent, animated: true)
    }
}
