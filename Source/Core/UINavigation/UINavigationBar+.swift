//
//  UINavigationBar+Addition.swift
//  GGUI
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    /// 改变背景 alpha
    func setBackground(alpha: CGFloat) {
        guard let barBackgroundView = subviews.first else { return }
        let valueForKey = barBackgroundView.value(forKey:)
        if let shadowView = valueForKey("_shadowView") as? UIView {
            shadowView.alpha = alpha
            shadowView.isHidden = alpha == 0
        }
        if isTranslucent {
            /// MARK: 尝试过修改 _backgroundImageView，效果不好，修改 alpha 无效，修改 isHidden 会导致 push/pop 的时候出问题
            if #available(iOS 10.0, *) {
                if let backgroundEffectView = valueForKey("_backgroundEffectView") as? UIView,
                    backgroundImage(for: .default) == nil {
                    backgroundEffectView.alpha = alpha
                    return
                }
            } else {
                if let adaptiveBackdrop = valueForKey("_adaptiveBackdrop") as? UIView,
                    let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                    backdropEffectView.alpha = alpha
                    return
                }
            }
        }
        barBackgroundView.alpha = alpha
    }

    /// 设置分割线
    ///
    /// - Parameter remove: 是否移除
    func setupShadowLine(remove: Bool) {
        if remove {
            removeShadowLine()
        } else {
            addShadowLine()
        }
    }

    /// 去掉分割线
    func removeShadowLine() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }

    /// 使用自定义的分割线，不同的页面需要在 viewWillAppear 调用
    func addShadowLine() {
        setBackgroundImage(nil, for: .default)
        shadowImage = UIImage(color: GGUI.LineView.color, size: CGSize(width: 1, height: 0.5))
    }
}
