//
//  ChatCellDelegate.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

/// A protocol used by `MessageContentCell` subclasses to detect taps in the cell's subviews.
public protocol ChatCellDelegate: TextDetectedDelegate {
    func didTapBackground(in cell: ChatBaseCell)

    func didTapMessage(in cell: ChatBaseCell)

    func didTapAvatar(in cell: ChatBaseCell)

    func didTapCellNameLabel(in cell: ChatBaseCell)

    func didTapMessageLabel(in cell: ChatBaseCell)

    func didTapAccessoryView(in cell: ChatBaseCell)

    func didTapPlayButton(in cell: AudioChatCell)

    func didStartAudio(in cell: AudioChatCell)

    func didPauseAudio(in cell: AudioChatCell)

    func didStopAudio(in cell: AudioChatCell)
}

public extension ChatCellDelegate {
    func didTapBackground(in cell: ChatBaseCell) {}

    func didTapMessage(in cell: ChatBaseCell) {}

    func didTapAvatar(in cell: ChatBaseCell) {}

    func didTapCellTopLabel(in cell: ChatBaseCell) {}

    func didTapCellBottomLabel(in cell: ChatBaseCell) {}

    func didTapMessageTopLabel(in cell: ChatBaseCell) {}

    func didTapPlayButton(in cell: AudioChatCell) {}

    func didStartAudio(in cell: AudioChatCell) {}

    func didPauseAudio(in cell: AudioChatCell) {}

    func didStopAudio(in cell: AudioChatCell) {}

    func didTapMessageBottomLabel(in cell: ChatBaseCell) {}

    func didTapAccessoryView(in cell: ChatBaseCell) {}
}
