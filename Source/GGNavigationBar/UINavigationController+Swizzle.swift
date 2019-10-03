//
//  UINavigationController+Swizzle.swift
//  GGUI
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UINavigationController {
    static func swizzle() {
        DispatchQueue.once {
            swizzling(
                UINavigationController.self,
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(UINavigationController.swizzle_updateInteractiveTransition(_:)))
            swizzling(
                UINavigationController.self,
                #selector(UINavigationController.pushViewController(_:animated:)),
                #selector(UINavigationController.swizzle_pushViewController(_:animated:)))
            swizzling(
                UINavigationController.self,
                #selector(UINavigationController.popToViewController(_:animated:)),
                #selector(UINavigationController.swizzle_popToViewController(_:animated:)))
            swizzling(
                UINavigationController.self,
                #selector(UINavigationController.popToRootViewController(animated:)),
                #selector(UINavigationController.popToRootViewController(animated:)))
        }
    }

    @objc private func swizzle_updateInteractiveTransition(_ percentComplete: CGFloat) {
        guard let topVC = topViewController,
            let coordinator = topVC.transitionCoordinator,
            !topVC.navigationAppearance.isNavigationBarHidden else {
            swizzle_updateInteractiveTransition(percentComplete)
            return
        }
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(from: fromVC, to: toVC, progress: percentComplete)
        swizzle_updateInteractiveTransition(percentComplete)
    }

    @objc private func swizzle_pushViewController(_ viewController: UIViewController, animated: Bool) {
        let block: ViewWillAppearBlock = { [weak self] (viewController, animated) in
            guard let strongSelf = self else { return }
            strongSelf.setNavigationBarHidden(viewController.navigationAppearance.isNavigationBarHidden, animated: animated)

            // MARK: iOS 13 不触发 UINavigationBarDelegate 中的 shouldPopItem 方法了
            if #available(iOS 13, *) {
                strongSelf.navigationBar.barTintColor = viewController.navigationAppearance.barTintColor
                strongSelf.navigationBar.tintColor = viewController.navigationAppearance.tintColor
                strongSelf.navigationBar.setTitle(color: viewController.navigationAppearance.titleColor, font: viewController.navigationAppearance.titleFont)
                strongSelf.navigationBar.setBackground(alpha: viewController.navigationAppearance.backgroundAlpha)
                strongSelf.navigationBar.setupShadowLine(remove: !viewController.navigationAppearance.showShadowLine)
            }
        }
        viewController.viewWillAppearHandler = block

        // Setup will appear inject block to appearing view controller.
        // Setup disappearing view controller as well, because not every view controller is added into
        // stack by pushing, maybe by "-setViewControllers:".
        if let disappearingViewController = viewControllers.last, disappearingViewController.viewWillAppearHandler == nil {
            disappearingViewController.viewWillAppearHandler = block
        }

        pushTransaction {
            swizzle_pushViewController(viewController, animated: animated)
        }
    }

    @objc private func swizzle_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return popsTransaction {
            swizzle_popToViewController(viewController, animated: animated)
        }
    }

    @objc private func swizzle_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        return popsTransaction {
            swizzle_popToRootViewControllerAnimated(animated)
        }
    }

    @objc private func pushTransaction(block: () -> Void) {
        var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(animationDisplay))
        // UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
        displayLink?.add(to: .main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            AnimationProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(AnimationProperties.duration)
        CATransaction.begin()
        block()
        CATransaction.commit()
    }

    @objc private func popsTransaction(block: () -> [UIViewController]?) -> [UIViewController]? {
        var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(animationDisplay))
        displayLink?.add(to: .main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            AnimationProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(AnimationProperties.duration)
        CATransaction.begin()
        let viewControllers = block()
        CATransaction.commit()
        return viewControllers
    }

    private struct AnimationProperties {
        static let duration = 0.13
        static var displayCount = 0
        static var progress: CGFloat {
            let all: CGFloat = CGFloat(60.0 * duration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
}

// MARK: - UI Update
extension UINavigationController {
    @objc private func animationDisplay() {
        guard let topVC = topViewController, let coordinator = topVC.transitionCoordinator else { return }
        AnimationProperties.displayCount += 1
        let progress = AnimationProperties.progress
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(from: fromVC, to: toVC, progress: progress)
    }

    private func updateNavigationBar(from fromVC: UIViewController?, to toVC: UIViewController?, progress: CGFloat) {
        guard let fromVC = fromVC, let toVC = toVC else { return }
        // change barTintColor
        let fromColor = fromVC.navigationAppearance.barTintColor
        let toColor = toVC.navigationAppearance.barTintColor
        let newColor = UIColor.averageColor(from: fromColor, to: toColor, percent: progress)
        navigationBar.barTintColor = newColor

        // change tintColor
        let fromTintColor = fromVC.navigationAppearance.tintColor
        let toTintColor = toVC.navigationAppearance.tintColor
        let newTintColor = UIColor.averageColor(from: fromTintColor, to: toTintColor, percent: progress)
        navigationBar.tintColor = newTintColor

        // change titleColor, titleFont
        let fromTitleColor = fromVC.navigationAppearance.titleColor
        let toTitleColor = toVC.navigationAppearance.titleColor
        let newTitleColor = UIColor.averageColor(from: fromTitleColor, to: toTitleColor, percent: progress)
        let fromTitleFont = fromVC.navigationAppearance.titleFont
        let toTitleFont = toVC.navigationAppearance.titleFont
        let newFontSize = fromTitleFont.pointSize + (toTitleFont.pointSize - fromTitleFont.pointSize) * progress
        let newFont = UIFont.systemFont(ofSize: newFontSize, weight: toVC.navigationAppearance.titleFont.fontWeight)
        navigationBar.setTitle(color: newTitleColor, font: newFont)

        // change alpha
        let fromAlpha = fromVC.navigationAppearance.backgroundAlpha
        let toAlpha = toVC.navigationAppearance.backgroundAlpha
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        navigationBar.setBackground(alpha: newAlpha)

        // update shadow line        
        navigationBar.setupShadowLine(remove: !toVC.navigationAppearance.showShadowLine)
    }

    /// 处理手势进行到一半又停止的情况
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        let animations: (UITransitionContextViewControllerKey) -> Void = {
            guard let viewController = context.viewController(forKey: $0) else { return }
            let curAlpha = viewController.navigationAppearance.backgroundAlpha
            let curBarTintColor = viewController.navigationAppearance.barTintColor
            let curTintColor = viewController.navigationAppearance.tintColor
            let curTitleColor = viewController.navigationAppearance.titleColor
            let curTitleFont = viewController.navigationAppearance.titleFont
            let showShadowLine = viewController.navigationAppearance.showShadowLine

            self.navigationBar.barTintColor = curBarTintColor
            self.navigationBar.tintColor = curTintColor
            self.navigationBar.setTitle(color: curTitleColor, font: curTitleFont)
            self.navigationBar.setBackground(alpha: curAlpha)
            self.navigationBar.setupShadowLine(remove: !showShadowLine)
        }

        // 完成返回手势的取消事件
        if context.isCancelled {
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            // 完成返回手势的完成事件
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}

extension UINavigationController: UINavigationBarDelegate {
    // MARK: 如果 topVC setNavigationBarHidden(true), UINavigationBar 不显示，该方法不会触发
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        // MARK：通过手势返回
        if let topVC = topViewController, let coordinator = topVC.transitionCoordinator, coordinator.initiallyInteractive {
            if #available(iOS 10.0, *) {
                coordinator.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coordinator.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            return true
        }
        // MARK: == nil
        let itemCount = navigationBar.items?.count ?? 0
        let count = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - count]
        popToViewController(popToVC, animated: true)
        return true
    }
}
