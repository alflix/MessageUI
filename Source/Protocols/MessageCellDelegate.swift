//
//  MessageCellDelegate.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// `MessageContentCell` 点击事件
public protocol MessageCellDelegate: MessageLabelDelegate {
    /// 点击背景
    func didTapBackground(in cell: MessageCollectionViewCell)

    /// 点击 `MessageContainerView`
    func didTapMessage(in cell: MessageCollectionViewCell)

    /// 点击 `AvatarView`
    func didTapAvatar(in cell: MessageCollectionViewCell)

    /// 点击 cellTopLabel
    func didTapCellTopLabel(in cell: MessageCollectionViewCell)

    /// 点击 cellBottomLabel.
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell)

    /// 点击 messageTopLabel.
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell)

    /// 点击 messageBottomLabel.
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell)

    /// 点击 accessoryView.
    func didTapAccessoryView(in cell: MessageCollectionViewCell)

    /// 点击播放按钮
    func didTapPlayButton(in cell: AudioMessageCell)

    /// 开始播放音频
    func didStartAudio(in cell: AudioMessageCell)

    /// 暂停播放音频
    func didPauseAudio(in cell: AudioMessageCell)

    /// 停止播放音频
    func didStopAudio(in cell: AudioMessageCell)
}

public extension MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {}

    func didTapMessage(in cell: MessageCollectionViewCell) {}

    func didTapAvatar(in cell: MessageCollectionViewCell) {}

    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {}

    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {}

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {}

    func didTapPlayButton(in cell: AudioMessageCell) {}

    func didStartAudio(in cell: AudioMessageCell) {}

    func didPauseAudio(in cell: AudioMessageCell) {}

    func didStopAudio(in cell: AudioMessageCell) {}

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {}

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {}
}
