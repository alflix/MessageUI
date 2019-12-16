//
//  AudioMessageCell.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit
import AVFoundation

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class AudioMessageCell: MessageContentCell {
    /// 播放按钮
    public lazy var playButton: UIButton = UIButton(type: .custom)
    /// 进度 Label
    public lazy var durationLabel: UILabel = UILabel()
    /// 进度条
    public lazy var progressView: UIProgressView = UIProgressView(progressViewStyle: .default)

    // MARK: - Methods
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(playButton)
        messageContainerView.addSubview(durationLabel)
        messageContainerView.addSubview(progressView)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        progressView.progress = 0
        playButton.isSelected = false
        durationLabel.text = "0:00"
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        // 优化，增加点击区域
        let playButtonTouchArea = CGRect(playButton.frame.origin.x - 10.0, playButton.frame.origin.y - 10,
                                         playButton.frame.size.width + 20, playButton.frame.size.height + 20)
        let translateTouchLocation = convert(touchLocation, to: messageContainerView)
        if playButtonTouchArea.contains(translateTouchLocation) {
            delegate?.didTapPlayButton(in: self)
        } else {
            super.handleTapGesture(gesture)
        }
    }

    public func updatePlaying(duration: Float, progress: Float, with message: Message, and messagesCollectionView: MessagesCollectionView) {
        progressView.progress = progress
        playButton.isSelected = progress > 0
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        let textAttributes = displayDelegate.audioProgressTextAttributes(for: self, in: messagesCollectionView)
        let text = displayDelegate.audioProgressTextFormat(duration, for: self, in: messagesCollectionView)
        durationLabel.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        guard let indexPath = messagesCollectionView.indexPath(for: self) else { return }
        configureFrame(with: message, at: indexPath, and: messagesCollectionView)
    }

    // MARK: - Configure Cell
    open override func configure(with message: Message, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        guard case let .audio(audioItem) = message.kind else { return }

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let tintColor = displayDelegate.audioTintColor(for: message, at: indexPath, in: messagesCollectionView)
        playButton.imageView?.tintColor = tintColor
        progressView.tintColor = tintColor

        let textAttributes = displayDelegate.audioProgressTextAttributes(for: self, in: messagesCollectionView)
        let text = displayDelegate.audioProgressTextFormat(audioItem.duration, for: self, in: messagesCollectionView)
        durationLabel.attributedText = NSAttributedString(string: text, attributes: textAttributes)

        displayDelegate.configureAudioCell(self, message: message)

        if let playImage = audioItem.audioPlayImage, let pauseImage = audioItem.audioPauseImage {
            playButton.setImage(playImage.withRenderingMode(.alwaysTemplate), for: .normal)
            playButton.setImage(pauseImage.withRenderingMode(.alwaysTemplate), for: .selected)
        }
        configureFrame(with: message, at: indexPath, and: messagesCollectionView)
    }

    func configureFrame(with message: Message, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        playButton.sizeToFit()
        durationLabel.sizeToFit()
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        let attributes = layoutDelegate.audioCellPosition(for: message, at: indexPath, in: messagesCollectionView)
        var leftView: UIView?
        var rightView: UIView?
        configurePlayButton(position: attributes.playButtonPosition, leftView: &leftView, rightView: &rightView)
        configureDurationLabel(position: attributes.durationLabelPosition, leftView: &leftView, rightView: &rightView)
        configureProgressView(position: attributes.progressViewPosition, leftView: leftView!, rightView: rightView!)
    }

    func configurePlayButton(position: AudioPosition.PlayButtonPosition, leftView: inout UIView?, rightView: inout UIView?) {
        let padding = position.leadingTrailingPadding
        var origin: CGPoint = .zero
        switch position.horizontal {
        case .cellLeading:
            origin.x = padding
            leftView = playButton
        case .cellTrailing:
            origin.x = messageContainerView.bounds.width - playButton.bounds.width - padding
            rightView = playButton
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
        origin.y = (messageContainerView.bounds.height - playButton.bounds.height) / 2
            + position.verticalOffset
        playButton.frame.origin = origin
    }

    func configureDurationLabel(position: AudioPosition.DurationLabelPosition, leftView: inout UIView?, rightView: inout UIView?) {
        var origin: CGPoint = .zero
        let audioDurationLabelPadding = position.leadingTrailingPadding
        switch position.horizontal {
        case .cellLeading:
            origin.x = audioDurationLabelPadding
            leftView = durationLabel
            durationLabel.textAlignment = .left
        case .cellTrailing:
            origin.x = messageContainerView.bounds.width - durationLabel.bounds.width - audioDurationLabelPadding
            rightView = durationLabel
            durationLabel.textAlignment = .right
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
        origin.y = (messageContainerView.bounds.height - durationLabel.bounds.height) / 2
            + position.verticalOffset
        durationLabel.frame.origin = origin
    }

    func configureProgressView(position: AudioPosition.ProgressViewPosition, leftView: UIView, rightView: UIView) {
        var progressViewOrigin: CGPoint = .zero
        let leading = position.horizontalEdgeInsets.left
        let trailing = position.horizontalEdgeInsets.right

        let height = position.height
        progressViewOrigin.y = (messageContainerView.bounds.height - height) / 2 + position.verticalOffset

        switch position.horizontal {
        case .edgeToLeftAndRightView:
            progressViewOrigin.x = leftView.frame.maxX + leading
            let width = rightView.frame.minX - trailing - progressViewOrigin.x
            progressView.frame = CGRect(origin: progressViewOrigin, size: CGSize(width: width, height: height))
        case .edgeToSuperView:
            progressViewOrigin.x = leading
            let width = messageContainerView.bounds.width - leading - trailing
            progressView.frame = CGRect(origin: progressViewOrigin, size: CGSize(width: width, height: height))
        case .edgeToLeftView:
            progressViewOrigin.x = leftView.frame.maxX + leading
            let width = messageContainerView.bounds.width - trailing - progressViewOrigin.x
            progressView.frame = CGRect(origin: progressViewOrigin, size: CGSize(width: width, height: height))
        case .edgeToRightView:
            progressViewOrigin.x = leading
            let width = rightView.frame.minX - trailing - leading
            progressView.frame = CGRect(origin: progressViewOrigin, size: CGSize(width: width, height: height))
        }
    }
}
