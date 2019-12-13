//
//  MediaItem.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// 图片/视频消息协议
public protocol MediaItem {
    /// 资源 url
    var url: URL? { get }
    /// 本地显示图片
    var image: UIImage? { get }
    /// 占位图片
    var placeholderImage: UIImage { get }
    /// 视频时长秒数
    var durationText: String { get }
    /// 尺寸
    var size: CGSize { get }
    /// 视频播放按钮
    var videoPlayImage: UIImage? { get }
}
