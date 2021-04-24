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

    static var circledPlus: UIImage {
        UIImage(systemName: "plus.circle") ?? UIImage()
    }
}
