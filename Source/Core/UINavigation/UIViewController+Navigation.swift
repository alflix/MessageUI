//
//  UIViewController+Navigation.swift
//  GGUI
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public struct NavigationAppearance {
    /// 透明度，通常设置为 0 来隐藏导航栏，设置为 1 不进行隐藏，默认为 1
    public var backgroundAlpha: CGFloat = 1.0
    /// tintColor, 导航栏的背景颜色，不同的背景颜色之间会有渐变的切换效果
    public var tintColor: UIColor = .black
    /// 是否显示导航栏底部的横线，默认显示
    public var showShadowLine: Bool = true

    public init() {}

    public init(backgroundAlpha: CGFloat, tintColor: UIColor, showShadowLine: Bool) {
        self.backgroundAlpha = backgroundAlpha
        self.tintColor = tintColor
        self.showShadowLine = showShadowLine
    }
}

extension UIViewController {
    fileprivate struct AssociatedKey {
        static var appearanceKey: String = "com.ganguo.appearanceKey"
    }

    /// 控制器上的导航栏样式，若不设置，以其 navigationController 的为准
    open var navigationAppearance: NavigationAppearance {
        get {
            if let value = associatedObject(forKey: &AssociatedKey.appearanceKey) as? NavigationAppearance {
                return value
            }
            return GGUI.NavigationBarConfig.appearance
        }
        set {
            navigationController?.navigationBar.tintColor = newValue.tintColor
            navigationController?.navigationBar.setupShadowLine(remove: !newValue.showShadowLine)
            navigationController?.navigationBar.setBackground(alpha: newValue.backgroundAlpha)
            associate(retainObject: newValue, forKey: &AssociatedKey.appearanceKey)
        }
    }
}
