//
//  Request.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

protocol EndPointType {
    var url: URL? { get }
    var path: String { get }
}

protocol RequestProtocol {
    func perform(_ method: HttpMethod, _ route: EndPointType, completion: @escaping (ProductResult?, NetworkError?) -> Void)
    func cancel()
}
