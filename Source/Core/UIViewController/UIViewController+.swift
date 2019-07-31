//
//  UIViewController+.swift
//  GGUI
//
//  Created by John on 2018/12/29.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import Foundation

public extension UIViewController {
    /// 获取当前的 controller,这个方法应该尽量少用, 需确保在主线程调用（在 closure 里）
    static var current: UIViewController? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        var tempView: UIView?
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tempView = subview
                break
            }
        }

        if tempView == nil {
            tempView = window.subviews.last
        }

        var nextResponder = tempView?.next
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }

        while next {
            tempView = tempView?.subviews.first
            if tempView == nil {
                return nil
            }
            nextResponder = tempView!.next
        }
        return nextResponder as? UIViewController
    }

    /// 获取当前的 controller (前提是 UITabBarController 是 window.rootViewController )
    static func currentTabBarController() -> UITabBarController? {
        guard let window = UIApplication.shared.windows.first,
            let tabBarController = window.rootViewController as? UITabBarController
            else { return nil }
        return tabBarController
    }
}

public extension UIViewController {
    /// 寻找目标控制器（需要从前往后找，rootViewController 或 navigationController）
    ///
    /// - Parameter name: 控制器名称
    /// - Returns: 控制器
    func findTargerController(byName name: String) -> UIViewController? {
        let targetClass: AnyClass? = NSObject.swiftClassFromString(name)
        var targetViewController: UIViewController?
        children.forEach { (childController) in
            if object_getClass(childController) == targetClass {
                targetViewController = childController
            } else if let presentedController = childController.findPresentedController() {
                targetViewController = presentedController.findTargerController(byName: name)
            }
        }
        return targetViewController
    }

    /// 寻找当前 presented 的控制器
    func findPresentedController() -> UINavigationController? {
        let target = presentedViewController
        if target == nil {
            return nil
        } else if let target = target as? UINavigationController {
            return target
        } else {
            return target!.findPresentedController()
        }
    }
}
