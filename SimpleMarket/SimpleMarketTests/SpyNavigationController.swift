//
//  SpyNavigationController.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import UIKit

final class SpyNavigationController: UINavigationController {
    var spyPresentedViewController: UIViewController?

    override var presentedViewController: UIViewController? {
        spyPresentedViewController
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        spyPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        spyPresentedViewController = nil
        super.dismiss(animated: flag, completion: completion)
    }
}
