//
//  MessageContainerView.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//
import UIKit

open class MessageContainerView: UIImageView {
    // MARK: - Properties
    private let imageMask = UIImageView()

    open var style: BubbleStyle = .roundCorners(3) {
        didSet { applyBubbleStyle() }
    }

    open override var frame: CGRect {
        didSet { sizeMaskToView() }
    }

    // MARK: - Methods
    private func sizeMaskToView() {
        switch style {
        case .custom:
            break
        case .roundCorners, .image:
            imageMask.frame = bounds
        }
    }

    private func applyBubbleStyle() {
        switch style {
        case .roundCorners(let radius):
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        case .image(let customImage):
            imageMask.image = style.stretch(customImage)
            sizeMaskToView()
            mask = imageMask
            image = nil
        case .custom(let configurationClosure):
            mask = nil
            image = nil
            tintColor = nil
            configurationClosure(self)
        }
    }
}
