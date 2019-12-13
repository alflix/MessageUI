//
//  AccessoryPosition.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import Foundation

/// `AccessoryView` 垂直方向的对齐方式
public enum AccessoryPosition {
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
