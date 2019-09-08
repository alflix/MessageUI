//
//  RefreshUtil.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

struct PullToRefreshKitConst {
    //KVO
    static let KPathOffSet = "contentOffset"
    static let KPathPanState = "state"
    static let KPathContentSize = "contentSize"

    //Default const
    static let defaultHeaderHeight: CGFloat = 50.0
    static let defaultFooterHeight: CGFloat = 44.0
    static let defaultLeftWidth: CGFloat    = 50.0
    static let defaultRightWidth: CGFloat   = 50.0

    //Tags
    static let headerTag = 100001
    static let footerTag = 100002
    static let leftTag   = 100003
    static let rightTag  = 100004
}

struct PullToRefreshKitHeaderString {
    static let pullDownToRefresh = "pullDownToRefresh".bundleLocalize
    static let releaseToRefresh = "releaseToRefresh".bundleLocalize
    static let refreshSuccess = "refreshSuccess".bundleLocalize
    static let refreshFailure = "refreshFailure".bundleLocalize
    static let refreshing = "refreshing".bundleLocalize
}

struct PullToRefreshKitFooterString {
    static let pullUpToRefresh = "pullUpToRefresh".bundleLocalize
    static let refreshing = "refreshing".bundleLocalize
    static let noMoreData = "noMoreData".bundleLocalize
    static let tapToRefresh = "tapToRefresh".bundleLocalize
    static let scrollAndTapToRefresh = "scrollAndTapToRefresh".bundleLocalize
}

struct PullToRefreshKitLeftString {
    static let scrollToClose = "滑动结束浏览"
    static let releaseToClose = "松开结束浏览"
}

struct PullToRefreshKitRightString {
    static let scrollToViewMore = "滑动浏览更多"
    static let releaseToViewMore = "滑动浏览更多"
}
