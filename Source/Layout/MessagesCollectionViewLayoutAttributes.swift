//
//  MessagesCollectionViewLayoutAttributes.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// Cell 上元素的布局方式，影响高度计算的布局的，和 cell 内容无关的（布局的时候还没有 display）
open class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    // MARK: - Properties
    public var avatarSize: CGSize = .zero
    public var avatarPosition = AvatarPosition(vertical: .cellBottom)
    public var avatarLeadingTrailingPadding: CGFloat = 0

    public var messageContainerSize: CGSize = .zero
    public var messageContainerPadding: UIEdgeInsets = .zero
    public var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    public var messageLabelInsets: UIEdgeInsets = .zero

    public var cellTopLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var cellTopLabelSize: CGSize = .zero

    public var cellBottomLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var cellBottomLabelSize: CGSize = .zero

    public var messageTopLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var messageTopLabelSize: CGSize = .zero

    public var messageBottomLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var messageBottomLabelSize: CGSize = .zero

    public var accessoryViewSize: CGSize = .zero
    public var accessoryViewPadding: HorizontalEdgeInsets = .zero
    public var accessoryViewPosition: AccessoryPosition = .messageCenter

    // 音频类型的布局方式
    public var audioPosition: AudioPosition = AudioPosition()

    // MARK: - Methods
    open override func copy(with zone: NSZone? = nil) -> Any {
        // swiftlint:disable force_cast
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.avatarSize = avatarSize
        copy.avatarPosition = avatarPosition
        copy.avatarLeadingTrailingPadding = avatarLeadingTrailingPadding
        copy.messageContainerSize = messageContainerSize
        copy.messageContainerPadding = messageContainerPadding
        copy.messageLabelFont = messageLabelFont
        copy.messageLabelInsets = messageLabelInsets
        copy.cellTopLabelAlignment = cellTopLabelAlignment
        copy.cellTopLabelSize = cellTopLabelSize
        copy.cellBottomLabelAlignment = cellBottomLabelAlignment
        copy.cellBottomLabelSize = cellBottomLabelSize
        copy.messageTopLabelAlignment = messageTopLabelAlignment
        copy.messageTopLabelSize = messageTopLabelSize
        copy.messageBottomLabelAlignment = messageBottomLabelAlignment
        copy.messageBottomLabelSize = messageBottomLabelSize
        copy.accessoryViewSize = accessoryViewSize
        copy.accessoryViewPadding = accessoryViewPadding
        copy.accessoryViewPosition = accessoryViewPosition
        copy.audioPosition = audioPosition
        return copy
        // swiftlint:enable force_cast
    }

    open override func isEqual(_ object: Any?) -> Bool {
        // MARK: - LEAVE this as is
        if let attributes = object as? MessagesCollectionViewLayoutAttributes {
            return super.isEqual(object) && attributes.avatarSize == avatarSize
                && attributes.avatarPosition == avatarPosition
                && attributes.avatarLeadingTrailingPadding == avatarLeadingTrailingPadding
                && attributes.messageContainerSize == messageContainerSize
                && attributes.messageContainerPadding == messageContainerPadding
                && attributes.messageLabelFont == messageLabelFont
                && attributes.messageLabelInsets == messageLabelInsets
                && attributes.cellTopLabelAlignment == cellTopLabelAlignment
                && attributes.cellTopLabelSize == cellTopLabelSize
                && attributes.cellBottomLabelAlignment == cellBottomLabelAlignment
                && attributes.cellBottomLabelSize == cellBottomLabelSize
                && attributes.messageTopLabelAlignment == messageTopLabelAlignment
                && attributes.messageTopLabelSize == messageTopLabelSize
                && attributes.messageBottomLabelAlignment == messageBottomLabelAlignment
                && attributes.messageBottomLabelSize == messageBottomLabelSize
                && attributes.accessoryViewSize == accessoryViewSize
                && attributes.accessoryViewPadding == accessoryViewPadding
                && attributes.accessoryViewPosition == accessoryViewPosition
                && attributes.audioPosition == audioPosition
        } else {
            return false
        }
    }
}
