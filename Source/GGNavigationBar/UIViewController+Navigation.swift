//
//  UIViewController+Navigation.swift
//  GGUI
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public struct NavigationAppearance {
    /// 是否隐藏导航栏，默认不隐藏，如果 true，下面的所有属性都不起作用
    public var isNavigationBarHidden = false
    /// 背景透明度，可实现渐变效果，切换效果
    public var backgroundAlpha: CGFloat = 1.0
    /// 背景颜色，不同的背景颜色之间会有渐变的切换效果, 默认为 white
    public var barTintColor: UIColor = .white
    /// 按钮控件的颜色，不同的颜色之间会有渐变的切换效果, 默认为 black
    public var tintColor: UIColor = .black
    /// 标题颜色，默认为 black
    public var titleColor: UIColor = .black
    /// 标题字体，默认 16，medium
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    /// 是否显示导航栏底部的横线，默认显示
    public var showShadowLine: Bool = true

    public init() {}

    public init(isNavigationBarHidden: Bool,
                backgroundAlpha: CGFloat,
                barTintColor: UIColor,
                tintColor: UIColor,
                titleColor: UIColor,
                titleFont: UIFont,
                showShadowLine: Bool) {
        self.isNavigationBarHidden = isNavigationBarHidden
        self.backgroundAlpha = backgroundAlpha
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        self.titleColor = titleColor
        self.titleFont = titleFont
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
            if newValue.isNavigationBarHidden {
                associate(retainObject: newValue, forKey: &AssociatedKey.appearanceKey)
                return
            }
            if let viewController = self as? UINavigationController {
                viewController.navigationBar.barTintColor = newValue.barTintColor
                viewController.navigationBar.tintColor = newValue.tintColor
                viewController.navigationBar.setTitle(color: newValue.titleColor, font: newValue.titleFont)
                viewController.navigationBar.setBackground(alpha: newValue.backgroundAlpha)
                viewController.navigationBar.setupShadowLine(remove: !newValue.showShadowLine)
            } else if let navigationController = navigationController {
                navigationController.navigationBar.barTintColor = newValue.barTintColor
                navigationController.navigationBar.tintColor = newValue.tintColor
                navigationController.navigationBar.setTitle(color: newValue.titleColor, font: newValue.titleFont)
                navigationController.navigationBar.setBackground(alpha: newValue.backgroundAlpha)
                navigationController.navigationBar.setupShadowLine(remove: !newValue.showShadowLine)
            }
            if !(navigationController?.navigationBar.isTranslucent ?? true) && newValue.backgroundAlpha <= 1 {
                print("⚠️ warning: backgroundAlpha would not available when isTranslucent is false")
            }
            associate(retainObject: newValue, forKey: &AssociatedKey.appearanceKey)
        }
    }
}
