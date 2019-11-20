//
//  BubbleView.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

open class BubbleView: UIImageView {
    private let imageMask = UIImageView()

    open var style: BubbleStyle = .none {
        didSet { applyBubbleStyle() }
    }

    open override var frame: CGRect {
        didSet { sizeMaskToView() }
    }

    // MARK: - Methods

    private func sizeMaskToView() {
        switch style {
        case .none, .custom:
            break
        case .bubble, .bubbleTintColor, .bubbleTail, .bubbleTailTintColor:
            imageMask.frame = bounds
        }
    }

    private func applyBubbleStyle() {
        switch style {
        case .none:
            mask = nil
            image = nil
            tintColor = nil
        case .bubble:
            imageMask.image = style.image
            sizeMaskToView()
            mask = imageMask
            image = nil
        case .bubbleTintColor(let color):
            let bubbleStyle: BubbleStyle = .bubble
            imageMask.image = bubbleStyle.image
            sizeMaskToView()
            mask = imageMask
            image = style.image?.withRenderingMode(.alwaysTemplate)
            tintColor = color
        case .bubbleTail(let corner):
            let bubbleStyle: BubbleStyle = .bubbleTail(corner)
            imageMask.image = bubbleStyle.image
            sizeMaskToView()
            mask = imageMask
            image = nil
        case .bubbleTailTintColor(let color, let corner):
            let bubbleStyle: BubbleStyle = .bubbleTail(corner)
            imageMask.image = bubbleStyle.image
            sizeMaskToView()
            mask = imageMask
            image = style.image?.withRenderingMode(.alwaysTemplate)
            tintColor = color
        case .custom(let configurationClosure):
            mask = nil
            image = nil
            tintColor = nil
            configurationClosure(self)
        }
    }
}
