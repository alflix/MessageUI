//
//  UIScrollView+Addition.swift
//  GGUI
//
//  Created by John on 2019/7/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIScrollView {
    var autualContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }

    func reloadDataAnyway() {
        if let self = self as? UITableView {
            self.reloadData()
        }
        if let self = self as? UICollectionView {
            self.reloadData()
        }
    }
}
