//
//  AvatarView.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

open class AvatarView: UIImageView {
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }

    convenience public init() {
        self.init(frame: .zero)
        prepareView()
    }

    // MARK: - methods

    func prepareView() {
        backgroundColor = .gray
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        clipsToBounds = true
    }

    // MARK: - Open setters

    open func set(avatar: Avatar) {
        if let image = avatar.image {
            self.image = image
        } else {

        }
    }
}
