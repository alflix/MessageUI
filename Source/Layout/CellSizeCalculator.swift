//
//  CellSizeCalculator.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// An object is responsible for
/// sizing and configuring cells for given `IndexPath`s.
open class CellSizeCalculator {
    /// The layout object for which the cell size calculator is used.
    public weak var layout: UICollectionViewFlowLayout?

    /// 准备布局之前，layoutAttributesForElements 会调用该方法，用于调整 UICollectionViewLayoutAttributes
    open func configure(attributes: UICollectionViewLayoutAttributes) {}

    /// Used to size an item at a given `IndexPath`.
    ///
    /// - Parameters:
    /// - indexPath: The `IndexPath` of the item to be displayed.
    /// The default return .zero
    open func sizeForItem(at indexPath: IndexPath) -> CGSize { return .zero }

    public init() {}

}
