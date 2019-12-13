//
//  MessageKind.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import Foundation

/// 消息类型
public enum MessageKind {
    /// 文本
    case text(String)
    /// 富文本
    case attributedText(NSAttributedString)
    /// 图片
    case photo(MediaItem)
    /// 视频
    case video(MediaItem)
    /// 地理位置
    case location(LocationItem)
    /// 音频
    case audio(AudioItem)
    /// 自定义消息
    case custom(Any?)
}
