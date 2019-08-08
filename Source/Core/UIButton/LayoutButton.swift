//
//  LayoutButton.swift
//  GGUI
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

/*
 /// - top:

 +-----------+
 |           |
 |  (Image)  |
 |   Text    |
 |           |
 +-----------+

 /// - left:

 +-----------+
 |           |
 |(Image)Text|
 |           |
 +-----------+

 /// - bottom:

 +-----------+
 |           |
 |   Text    |
 |  (Image)  |
 |           |
 +-----------+

 /// - right:

 +-----------+
 |           |
 |Text(Image)|
 |           |
 +-----------+

 */
public enum TitleImageDirection: Int {
    case top = 0, left = 1, bottom = 2, right = 3
}

/// 方便设置图片，文字布局方式的 UIButton
public class LayoutButton: CustomButton {
    /// 图片和文字的间距，默认为8
    @IBInspectable public var imageTitleSpace: CGFloat = 8 {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable public var titleHeight: CGFloat = 12

    public var imageDirection: TitleImageDirection = .left {
        didSet {
            layoutSubviews()
        }
    }

    /// 图片相对文字的位置，默认为左
    @IBInspectable public var imageDirectionInt: Int {
        get {
            return imageDirection.rawValue
        }
        set {
            imageDirection = TitleImageDirection(rawValue: newValue) ?? .top
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    required init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func setup() {
        self.titleLabel?.textAlignment = .center
    }

    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)

        let imageWidth = imageForNormal?.size.width ?? 0
        let imageHeight = imageForNormal?.size.height ?? 0

        //注意，如果 button 的外部约束导致无法显示完整 title （基于默认情况下） 的时候，rect 的 height 会返回 0，这种情况下，需要手动指定 titleHeight
        var rectHeight = rect.height
        if rectHeight == 0 && titleForNormal?.count ?? 0 > 0 {
            rectHeight = titleHeight
        }

        let space = imageWidth > 0 ? imageTitleSpace : 0
        let heightOffset = (contentRect.height - (imageHeight + rectHeight + space))/2
        let widthOffset = (contentRect.width - (imageWidth + rect.width + space))/2

        switch imageDirection {
        case .top:
            return CGRect(x: 0, y: heightOffset + imageHeight + space,
                          width: contentRect.width, height: rectHeight)
        case .left:
            return CGRect(x: widthOffset + imageWidth + space + self.contentEdgeInsets.left, y: (contentRect.height - rectHeight)/2 + self.contentEdgeInsets.top,
                          width: rect.width, height: rectHeight)
        case .bottom:
            return CGRect(x: 0, y: heightOffset,
                          width: contentRect.width, height: rectHeight)
        case .right:
            return CGRect(x: widthOffset + self.contentEdgeInsets.left, y: (contentRect.height - rectHeight)/2 + self.contentEdgeInsets.top,
                          width: rect.width, height: rectHeight)
        }
    }

    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)

        switch imageDirection {
        case .top:
            return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
                          y: titleRect.minY  - imageTitleSpace - rect.height,
                          width: rect.width, height: rect.height)
        case .left:
            return CGRect(x: titleRect.minX - imageTitleSpace  - rect.width,
                          y: (contentRect.height - rect.height)/2 + self.contentEdgeInsets.top,
                          width: rect.width, height: rect.height)
        case .bottom:
            return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
                          y: titleRect.maxY + imageTitleSpace,
                          width: rect.width, height: rect.height)
        case .right:
            return CGRect(x: titleRect.maxX + imageTitleSpace,
                          y: (contentRect.height - rect.height)/2 + self.contentEdgeInsets.top,
                          width: rect.width, height: rect.height)
        }
    }

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        var labelHeight: CGFloat = 0.0
        var labelWidth: CGFloat = 0.0

        if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
            labelHeight = size.height
        }
        if let size = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.contentRect(forBounds: self.bounds).height)) {
            labelWidth = size.width
        }

        if let image = imageForNormal {
            switch imageDirection {
            case .top, .bottom:
                return CGSize(width: max(size.width, image.size.width),
                              height: image.size.height + labelHeight + imageTitleSpace + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom)
            case .left, .right:
                return CGSize(width: image.size.width + labelWidth + imageTitleSpace + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                              height: max(size.height, image.size.height))
            }
        } else {
            switch imageDirection {
            case .top, .bottom:
                return CGSize(width: size.width, height: labelHeight + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom)
            case .left, .right:
                return CGSize(width: labelWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right, height: size.height)
            }
        }
    }
}
