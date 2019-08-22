//
//  GGUI.swift
//  GGUI
//
//  Created by John on 2019/1/21.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import Foundation

/// 重要，GGUI 的全局设置，需要调整时，请在 AppDelegate 中配置
public struct GGUI {
    /// 横线配置
    public enum LineView {
        /// 颜色
        public static var color: UIColor = .lightGray
        /// 线宽
        public static var lineWidth: CGFloat = 1.0
    }

    /// 快速创建 AttributedString 的默认设置项
    public enum AttributedString {
        /// 颜色
        public static var defaultColor: UIColor = .black
        /// 字体
        public static var defaultFont: UIFont = .systemFont(ofSize: 14)
    }

    /// 自定义按钮配置
    public enum CustomButton {
        /// 不可点击状态的 alpha 值
        public static var disableAlpha: CGFloat = 0.4
    }

    /// 自定义按钮配置
    public enum CustomTextField {
        /// placeholder 文字颜色
        public static var placeholderColor: UIColor = .lightGray
    }

    /// 对 Label 设置上下左右边距的 UILabel 的默认值
    public enum InsetLabelConfig {
        public static var defaultInset: CGFloat = 16
    }

    /// 倒计时按钮配置
    public enum CountdownButton {
        /// 倒计时秒数
        public static var seconds: Int = 60
        /// 结束倒计时文字
        public static var finishNormalTitle: String?
        /// 正常状态的文字颜色
        public static var normalTitleColor: UIColor = .black
        /// 倒计时状态的文字颜色
        public static var disableTitleColor: UIColor = .gray
        /// 倒计时显示的文字 eg：「剩余 59 s」 中的 剩余
        public static var disableTitle: String = ""
        /// 倒计时秒数的文字 eg：「剩余 59 s」 中的 s
        public static var secondsTitle: String = "s"
    }

    /// 网络图片下载配置
    public enum ImageDownloader {
        /// 占位图片
        public static var placeholderImage: UIImage?
        /// 占位颜色（若有占位图片则不生效）
        public static var placeholderTintColor: UIColor = .gray
        /// 头像占位图片
        public static var avatarPlaceholderImage: UIImage?
        /// 头像占位颜色（若有占位图片则不生效）
        public static var avatarPlaceholderTintColor: UIColor = .gray
        /// 下载失败的显示的图片
        public static var failureImage: UIImage?
    }

    /// 弹窗配置
    public enum HUDConfig {
        /// 成功弹窗的图片
        public static var successImage: UIImage?
        /// 失败弹窗的图片
        public static var failImage: UIImage?
        /// loading 弹窗的自动消失的秒数
        public static var loadingAutoHideTime: TimeInterval = 20
        /// 弹窗消失的秒数
        public static var messageHideTime: TimeInterval = 1.5
    }

    /// WebView 配置
    public enum WebViewConfig {
        /// 弹窗确定按钮的文字
        public static var alertConfirmTitle: String = "OK"
        /// 弹窗取消按钮的文字
        public static var alertCancelTitle: String = "Cancel"
        /// 进度条完成部分进度的颜色
        public static var progressTintColor: UIColor = .blue
        /// 进度条总进度的颜色
        public static var progressTrackTintColor: UIColor = .white
    }

    /// 导航栏配置
    public enum NavigationBarConfig {
        /// 返回按钮的图片
        public static var backIconImage: UIImage?
        /// 样式（透明度，颜色，分割线等）
        public static var appearance: NavigationAppearance = NavigationAppearance()
    }

    /// Codable 配置
    public enum CodableConfig {
        /// 日期的格式
        public static var dateFormat: String?
        /// 日期 Decode 策略，如果 dateFormat 不为空，会以 dateFormat 创建的 formatted(DateFormatter) 为准，即该设置会被忽略
        public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .millisecondsSince1970
        /// 日期 Encode 策略，如果 dateFormat 不为空，会以 dateFormat 创建的 formatted(DateFormatter) 为准，即该设置会被忽略
        public static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .millisecondsSince1970
    }

    /// 使用日期解析显示中的一些默认文本 
    public enum DateDisplayStrings {
        /// 昨天
        public static var yesterday: String = "昨天"
        /// key：1-7， value 星期日至星期一
        public static var weekdayMapString: [Int: String] = [1: "星期日", 2: "星期一", 3: "星期二", 4: "星期三",
                                                             5: "星期四", 6: "星期五", 7: "星期六"]
    }
}

// 用于 Pod 内部的本地化
extension String {
    var bundleLocalize: String {
        return NSLocalizedString(self, tableName: "Localize", bundle: Bundle(for: LocalizeHelper.self), value: "", comment: "")
    }
}

class LocalizeHelper: NSObject {}
