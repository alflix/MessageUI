//
//  MediaMessageCell.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class MediaMessageCell: MessageContentCell {
    /// 视频消息-播放按钮
    public lazy var playButton: UIButton = {
        let playButton = UIButton(type: .custom)
        return playButton
    }()

    /// 视频长度显示 Label
    public lazy var durationLabel: UILabel = UILabel()

    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(playButton)
        messageContainerView.addSubview(durationLabel)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    open override func configure(with message: Message, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        switch message.kind {
        case .photo(let mediaItem):
            if let image = mediaItem.image {
                imageView.image = image
            } else {
                imageView.setImage(with: mediaItem.url, placeholderImage: mediaItem.placeholderImage)
            }
            playButton.isHidden = true
            durationLabel.isHidden = true
        case .video(let mediaItem):
            if let image = mediaItem.coverImage {
                imageView.image = image
            } else {
                imageView.setImage(with: mediaItem.coverImageUrl, placeholderImage: mediaItem.placeholderImage)
            }
            playButton.isHidden = false
            durationLabel.isHidden = false

            let textAttributes = displayDelegate.videoDurationTextAttributes(for: self, in: messagesCollectionView)
            durationLabel.attributedText = NSAttributedString(string: mediaItem.durationText, attributes: textAttributes)
            durationLabel.sizeToFit()

            if let playImage = mediaItem.videoPlayImage {
                playButton.setImage(playImage.withRenderingMode(.alwaysOriginal), for: .normal)
                playButton.sizeToFit()
            }
        default:
            break
        }
        imageView.frame = messageContainerView.bounds
        playButton.center = imageView.center
        durationLabel.frame.origin = CGPoint(x: messageContainerView.bounds.width - durationLabel.bounds.width - 2,
                                             y: messageContainerView.bounds.height - durationLabel.bounds.height - 2)
        displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
    }
}
