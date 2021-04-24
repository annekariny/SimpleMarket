//
//  Reachability.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation
import SystemConfiguration

protocol ReachabilityProtocol {
    var isConnectedToNetwork: Bool { get }
}

struct Reachability: ReachabilityProtocol {
    var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
          $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
          }
        }) else {
          return false
        }

        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return isReachable && !needsConnection
    }
}
