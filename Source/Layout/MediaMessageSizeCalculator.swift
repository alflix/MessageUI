//
//  MediaMessageSizeCalculator.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

open class MediaMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: Message) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        switch message.kind {
        case .photo(let item):
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let maxWidth = CGFloat(screenWidth/CGFloat(item.maxSizeFactor.0))
            let maxHeight: CGFloat = CGFloat(screenHeight/CGFloat(item.maxSizeFactor.1))

            var factor: CGFloat = 1
            if item.size.width > maxWidth || item.size.height > maxHeight {
                let dependWidth = item.size.width >= item.size.height
                factor = dependWidth ? maxWidth / item.size.width : maxHeight / item.size.height
            }
            let newSize = CGSize(width: item.size.width * factor, height: item.size.height * factor)
            if maxWidth < newSize.width {
                let height = maxWidth * newSize.height / newSize.width
                return CGSize(width: maxWidth, height: height)
            }
            return newSize
        case .video(let item):
            if maxWidth < item.size.width {
                let height = maxWidth * item.size.height / item.size.width
                return CGSize(width: maxWidth, height: height)
            }
            return item.size
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
}
