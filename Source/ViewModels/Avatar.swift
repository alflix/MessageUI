//
//  Avatar.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// 用于设置 `AvatarView` 的 Model
public struct Avatar {
    /// 图片，如果图片 url 不为空，为 placeholder
    public let image: UIImage?
    /// 图片 url
    public var imageURL: String?
    /// 圆角
    public var radius: CGFloat?

    public init(image: UIImage? = nil, imageURL: String? = nil, radius: CGFloat? = nil) {
        self.image = image
        self.imageURL = imageURL
        self.radius = radius
    }
}
