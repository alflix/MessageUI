//
//  GGNavigationController.swift
//  GGUI
//
//  Created by John on 2018/10/13.
//  Copyright © 2018年 Ganguo. All rights reserved.
//

import UIKit

open class GGNavigationController: UINavigationController {
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
                let backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backAction))
                viewController.navigationItem.leftBarButtonItem = backBarButtonItem
            }
        }
        interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Function
private extension GGNavigationController {
    @objc func backAction() {
        popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension GGNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1 ? enabledPop : false
    }
}

// MARK: - UIGestureRecognizerDelegate
extension GGNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return enabledPop
    }

    // https://stackoverflow.com/questions/30408581/how-to-use-the-system-pop-gesture-in-a-uiscrollview
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
    }
}
