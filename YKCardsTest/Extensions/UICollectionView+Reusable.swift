//
//  UICollectionView+Reusable.swift
//  YKCardsTest
//
//  Created by Yury Karpenka on 19.11.2023.
//

import UIKit

extension UICollectionView {
    func registerClassCell<T: UICollectionViewCell>(_: T.Type) {
        let identifier = String(describing: type(of: T.self))
        register(T.self, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let identifier = String(describing: type(of: T.self))
        let dequeuedCell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = dequeuedCell as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }

        return cell
    }
}
