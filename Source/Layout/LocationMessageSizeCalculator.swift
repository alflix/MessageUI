//
//  LocationMessageSizeCalculator.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

open class LocationMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        switch message.kind {
        case .location(let item):
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
