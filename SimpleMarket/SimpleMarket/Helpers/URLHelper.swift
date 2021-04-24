//
//  URLHelper.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol URLHelperProtocol {
    func downloadImage(withURL imageURL: URL, completion: @escaping (UIImage?) -> Void)
}

struct URLHelper: URLHelperProtocol {
    func downloadImage(withURL imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        let imageDownloadQueue = DispatchQueue(label: "imageDownload", qos: .userInitiated)
        
        imageDownloadQueue.async {
            do {
                let data = try Data(contentsOf: imageURL)
                
                DispatchQueue.main.sync {
                    completion(UIImage(data: data))
                }
            } catch {
                debugPrint("Error downloading image")
                completion(nil)
            }
        }
    }
}
