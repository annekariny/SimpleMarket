//
//  UICollectionViewCell+Rounded.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import UIKit

extension UICollectionViewCell {
    func setRoundedLayout() {
        layer.cornerRadius = 15.0
        layer.borderWidth = 5.0
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true

        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 5.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 15.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
