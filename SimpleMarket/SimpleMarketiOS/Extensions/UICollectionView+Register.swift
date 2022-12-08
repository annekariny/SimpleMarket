//
//  UICollectionView+Register.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

extension UICollectionView {
    // Register cell from class reference
    func register<T: UICollectionViewCell>(_: T.Type) {
        let identifier = String(describing: T.self)
        register(T.self, forCellWithReuseIdentifier: identifier)
    }

    // Dequeue cell from class reference
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Cell indentifier not found for: \(identifier)")
        }

        return cell
    }
}
