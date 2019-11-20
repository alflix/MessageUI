//
//  Bundle+Extensions.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

internal extension Bundle {
    static func messageKitAssetBundle() -> Bundle { // swiftlint:disable:this explicit_acl
        let podBundle = Bundle(for: ChatBaseCell.self)
        guard let resourceBundleUrl = podBundle.url(forResource: "MessageKitAssets", withExtension: "bundle") else {
            fatalError(ChatKitError.couldNotCreateAssetsPath)
        }
        guard let resourceBundle = Bundle(url: resourceBundleUrl) else {
            fatalError(ChatKitError.couldNotLoadAssetsBundle)
        }
        return resourceBundle
    }
}
