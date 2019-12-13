//
//  MessageCollectionViewCell.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// A subclass of `UICollectionViewCell` to be used inside of a `MessagesCollectionView`.
open class MessageCollectionViewCell: UICollectionViewCell {
    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// 处理点击事件
    open func handleTapGesture(_ gesture: UIGestureRecognizer) {
        // Should be overridden
    }
}
