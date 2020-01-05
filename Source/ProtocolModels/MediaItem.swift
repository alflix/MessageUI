//
//  MediaItem.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// 图片消息息协议
public protocol MediaItem {
    /// 图片资源 url
    var url: String? { get }
    /// 本地显示图片
    var image: UIImage? { get }
    /// 占位图片
    var placeholderImage: UIImage { get }
    /// 尺寸
    var size: CGSize { get }
    /// 显示尺寸显示相对于屏幕尺寸的缩放比例，以使得图片的显示不至于撑满屏幕
    var maxSizeFactor: (maxWidth: Double, maxHeight: Double) { get }
}
