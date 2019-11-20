//
//  LocationItem.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

import class CoreLocation.CLLocation

/// A protocol used to represent the data for a location message.
public protocol LocationItem {
    /// The location.
    var location: CLLocation { get }

    /// The size of the location item.
    var size: CGSize { get }
}
