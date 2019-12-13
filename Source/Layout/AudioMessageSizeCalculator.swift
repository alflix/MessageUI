//
//  AudioMessageSizeCalculator.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

open class AudioMessageSizeCalculator: MessageSizeCalculator {
    public var audioPlayButtonLeadingTrailingPadding: CGFloat = 15
    public var audioDurationLabelLeadingTrailingPadding: CGFloat = 15
    public var progressViewLeadingTrailingPadding: CGFloat = 15

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        switch message.kind {
        case .audio(let item):
            let maxWidth = messageContainerMaxWidth(for: message)
            if maxWidth < item.size.width {
                // Maintain the ratio if width is too great
                let height = maxWidth * item.size.height / item.size.width
                return CGSize(width: maxWidth, height: height)
            }
            return item.size
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
}
