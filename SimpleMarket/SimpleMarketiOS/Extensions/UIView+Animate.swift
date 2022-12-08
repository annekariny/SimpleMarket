//
//  UIView+Animate.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import UIKit

extension UIView {
    func animateScalingUpDown(withDuration duration: TimeInterval = 0.3, scale: CGFloat = 0.5) {
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: scale, y: scale)
            }, completion: { [weak self] _ in
                UIView.animate(withDuration: duration) { [weak self] in
                    self?.transform = .identity
                }
            }
        )
    }
}
