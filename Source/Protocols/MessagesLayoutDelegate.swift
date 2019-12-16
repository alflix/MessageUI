//
//  MessagesLayoutDelegate.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// headerView，footerView，CellLabel 高度，Size 设置
public protocol MessagesLayoutDelegate: AnyObject {
    /// headerViewSize
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// footerViewSize
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// cellTopLabel 高度
    func cellTopLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// cellBottomLabel 高度
    func cellBottomLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// TopLabel 高度
    func messageTopLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// BottomLabel 高度
    func messageBottomLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// AudioMessageCell 的布局方式
    func audioCellPosition(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AudioPosition

    /// 地理位置的 Cell，其中元素与容器的距离
    func locationCellPadding(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets

    /// 使用自定义 Cell 时，返回自定义的 Cell Size 计算
    func customCellSizeCalculator(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator
}

public extension MessagesLayoutDelegate {
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func cellTopLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func cellBottomLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func messageTopLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func messageBottomLabelHeight(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func audioCellPosition(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AudioPosition {
        return AudioPosition()
    }

    func locationCellPadding(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func customCellSizeCalculator(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        fatalError("Must return a CellSizeCalculator for MessageKind.custom(Any?)")
    }
}
