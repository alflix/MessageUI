//
//  MessageKind.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// An enum representing the kind of message and its underlying kind.
public enum MessageKind {
    /// A standard text message.
    case text(String)

    /// A message with attributed text.
    case attributedText(NSAttributedString)

    /// A photo message.
    case photo(MediaItem)

    /// A video message.
    case video(MediaItem)

    /// A location message.
    case location(LocationItem)

    /// An audio message.
    case audio(AudioItem)

    /// A custom message.
    /// - Note: Using this case requires that you implement the following methods and handle this case:
    ///   - MessagesDataSource: customCell(for message: MessageType, at indexPath: IndexPath,
    ///   in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell
    ///   - MessagesLayoutDelegate: customCellSizeCalculator(for message: MessageType,
    ///    at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator
    case custom(Any?)
}
