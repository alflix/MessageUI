//
//  ChatKitError.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

internal enum ChatKitError {
    internal static let avatarPositionUnresolved = "AvatarPosition Horizontal.natural needs to be resolved."
    internal static let nilMessagesDataSource = "MessagesDataSource has not been set."
    internal static let nilMessagesDisplayDelegate = "MessagesDisplayDelegate has not been set."
    internal static let nilMessagesLayoutDelegate = "MessagesLayoutDelegate has not been set."
    internal static let notMessagesCollectionView = "The collectionView is not a MessagesCollectionView."
    internal static let layoutUsedOnForeignType = "MessagesCollectionViewFlowLayout is being used on a foreign type."
    internal static let unrecognizedSectionKind = "Received unrecognized element kind:"
    internal static let unrecognizedCheckingResult = "Received an unrecognized NSTextCheckingResult.CheckingType"
    internal static let couldNotLoadAssetsBundle = "MessageKit: Could not load the assets bundle"
    internal static let couldNotCreateAssetsPath = "MessageKit: Could not create path to the assets bundle."
    internal static let customDataUnresolvedCell = "Did not return a cell for MessageKind.custom(Any)."
    internal static let customDataUnresolvedSize = "Did not return a size for MessageKind.custom(Any)."
}
