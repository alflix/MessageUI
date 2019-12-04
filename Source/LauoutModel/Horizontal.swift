//
//  Horizontal.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// 水平方向的左右边距
public struct HorizontalEdgeInsets: Equatable {
    public var left: CGFloat
    public var right: CGFloat

    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }

    public static var zero: HorizontalEdgeInsets {
        return HorizontalEdgeInsets(left: 0, right: 0)
    }
}

public extension HorizontalEdgeInsets {
    static func == (lhs: HorizontalEdgeInsets, rhs: HorizontalEdgeInsets) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right
    }
}

extension HorizontalEdgeInsets {
    var horizontal: CGFloat {
        return left + right
    }
}

/// 水平方向的对齐方式
public enum Horizontal {
    /// 靠近左边缘
    case cellLeading
    /// 靠近右边缘
    case cellTrailing
    /// 自然，取决于是否当前发送者
    case natural
}
