//
//  UICollectionView+.swift
//  Alamofire
//
//  Created by John on 2019/9/25.
//

import Reusable
import UIKit

public extension UICollectionView {
    final func registerHeaderView<T: UICollectionReusableView>(supplementaryViewType: T.Type)
      where T: Reusable & NibLoadable {
        register(supplementaryViewType: supplementaryViewType.self, ofKind: UICollectionView.elementKindSectionHeader)
    }

    final func registerFooterView<T: UICollectionReusableView>(supplementaryViewType: T.Type)
      where T: Reusable & NibLoadable {
        register(supplementaryViewType: supplementaryViewType.self, ofKind: UICollectionView.elementKindSectionFooter)
    }

    final public func dequeueHeaderView<T: UICollectionReusableView>
        (for indexPath: IndexPath, viewType: T.Type = T.self) -> T
        where T: Reusable {
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                    for: indexPath, viewType: viewType.self)
    }

    final public func dequeueFooterView<T: UICollectionReusableView>
        (for indexPath: IndexPath, viewType: T.Type = T.self) -> T
        where T: Reusable {
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                    for: indexPath, viewType: viewType.self)
    }

    final public func dequeueDefaultHeaderView(for indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                withClass: UICollectionReusableView.self, for: indexPath)
    }

    final public func dequeueDefaultFooterView(for indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                withClass: UICollectionReusableView.self, for: indexPath)
    }
}
