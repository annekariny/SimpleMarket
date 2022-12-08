//
//  UICollectionViewCell+Rounded.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import UIKit

extension UICollectionViewCell {
    func setRoundedLayout() {
        contentView.layer.cornerRadius = 15.0
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 15.0
        layer.masksToBounds = false
    }
}
