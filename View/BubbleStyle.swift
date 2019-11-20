//
//  BubbleStyle.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public enum BubbleStyle {
    case none
    case bubble
    case bubbleTintColor(UIColor)
    case bubbleTail(TailCorner)
    case bubbleTailTintColor(UIColor, TailCorner)
    case custom((BubbleView) -> Void)

    public enum TailCorner: String {
        case topLeft
        case bottomLeft
        case topRight
        case bottomRight

        internal var imageOrientation: UIImage.Orientation {
            switch self {
            case .bottomRight: return .up
            case .bottomLeft: return .upMirrored
            case .topLeft: return .down
            case .topRight: return .downMirrored
            }
        }
    }

    public var image: UIImage? {
        guard let imageCacheKey = imageCacheKey else { return nil }
        let cache = BubbleStyle.bubbleImageCache
        if let cachedImage = cache.object(forKey: imageCacheKey as NSString) {
            return cachedImage
        }

        var tmpImage: UIImage?
        if let imageName = Config.Bubble.imageName {
            tmpImage = UIImage(named: imageName)
        } else {
            guard let path = imagePath else { return nil }
            tmpImage = UIImage(contentsOfFile: path)
        }
        guard var image = tmpImage else { return nil }

        switch self {
        case .none, .custom:
            return nil
        case .bubble, .bubbleTintColor:
            break
        case .bubbleTail(let corner), .bubbleTailTintColor(_, let corner):
            guard let cgImage = image.cgImage else { return nil }
            image = UIImage(cgImage: cgImage, scale: image.scale, orientation: corner.imageOrientation)
        }
        let stretchedImage = stretch(image)
        cache.setObject(stretchedImage, forKey: imageCacheKey as NSString)
        return stretchedImage
    }

    // MARK: - Internal

    internal static let bubbleImageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "com.messagekit.MessageKit.bubbleImageCache"
        return cache
    }()

    // MARK: - Private

    private var imageCacheKey: String? {
        guard let imageName = imageName else { return nil }
        switch self {
        case .bubble, .bubbleTintColor:
            return imageName
        case .bubbleTail(let corner), .bubbleTailTintColor(_, let corner):
            return imageName + "_" + corner.rawValue
        default:
            return nil
        }
    }

    private var imageName: String? {
        if let imageName = Config.Bubble.imageName {
            return imageName
        }
        switch self {
        case .bubble, .bubbleTintColor, .bubbleTail, .bubbleTailTintColor:
            return "bubble_full"
        case .none, .custom:
            return nil
        }
    }

    private var imagePath: String? {
        guard let imageName = imageName else { return nil }
        let assetBundle = Bundle.messageKitAssetBundle()
        return assetBundle.path(forResource: imageName, ofType: "png", inDirectory: "Images")
    }

    private func stretch(_ image: UIImage) -> UIImage {
        let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
        let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}
