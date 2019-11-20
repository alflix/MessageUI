//
//  TextDetectedDelegate.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

/// A protocol used to handle tap events on detected text.
public protocol TextDetectedDelegate: AnyObject {
    func didSelectAddress(_ addressComponents: [String: String])

    func didSelectDate(_ date: Date)

    func didSelectPhoneNumber(_ phoneNumber: String)

    func didSelectURL(_ url: URL)

    func didSelectTransitInformation(_ transitInformation: [String: String])

    func didSelectMention(_ mention: String)

    func didSelectHashtag(_ hashtag: String)

    func didSelectCustom(_ pattern: String, match: String?)
}

public extension TextDetectedDelegate {
    func didSelectAddress(_ addressComponents: [String: String]) {}

    func didSelectDate(_ date: Date) {}

    func didSelectPhoneNumber(_ phoneNumber: String) {}

    func didSelectURL(_ url: URL) {}

    func didSelectTransitInformation(_ transitInformation: [String: String]) {}

    func didSelectMention(_ mention: String) {}

    func didSelectHashtag(_ hashtag: String) {}

    func didSelectCustom(_ pattern: String, match: String?) {}
}
