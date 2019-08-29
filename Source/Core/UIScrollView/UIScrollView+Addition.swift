//
//  UIScrollView+Addition.swift
//  GGUI
//
//  Created by John on 2019/7/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIScrollView {
    public var autualContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }
}
