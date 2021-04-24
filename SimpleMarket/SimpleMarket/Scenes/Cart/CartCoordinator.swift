//
//  CartCoordinator.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import UIKit

protocol CartCoordinatorProtocol: Coordinator {
    func finish()
}

final class CartCoordinator: CartCoordinatorProtocol {
    var childCoordinators = [Coordinator]()
    private weak var parent: Coordinator?
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController, parent: Coordinator) {
        self.navigationController = navigationController
        self.parent = parent
    }

    func start() {
        let presenter = CartPresenter(coordinator: self)
        let viewController = CartViewController(presenter: presenter)
        presenter.view = viewController
        let newEspenseNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(newEspenseNavigationController, animated: true)
    }

    func finish() {
        guard let viewController = navigationController.presentedViewController else {
            return
        }
        finishModal(viewController: viewController, parent: parent, animated: true)
    }
}
