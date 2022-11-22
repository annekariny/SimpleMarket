//
//  MockCoordinator.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

import Foundation
@testable import SimpleMarket
import XCTest

final class MockCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    func start() { }
}
