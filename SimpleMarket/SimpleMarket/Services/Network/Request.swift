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

final class ProductAPIRequest {
    private let reachability: ReachabilityProtocol
    private var task: URLSessionTask?
    
    init(
        reachability: ReachabilityProtocol = Reachability()
    ) {
        self.reachability = reachability
    }
    
    private func performRequest(request: URLRequest, completion: @escaping (ProductResult?, NetworkError?) -> Void) {
        guard reachability.isConnectedToNetwork else {
            debugPrint("Internet Unavailable")
            return DispatchQueue.main.async {
                completion(nil, .internetUnavailable)
            }
        }
        
        let session = URLSession.shared
        
        task = session.dataTask(with: request, completionHandler: { (data, _, error) in
            guard let responseData = data, error == nil else {
                if let error = error {
                    debugPrint("Unknown Error: \(error.localizedDescription)")
                }
                return DispatchQueue.main.async { completion(nil, .unknownError) }
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(ProductResult.self, from: responseData)
                
                DispatchQueue.main.async {
                    completion(decodedObject, nil)
                }
            } catch {
                debugPrint("Unexpected Data Error: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil, .unexpectedDataError) }
            }
        })
        
        task?.resume()
    }
}

// MARK: - RequestProtocol
extension ProductAPIRequest: RequestProtocol {
    func perform(_ method: HttpMethod, _ endPoint: EndPointType, completion: @escaping (ProductResult?, NetworkError?) -> Void) {
        guard let url = endPoint.url else {
            completion(nil, .invalidURL)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = method.rawValue
        
        performRequest(request: request, completion: completion)
    }
    
    func cancel() {
        task?.cancel()
    }
}
