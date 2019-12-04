//
//  LabelAlignment.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import UIKit

public struct LabelAlignment: Equatable {
    public var textAlignment: NSTextAlignment
    public var textInsets: UIEdgeInsets

    public init(textAlignment: NSTextAlignment, textInsets: UIEdgeInsets) {
        self.textAlignment = textAlignment
        self.textInsets = textInsets
    }
}

public extension LabelAlignment {
    static func == (lhs: LabelAlignment, rhs: LabelAlignment) -> Bool {
        return lhs.textAlignment == rhs.textAlignment && lhs.textInsets == rhs.textInsets
    }
}
