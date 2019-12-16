//
//  AudioPosition.swift
//  MessageUI
//
//  Created by John on 2019/12/3.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

public struct AudioPosition: Equatable {
    /// 播放按钮布局
    public struct PlayButtonPosition: Equatable {
        /// 垂直方向的 Offset，默认 0 ，即 CenterY 居中
        public var verticalOffset: CGFloat
        /// 水平方向的布局方式
        public var horizontal: Horizontal
        /// 距离左边或右边的间距
        public var leadingTrailingPadding: CGFloat

        public init(verticalOffset: CGFloat, horizontal: Horizontal, leadingTrailingPadding: CGFloat) {
            self.verticalOffset = verticalOffset
            self.horizontal = horizontal
            self.leadingTrailingPadding = leadingTrailingPadding
        }
    }

    /// 播放进度文字布局
    public struct DurationLabelPosition: Equatable {
        /// 垂直方向的 Offset，默认 0 ，即 CenterY 居中
        public var verticalOffset: CGFloat
        /// 水平方向的布局方式
        public var horizontal: Horizontal
        /// 距离左边或右边的间距
        public var leadingTrailingPadding: CGFloat

        public init(verticalOffset: CGFloat, horizontal: Horizontal, leadingTrailingPadding: CGFloat) {
            self.verticalOffset = verticalOffset
            self.horizontal = horizontal
            self.leadingTrailingPadding = leadingTrailingPadding
        }
    }

    /// ProgressView 布局
    public struct ProgressViewPosition: Equatable {
        /// 垂直方向的 Offset，> 5 往下偏移 默认 0 ，即 CenterY 居中
        public var verticalOffset: CGFloat
        /// 水平方向对齐方式
        public var horizontal: ProgressViewHorizontal
        /// 高度，UIProgressView 无法调整高度，暂时不生效
        public var height: CGFloat
        /// 左右边距
        public var horizontalEdgeInsets: HorizontalEdgeInsets

        public init(verticalOffset: CGFloat, horizontal: ProgressViewHorizontal, height: CGFloat, horizontalEdgeInsets: HorizontalEdgeInsets) {
            self.verticalOffset = verticalOffset
            self.horizontal = horizontal
            self.height = height
            self.horizontalEdgeInsets = horizontalEdgeInsets
        }
    }

    public enum ProgressViewHorizontal {
        /// 在左边 View 和 右边 View 之间
        case edgeToLeftAndRightView
        /// 在父 View 之间
        case edgeToSuperView
        /// 在左边 View 和 父 View 之间
        case edgeToLeftView
        /// 在父 View 和右边 View 之间
        case edgeToRightView
    }

    public var playButtonPosition: PlayButtonPosition

    public var durationLabelPosition: DurationLabelPosition

    public var progressViewPosition: ProgressViewPosition

    public init(playButtonPosition: PlayButtonPosition, durationLabelPosition: DurationLabelPosition, progressViewPosition: ProgressViewPosition) {
        self.playButtonPosition = playButtonPosition
        self.durationLabelPosition = durationLabelPosition
        self.progressViewPosition = progressViewPosition
    }

    public init() {
        self.playButtonPosition = PlayButtonPosition(verticalOffset: 0, horizontal: .cellLeading, leadingTrailingPadding: 8)
        self.durationLabelPosition = DurationLabelPosition(verticalOffset: 0, horizontal: .cellTrailing, leadingTrailingPadding: 8)
        self.progressViewPosition = ProgressViewPosition(verticalOffset: 0, horizontal: .edgeToLeftAndRightView,
                                                         height: 2, horizontalEdgeInsets: HorizontalEdgeInsets(left: 5, right: 5))
    }
}
