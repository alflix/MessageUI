//
//  MessageType.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// A standard protocol representing a message.
/// Use this protocol to create your own message object to be used by MessageKit.
public protocol MessageType {
    /// The sender of the message.
    var sender: SenderType { get }

    /// The unique identifier for the message.
    var messageId: String { get }

    /// The date the message was sent.
    var sentDate: Date { get }

    /// The kind of message and its underlying kind.
    var kind: MessageKind { get }
}
