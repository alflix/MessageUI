//
//  LocationItem.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import class CoreLocation.CLLocation

/// A protocol used to represent the data for a location message.
public protocol LocationItem {
    /// The location.
    var location: CLLocation { get }

    /// The size of the location item.
    var size: CGSize { get }

    var title: String { get }

    var subtitle: String { get }
}
