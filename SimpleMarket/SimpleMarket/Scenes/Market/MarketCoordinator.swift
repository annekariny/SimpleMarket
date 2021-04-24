//
//  MarketCoordinator.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol MarketCoordinatorProtocol: Coordinator {
}

final class MarketCoordinator: MarketCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let window: UIWindow
    var childCoordinators = [Coordinator]()

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let presenter = MarketPresenter(coordinator: self)
        let viewController = MarketViewController(presenter: presenter)
        presenter.view = viewController
        navigationController.setViewControllers([viewController], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
