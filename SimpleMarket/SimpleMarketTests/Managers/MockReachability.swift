//
//  MockReachability.swift
//  SimpleMarketTests
//
//  Created by Kariny on 26/04/21.
//

@testable import SimpleMarket

final class MockReachability: ReachabilityProtocol {
    var isConnectedToNetwork = true
}
