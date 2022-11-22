//
//  CartCoordinatorTests.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
@testable import SimpleMarket
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class CartCoordinatorTests: XCTestCase {
    private var cartCoordinator: CartCoordinator!
    private var spyNavigationController: SpyNavigationController!

    override func setUp() {
        super.setUp()
        let parent = MockCoordinator()
        spyNavigationController = SpyNavigationController()
        cartCoordinator = CartCoordinator(navigationController: spyNavigationController, parent: parent)
    }

    override func tearDown() {
        spyNavigationController = nil
        cartCoordinator = nil
        super.tearDown()
    }

    func testPresentCartViewController_whenStartCoodinator() {
        cartCoordinator.start()

        guard let navController = spyNavigationController.spyPresentedViewController as? UINavigationController,
              navController.viewControllers.first as? CartViewController != nil else {
            XCTFail("Presented ViewController is diferent from CartViewController")
            return
        }
    }
}
