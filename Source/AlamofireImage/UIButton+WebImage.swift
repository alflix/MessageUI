//
//  UIButton+WebImage.swift
//  Alamofire
//
//  Created by John on 2019/6/1.
//

import UIKit
import AlamofireImage

public extension UIButton {
    /// 设置网络资源图片
    ///
    /// - Parameters:
    ///   - urlString: 图像 url string
    ///   - placeholderImage: 占位图片，可以通过全局设置 GGUI.ImageDownloader.placeholderImage 或
    ///     GGUI.ImageDownloader.placeholderTintColor（只有颜色）
    ///   - failureImage: 下载失败的图片，可以通过全局设置 GGUI.ImageDownloader.avatarPlaceholderImage，为空时用 placeholderImage
    ///   - completion: 设置完成
    func setImage(with urlString: String?,
                  placeholderImage: UIImage? = nil,
                  failureImage: UIImage? = nil,
                  completion: VoidBlock? = nil,
                  filter: ImageFilter? = nil) {
        var placeholder: UIImage?
        if let placeholderImage = placeholderImage {
            placeholder = placeholderImage
        } else if let placeholderImage = GGUI.ImageDownloader.placeholderImage {
            placeholder = placeholderImage
        } else {
            placeholder = UIImage(color: GGUI.ImageDownloader.placeholderTintColor, size: size)
        }
        let failure = failureImage ?? GGUI.ImageDownloader.failureImage
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageForNormal = failure ?? placeholder
            completion?()
            return
        }
        _ = af_setImage(for: .normal, url: url, placeholderImage: placeholder, filter: filter, completion: {  [weak self] (response) in
            if response.value == nil {
                self?.imageForNormal = failure ?? placeholder
            }
            completion?()
        })
    }
}
