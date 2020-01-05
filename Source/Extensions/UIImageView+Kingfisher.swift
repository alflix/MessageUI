//
//  UIImageView+.swift
//  Kingfisher+Ganguo
//
//  Created by John on 2018/9/26.
//  Copyright © 2019 AdvancePods. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// 设置圆角的网络资源头像
    ///
    /// - Parameters:
    ///   - urlString: 图像 url string
    ///   - size: 尺寸，默认为 UIImageView 的宽度
    ///   - placeholderImage: 占位图片，可以通过全局设置 ImageDownloader.avatarPlaceholderImage 或
    ///     ImageDownloader.avatarPlaceholderTintColor（只有颜色）
    ///   - completion: 设置完成
    func setAvatarImage(with urlString: String?,
                        size: CGFloat = 0,
                        placeholderImage: UIImage? = nil,
                        completion: (() -> Void)? = nil) {
        let diameter = (size > 0) ? size : self.bounds.size.width * UIScreen.main.scale
        let profileImageSize = CGSize(width: diameter, height: diameter)
        image = placeholderImage
        guard let urlString = urlString, urlString.count > 0, let url = URL(string: urlString) else {
            completion?()
            return
        }
        let processor = DownsamplingImageProcessor(size: profileImageSize)
            |> RoundCornerImageProcessor(cornerRadius: diameter/2)
        kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor),
                                                                        .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }

    /// 设置网络资源图片
    ///
    /// - Parameters:
    ///   - urlString: 图像 url string
    ///   - placeholderImage: 占位图片，可以通过全局设置 ImageDownloader.placeholderImage 或
    ///     ImageDownloader.placeholderTintColor（只有颜色）
    ///   - failureImage: 下载失败的图片，可以通过全局设置 ImageDownloader.avatarPlaceholderImage，为空时用 placeholderImage
    ///   - completion: 设置完成
    func setImage(with urlString: String?,
                  placeholderImage: UIImage? = nil,
                  failureImage: UIImage? = nil,
                  completion: (() -> Void)? = nil) {
        image = placeholderImage
        guard let urlString = urlString, urlString.count > 0, let url = URL(string: urlString) else {
            completion?()
            return
        }
        if bounds.size.width > 0, bounds.size.height > 0 {
            let doubleSie = CGSize(width: bounds.size.width * UIScreen.main.scale,
                                   height: bounds.size.height * UIScreen.main.scale)
            kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(DownsamplingImageProcessor(size: doubleSie)),
                                                                            .cacheOriginalImage]) { [weak self] result in
                                                                                switch result {
                                                                                case .success:
                                                                                    ()
                                                                                case .failure:
                                                                                    self?.image = failureImage
                                                                                }
                                                                                completion?()
            }
        } else {
            kf.setImage(with: url, placeholder: placeholderImage, options: [.cacheOriginalImage]) { [weak self] result in
                switch result {
                case .success:
                    ()
                case .failure:
                    self?.image = failureImage
                }
                completion?()
            }
        }
    }
}
