//
//  UIView+Constraints.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingLeading: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingTrailing: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        centerHorizontal: NSLayoutXAxisAnchor? = nil,
        centerVertical: NSLayoutYAxisAnchor? = nil
    ) {
        let topInset = safeAreaInsets.top
        let bottomInset = safeAreaInsets.bottom

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop + topInset).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom - bottomInset).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let centerVertical = centerVertical {
            centerYAnchor.constraint(equalTo: centerVertical).isActive = true
        }
        if let centerHorizontal = centerHorizontal {
            centerXAnchor.constraint(equalTo: centerHorizontal).isActive = true
        }
    }
}
