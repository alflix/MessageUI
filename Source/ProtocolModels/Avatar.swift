//
//  Avatar.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

/// An object used to group the information to be used by an `AvatarView`.
public struct Avatar {
    // MARK: - Properties

    /// The image to be used for an `AvatarView`. If the imageURL is not nil, the image will become placeholder
    public let image: UIImage?

    /// The remote image url
    public var imageURL: String?

    public var radius: CGFloat?

    // MARK: - Initializer

    public init(image: UIImage? = nil, imageURL: String? = nil, radius: CGFloat? = nil) {
        self.image = image
        self.imageURL = imageURL
        self.radius = radius
    }
}
