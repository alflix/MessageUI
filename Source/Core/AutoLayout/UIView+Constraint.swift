//
//  UIView+Constraint.swift
//  GGUI
//
//  Created by John on 2019/4/24.
//

import UIKit

public extension UIView {
    /// view 的宽度 Constraint （如果有设置的话）
    var widthConstraint: NSLayoutConstraint? {
        for layout in constraints {
            if layout.firstAttribute == .width && layout.secondItem == nil && layout.relation == .equal && layout.priority == .required {
                return layout
            }
        }
        return nil
    }

    /// view 的高度 Constraint （如果有设置的话）
    var heightConstraint: NSLayoutConstraint? {
        for layout in constraints {
            if layout.firstAttribute == .height && layout.secondItem == nil && layout.relation == .equal && layout.priority == .required {
                return layout
            }
        }
        return nil
    }
}
