//
//  SenderType.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import Foundation

/// 用户协议
public protocol SenderType {
    /// 发送者 id
    var senderId: String { get }
    /// 发送者名称
    var displayName: String { get }
    /// 发送者头像链接
    var avatarURL: String { get }
}
