//
//  BubbleStyle.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

public enum BubbleStyle {
    // 圆角
    case roundCorners(CGFloat)
    // 自定义图片
    case image(UIImage)
    // 自定义 View
    case custom((MessageContainerView) -> Void)

    func stretch(_ image: UIImage) -> UIImage {
        let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
        let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}
