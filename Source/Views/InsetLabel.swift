//
//  InsetLabel.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import UIKit

open class InsetLabel: UILabel {
    open var textInsets: UIEdgeInsets = .zero {
        didSet { setNeedsDisplay() }
    }

    open override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }
}
