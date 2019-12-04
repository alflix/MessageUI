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
    /// The url where the media is located.
    var url: URL? { get }
    /// The image.
    var image: UIImage? { get }
    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }
    /// The size of the media item.
    var size: CGSize { get }
    /// 视频播放按钮
    var videoPlayImage: UIImage? { get }
}
