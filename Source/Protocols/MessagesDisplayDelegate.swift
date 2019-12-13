//
//  MessagesDisplayDelegate.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import Foundation
import MapKit

/// 定制 `MessageContentCell` UI，颜色，字体
public protocol MessagesDisplayDelegate: AnyObject {
    // MARK: - All Messages
    /// `MessageContainerView` 的气泡图风格，默认：`BubbleStyle.bubble`
    func bubbleStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> BubbleStyle

    /// `MessageContainerView` 背景颜色，默认：Current sender: Green，All other senders: Gray
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// 配置 section header
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionReusableView

    /// 配置 section footer
    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionReusableView

    /// 配置 `AvatarView`
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType,
                             at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    /// 配置 `AccessoryView`
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType,
                                at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    // MARK: - Text Messages
    /// `TextMessageCell` 的文字颜色，默认：Current sender: UIColor.white，All other senders: UIColor.darkText
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// 配置文本消息的识别类型 `DetectorType`，默认为空
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType]

    /// 识别出来文本的高亮属性
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any]

    // MARK: - Location Messages
    /// 配置 `LocationMessageSnapshotOptions`，自定义地理消息的截图选项
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath,
                                    in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions

    /// 配置地理消息的大头针 annoation
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath,
                                   in messageCollectionView: MessagesCollectionView) -> MKAnnotationView?

    /// 配置地理消息的 title 显示
    func titleAttributesLocation(message: MessageType, at indexPath: IndexPath,
                                 in messageCollectionView: MessagesCollectionView) -> [NSAttributedString.Key: Any]

    /// 配置地理消息的 subtitle 显示
    func subtitleAttributesForLocation(message: MessageType, at indexPath: IndexPath,
                                       in messageCollectionView: MessagesCollectionView) -> [NSAttributedString.Key: Any]

    // MARK: - Media Messages
    /// 配置 `MediaMessageCell`-`UIImageView`
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType,
                                        at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    /// 视频时长的 Label 显示
    func videoDurationTextAttributes(for audioCell: MediaMessageCell, in messagesCollectionView: MessagesCollectionView)
        -> [NSAttributedString.Key: Any]

    // MARK: - Audio Message
    /// 配置 `AudioMessageCell`
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType)

    /// 音频播放按钮，播放进度条 tint color
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// 音频播放进度的时间格式，默认 0"
    func audioProgressTextFormat(_ duration: Float, for audioCell: AudioMessageCell, in messageCollectionView: MessagesCollectionView) -> String

    /// 音频播放进度的 Label 显示
    func audioProgressTextAttributes(for audioCell: AudioMessageCell, in messagesCollectionView: MessagesCollectionView)
        -> [NSAttributedString.Key: Any]
}

public extension MessagesDisplayDelegate {
    // MARK: - All Messages Defaults
    func bubbleStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> BubbleStyle {
        return .roundCorners(3)
    }

    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .white }
        return dataSource.isFromCurrentSender(message: message) ? .lightGray : .white
    }

    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionReusableView {
        return messagesCollectionView.dequeueReusableHeaderView(UICollectionReusableView.self, for: indexPath)
    }

    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionReusableView {
        return messagesCollectionView.dequeueReusableFooterView(UICollectionReusableView.self, for: indexPath)
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    }

    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {}

    // MARK: - Text Messages Defaults
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return dataSource.isFromCurrentSender(message: message) ? .white : .darkText
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return []
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }

    // MARK: - Location Messages Defaults
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath,
                                    in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        return LocationMessageSnapshotOptions()
    }

    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath,
                                   in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        return MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
    }

    func titleAttributesLocation(message: MessageType, at indexPath: IndexPath,
                                 in messageCollectionView: MessagesCollectionView) -> [NSAttributedString.Key: Any] {
        return [
            .foregroundColor: UIColor.darkText,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
    }

    /// 配置地理消息的 subtitle 字体
    func subtitleAttributesForLocation(message: MessageType, at indexPath: IndexPath,
                                       in messageCollectionView: MessagesCollectionView) -> [NSAttributedString.Key: Any] {
        return [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.preferredFont(forTextStyle: .footnote)
        ]
    }

    // MARK: - Media Message Defaults
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType,
                                        at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    }

    func videoDurationTextAttributes(for audioCell: MediaMessageCell, in messagesCollectionView: MessagesCollectionView)
        -> [NSAttributedString.Key: Any] {
            return [
                .foregroundColor: UIColor.white,
                .font: UIFont.preferredFont(forTextStyle: .footnote)
            ]
    }

    // MARK: - Audio Message Defaults
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
    }

    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
    }

    func audioProgressTextFormat(_ duration: Float, for audioCell: AudioMessageCell, in messageCollectionView: MessagesCollectionView) -> String {
        return "\(Int(duration))\""
    }

    func audioProgressTextAttributes(for audioCell: AudioMessageCell, in messagesCollectionView: MessagesCollectionView)
        -> [NSAttributedString.Key: Any] {
        return [
            .foregroundColor: UIColor.darkText,
            .font: UIFont.preferredFont(forTextStyle: .footnote)
        ]
    }
}
