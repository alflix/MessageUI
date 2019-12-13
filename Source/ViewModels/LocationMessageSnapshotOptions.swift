//
//  LocationMessageSnapshotOptions.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import MapKit

public struct LocationMessageCache {
    internal static let snapImageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "com.MessageUI.map.snapImageCache"
        return cache
    }()

    public static func image(by center: CLLocationCoordinate2D) -> UIImage? {
        let key = "\(center.longitude)+\(center.latitude)"
        return LocationMessageCache.snapImageCache.object(forKey: (key as NSString))
    }

    public static func cache(image: UIImage, center: CLLocationCoordinate2D) {
        let key = "\(center.longitude)+\(center.latitude)"
        LocationMessageCache.snapImageCache.setObject(image, forKey: (key as NSString))
    }
}

/// An object grouping the settings used by the `MKMapSnapshotter` through the `LocationMessageDisplayDelegate`.
public struct LocationMessageSnapshotOptions {
    /// Initialize LocationMessageSnapshotOptions with given parameters
    ///
    /// - Parameters:
    ///   - showsBuildings: A Boolean value indicating whether the snapshot image should display buildings.
    ///   - showsPointsOfInterest: A Boolean value indicating whether the snapshot image should display points of interest.
    ///   - span: The span of the snapshot.
    ///   - scale: The scale of the snapshot.
    public init(showsBuildings: Bool = false, showsPointsOfInterest: Bool = false,
                span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0),
                scale: CGFloat = UIScreen.main.scale) {
        self.showsBuildings = showsBuildings
        self.showsPointsOfInterest = showsPointsOfInterest
        self.span = span
        self.scale = scale
    }

    /// A Boolean value indicating whether the snapshot image should display buildings.
    ///
    /// The default value of this property is `false`.
    public var showsBuildings: Bool

    /// A Boolean value indicating whether the snapshot image should display points of interest.
    ///
    /// The default value of this property is `false`.
    public var showsPointsOfInterest: Bool

    /// 经纬度显示范围
    public var span: MKCoordinateSpan

    /// 缩放，默认 `UIScreen.main.scale`.
    public var scale: CGFloat
}
