//
//  MessagesDataSource.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// 每一条消息的数据源配置
public protocol MessagesDataSource: AnyObject {
    /// 当前发送者，会影响 isFromCurrentSender 的默认设置
    func currentSender() -> SenderType

    /// 消息是不是当前发送者
    func isFromCurrentSender(message: MessageType) -> Bool

    /// 每个 `MessageCollectionViewCell 上的消息数据源
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType

    /// sections 数量
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int

    /// row 数量
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int

    /// Cell 上方的文字，eg：时间
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    /// Cell 下方的文字，eg：已读
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    /// 消息上方的文字，eg：昵称
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    /// 消息下方的文字，eg：已发送 / 时间
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    /// 自定义消息 Cell
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell
}

public extension MessagesDataSource {
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == currentSender().senderId
    }

    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        fatalError(MessageKitError.customDataUnresolvedCell)
    }
}
