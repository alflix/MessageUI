//
//  AvatarPosition.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import Foundation

/// 头像的对齐方式
public struct AvatarPosition: Equatable {
    /// 垂直方向的对齐方式
    public enum Vertical {
        /// 顶部对齐 Cell
        case cellTop
        /// 顶部对齐 `messageTopLabel`
        case messageLabelTop
        /// 顶部对齐 `MessageContainerView`
        case messageTop
        /// 居中于 `MessageContainerView`
        case messageCenter
        /// 底部对齐 `MessageContainerView`
        case messageBottom
        /// 底部对齐 `Cell
        case cellBottom
    }

    // 水平方向的对齐方式
    public var vertical: Vertical

    // 垂直方向的对齐方式
    public var horizontal: Horizontal

    public init(horizontal: Horizontal, vertical: Vertical) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public init(vertical: Vertical) {
        self.init(horizontal: .natural, vertical: vertical)
    }
}

public extension AvatarPosition {
    static func == (lhs: AvatarPosition, rhs: AvatarPosition) -> Bool {
        return lhs.vertical == rhs.vertical && lhs.horizontal == rhs.horizontal
    }
}
