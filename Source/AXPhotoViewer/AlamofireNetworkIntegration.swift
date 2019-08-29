//
//  AlamofireNetworkIntegration.swift
//  CircleQ
//
//  Created by John on 2019/7/22.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation
import AXPhotoViewer
import AlamofireImage

public class AlamofireNetworkIntegration: NSObject, AXNetworkIntegrationProtocol {
    weak public var delegate: AXNetworkIntegrationDelegate?

    public func loadPhoto(_ photo: AXPhotoProtocol) {
        if photo.imageData != nil || photo.image != nil {
            delegate?.networkIntegration(self, loadDidFinishWith: photo)
            return
        }
        guard let url = photo.url else { return }

        UIImageView.af_sharedImageDownloader.download(URLRequest(url: url)) { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response.result {
            case .success(let image):
                photo.image = image
                strongSelf.delegate?.networkIntegration(strongSelf, loadDidFinishWith: photo)
            case .failure:
                photo.image = GGUI.ImageDownloader.placeholderImage
                strongSelf.delegate?.networkIntegration(strongSelf, loadDidFinishWith: photo)
            }
        }
    }

    public func cancelLoad(for photo: AXPhotoProtocol) {

    }

    public func cancelAllLoads() {

    }
}
