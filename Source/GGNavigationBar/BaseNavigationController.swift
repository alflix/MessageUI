//
//  BaseNavigationController.swift
//  GGUI
//
//  Created by John on 2018/10/13.
//  Copyright © 2018年 Ganguo. All rights reserved.
//

import UIKit

open class BaseNavigationController: UINavigationController {
    //是否允许手势返回（对于一些特殊的页面，需要禁止掉手势返回）
    public var enabledPop: Bool = true

    override open func viewDidLoad() {
        super.viewDidLoad()
        // 初始化设置项
        navigationAppearance = self.navigationAppearance
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 && (viewController.navigationItem.leftBarButtonItem == nil) {
            viewController.hidesBottomBarWhenPushed = true
            if let image = GGUI.NavigationBarConfig.backIconImage {
                let backBarButtonItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backAction))
                viewController.navigationItem.leftBarButtonItem = backBarButtonItem
            }
        }
        interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Function
private extension BaseNavigationController {
    @objc func backAction() {
        popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension BaseNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count <= 1 {
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            interactivePopGestureRecognizer?.isEnabled = enabledPop
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return enabledPop
    }
}
