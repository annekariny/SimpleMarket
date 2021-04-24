//
//  ProductEndpoint.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

enum ProductAPI {
    case getProducts
}

extension ProductAPI: EndPointType {
    private static let address = "https://run.mocky.io/v3/29c9fcde-549f-49fc-9021-a85660530cef"
    
    var path: String {
        return ProductAPI.address
    }
    
    var url: URL? {
        return URL(string: path)
    }
}
