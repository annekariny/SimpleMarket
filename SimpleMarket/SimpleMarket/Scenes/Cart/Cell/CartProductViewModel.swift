//
//  CartProductViewModel.swift
//  SimpleMarket
//
//  Created by Anne Kariny Silva Freitas on 31/05/21.
//

import Foundation
import UIKit

final class CartProductViewModel {
    private let imageLoader: ImageLoaderProtocol
    private let imageURL: URL?
    let productName: String
    let price: String
    let totalValue: String
    let quantity: String

    init(with orderItem: OrderItem, imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
        imageURL = orderItem.product?.imageURL
        productName = orderItem.product?.description ?? ""
        price = orderItem.product?.price.toCurrencyFormat() ?? ""
        totalValue = orderItem.totalValue.toCurrencyFormat()
        quantity = orderItem.quantity.description
    }

    func loadImage(completion: @escaping ((UIImage?) -> Void)) {
        guard let url = imageURL else {
            completion(nil)
            return
        }
        imageLoader.loadImage(from: url) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
