//
//  UIViewController+Swizzle.swift
//  GGUI
//
//  Created by John on 2019/8/16.
//  Copyright © 2019年 Ganguo. All rights reserved.
//

import UIKit

public typealias ViewWillAppearBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void

public extension UIViewController {
    static func swizzleViewWillAppear() {
        DispatchQueue.once {
            swizzling(
                UIViewController.self,
                #selector(UIViewController.viewWillAppear(_:)),
                #selector(UIViewController.swizzle_viewWillAppear(_:)))
            swizzling(
                UIViewController.self,
                #selector(UIViewController.addChild(_:)),
                #selector(UIViewController.swizzle_addChild(_:)))
        }
    }
    
    fileprivate struct AssociatedKey {
        static var viewWillAppearHandlerWrapper: String = "com.ganguo.viewWillAppear"
    }
    
    var viewWillAppearHandler: ViewWillAppearBlock? {
        get {
            if let block = associatedObject(forKey: &AssociatedKey.viewWillAppearHandlerWrapper) as? ViewWillAppearBlock {
                return block
            }
            return nil
        }
        set {
            associate(copyObject: newValue, forKey: &AssociatedKey.viewWillAppearHandlerWrapper)
        }
    }
    
    @objc private func swizzle_viewWillAppear(_ animated: Bool) {
        swizzle_viewWillAppear(animated)
        if let viewWillAppearHandler = viewWillAppearHandler {
            DPrint("swizzle_viewWillAppear")
            viewWillAppearHandler(self, animated)
        }
    }
    
    @objc private func swizzle_addChild(_ childController: UIViewController) {
        swizzle_addChild(childController)
        DPrint("swizzle_addChild")
        let block: ViewWillAppearBlock = { [weak self] (viewController, animated) in
            guard let strongSelf = self, let parent = viewController.parent else { return }
            strongSelf.navigationController?.setNavigationBarHidden(parent.navigationAppearance.isNavigationBarHidden, animated: animated)
        }
        childController.viewWillAppearHandler = block
    }
}
