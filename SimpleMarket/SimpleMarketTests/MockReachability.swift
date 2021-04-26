//
//  MockReachability.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

@testable import SimpleMarket

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
final class MockReachability: ReachabilityProtocol {
    var isConnectedToNetwork = true
}
