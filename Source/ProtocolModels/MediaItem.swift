//
//  MediaItem.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// A protocol used to represent the data for a media message.
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
