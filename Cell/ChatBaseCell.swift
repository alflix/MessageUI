//
//  ChatBaseCell.swift
//  Worker
//
//  Created by John on 2019/11/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

open class ChatBaseCell: UICollectionViewCell {
    open var avatarView = AvatarView()

    /// The container used for styling and holding the message's content view.
    open var bubbleView: BubbleView = {
        let bubbleView = BubbleView()
        bubbleView.clipsToBounds = true
        bubbleView.layer.masksToBounds = true
        return containerView
    }()

    /// The top label of the messageBubble.
    open var nameLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    /// The `MessageCellDelegate` for the cell.
    open weak var delegate: ChatCellDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }

    open func setupSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(bubbleView)
        contentView.addSubview(avatarView)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
}
