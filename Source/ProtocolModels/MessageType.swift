//
//  MessageType.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import Foundation

/// 消息协议
public protocol MessageType {
    /// 发送者
    var sender: SenderType { get }
    /// 消息 id
    var messageId: String { get }
    /// 发送时间
    var sentDate: Date { get }
    /// 消息
    var kind: MessageKind { get }
}
