//
//  UITabBar+.swift
//  GGUI
//
//  Created by John on 2019/3/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UITabBar {
    fileprivate struct AssociatedKey {
        static var unselectedTintColor: String = "com.ganguo.tabBar.unselectedTintColor"
    }

    /// 未选中状态的控件颜色，拓展以用以适配 iOS10 以下
    var unselectedTintColor: UIColor? {
        get {
            if #available(iOS 10.0, *) {
                return unselectedItemTintColor
            }
            if let value = associatedObject(forKey: &AssociatedKey.unselectedTintColor) as? UIColor { return  value}
            return tintColor
        }
        set {
            if #available(iOS 10.0, *) {
                unselectedItemTintColor = unselectedTintColor
            }
            associate(retainObject: newValue, forKey: &AssociatedKey.unselectedTintColor)
        }
    }

    /// 移除顶部的分割线
    func removeShadowLine() {
        if #available(iOS 13, *) {
            standardAppearance.shadowColor = .white
        } else {
            backgroundImage = UIImage()
            shadowImage = UIImage()
        }
    }

    /// 设置标题文字颜色，字体
    func setupTitle(color: UIColor, font: UIFont) {
        let attributed = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: font]
        UITabBarItem.appearance().setTitleTextAttributes(attributed, for: .normal)
    }
}
