/*
 
 */

import Foundation

extension Bundle {
    static func messageKitAssetBundle() -> Bundle {
        let podBundle = Bundle(for: MessagesViewController.self)

        guard let resourceBundleUrl = podBundle.url(forResource: "MessageKitAssets", withExtension: "bundle") else {
            fatalError(MessageKitError.couldNotCreateAssetsPath)
        }

        guard let resourceBundle = Bundle(url: resourceBundleUrl) else {
            fatalError(MessageKitError.couldNotLoadAssetsBundle)
        }
        return resourceBundle
    }
}
