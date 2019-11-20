//
//  MessageKind.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

/// An enum representing the kind of message and its underlying kind.
public enum MessageKind {

    /// A standard text message.
    ///
    /// - Note: The font used for this message will be the value of the
    /// `messageLabelFont` property in the `ChatCollectionViewFlowLayout` object.
    ///
    /// Using `MessageKind.attributedText(NSAttributedString)` doesn't require you
    /// to set this property and results in higher performance.
    case text(String)

    /// A message with attributed text.
    case attributedText(NSAttributedString)

    /// A photo message.
    case photo(MediaItem)

    /// A video message.
    case video(MediaItem)

    /// A location message.
    case location(LocationItem)

    /// An emoji message.
    case emoji(String)

    /// An audio message.
    case audio(AudioItem)

    /// A custom message.
    /// - Note: Using this case requires that you implement the following methods and handle this case:
    ///   - MessagesDataSource: customCell(for message: MessageType, at indexPath: IndexPath, in ChatCollectionView: ChatCollectionView) -> UICollectionViewCell
    ///   - MessagesLayoutDelegate: customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in ChatCollectionView: ChatCollectionView) -> CellSizeCalculator
    case custom(Any?)
}


