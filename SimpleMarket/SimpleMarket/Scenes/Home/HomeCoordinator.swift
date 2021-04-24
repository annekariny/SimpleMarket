//
//  HomeCoordinator.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    
}

final class HomeCoordinator: HomeCoordinatorProtocol {
    var childCoordinators = [Coordinator]()

    private let navigationController: UINavigationController
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
//        let homePresenter = HomePresenter(coordinator: self)
//        let homeViewController = HomeViewController(presenter: homePresenter)
//        homePresenter.view = homeViewController
//        navigationController.setViewControllers([homeViewController], animated: true)
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
    }
}
