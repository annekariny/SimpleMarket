//
//  Images.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

enum Image {
    static var cart: UIImage {
        UIImage(systemName: "cart") ?? UIImage()
    }

    static var bulletList: UIImage {
        UIImage(systemName: "list.bullet") ?? UIImage()
    }

    static func circledPlus(size: CGFloat) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: .light)
        return UIImage(systemName: "plus.circle", withConfiguration: configuration) ?? UIImage()
    }

    static func circledMinus(size: CGFloat) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: .light)
        return UIImage(systemName: "minus.circle", withConfiguration: configuration) ?? UIImage()
    }
}
