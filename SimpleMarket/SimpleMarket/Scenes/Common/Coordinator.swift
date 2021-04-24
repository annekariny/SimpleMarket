//
//  Coordinator.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func childDidStop(_ child: Coordinator)
}

extension Coordinator {
    func childDidStop(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }

    func start(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func finishModal(viewController: UIViewController, parent: Coordinator?, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: animated) { [weak self, weak parent] in
            guard let self = self else {
                return
            }
            parent?.childDidStop(self)
            completion?()
        }
    }
}
