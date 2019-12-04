//
//  SenderType.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// A standard protocol representing a sender.
/// Use this protocol to adhere a object as the sender of a MessageType
public protocol SenderType {
    /// The unique String identifier for the sender.
    ///
    /// Note: This value must be unique across all senders.
    var senderId: String { get }

    /// The display name of a sender.
    var displayName: String { get }
}
