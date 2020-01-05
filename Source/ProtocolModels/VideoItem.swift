//
//  VideoItem.swift
//  MessageUI
//
//  Created by John on 2019/12/27.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// 视频消息协议
public protocol VideoItem {
    /// 视频资源 url（local 或 remote）
    var url: URL? { get }
    /// 视频封面 url
    var coverImageUrl: String? { get }
    /// 视频封面图片
    var coverImage: UIImage? { get }
    /// 占位图片
    var placeholderImage: UIImage { get }
    /// 视频时长秒数
    var durationText: String { get }
    /// 尺寸
    var size: CGSize { get }
    /// 视频播放按钮
    var videoPlayImage: UIImage? { get }
}
