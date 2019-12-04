//
//  MessageLabelDelegate.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// 消息文本点击检测事件
public protocol MessageLabelDelegate: AnyObject {
    /// 点击地址
    func didSelectAddress(_ addressComponents: [String: String])

    /// 点击日期
    func didSelectDate(_ date: Date)

    /// 点击电话号码
    func didSelectPhoneNumber(_ phoneNumber: String)

    /// 点击 URL
    func didSelectURL(_ url: URL)

    /// ?
    func didSelectTransitInformation(_ transitInformation: [String: String])

    /// 点击 @ 提及
    func didSelectMention(_ mention: String)

    /// 点击 # 标签
    func didSelectHashtag(_ hashtag: String)

    /// 点击自定义文本
    func didSelectCustom(_ pattern: String, match: String?)
}

public extension MessageLabelDelegate {
    func didSelectAddress(_ addressComponents: [String: String]) {}

    func didSelectDate(_ date: Date) {}

    func didSelectPhoneNumber(_ phoneNumber: String) {}

    func didSelectURL(_ url: URL) {}

    func didSelectTransitInformation(_ transitInformation: [String: String]) {}

    func didSelectMention(_ mention: String) {}

    func didSelectHashtag(_ hashtag: String) {}

    func didSelectCustom(_ pattern: String, match: String?) {}
}
