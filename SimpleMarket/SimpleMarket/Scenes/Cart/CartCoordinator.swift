//
//  CartCoordinator.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import UIKit

protocol CartCoordinatorProtocol: Coordinator {
    func showFinishOrderAlert()
    func finish()
}

final class CartCoordinator: CartCoordinatorProtocol {
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
        logger.info("CartCoordinator deinitialized")
    }

    func start() {
        let presenter = CartPresenter(coordinator: self)
        let viewController = CartViewController(presenter: presenter)
        presenter.view = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isModalInPresentation = true
        self.navigationController = navigationController
        parentNavigationController.present(navigationController, animated: true)
    }

    func finish() {
        guard let viewController = parentNavigationController.presentedViewController else {
            return
        }
        finishModal(viewController: viewController, parent: parent, animated: true)
    }

    func showFinishOrderAlert() {
        let title = Strings.finished
        let message = Strings.yourOrderIsSaved
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.ok, style: .default) { [weak self] _ in
            self?.finish()
        }
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: true)
    }
}
