//
//  LocationItem.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit
import class CoreLocation.CLLocation

/// 地理消息协议
public protocol LocationItem {
    /// 地理位置
    var location: CLLocation { get }
    /// 显示尺寸
    var size: CGSize { get }
    /// 一级标题
    var title: String { get }
    /// 二级标题
    var subtitle: String { get }
}
