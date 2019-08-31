//
//  LocationManagerHelper.swift
//  CircleQ
//
//  Created by John on 2019/8/10.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation
import SwiftLocation
import MapKit

public typealias LocationBlock = (_ coordinate: CLLocationCoordinate2D?, _ errorMessage: String?) -> Void

public class LocationManagerHelper {
    static public let shared = LocationManagerHelper()

    private var completionBlock: LocationBlock?

    /// 获取 GPS -> 失败 -> 从 IP 地址获取地址 -> 失败 -> 获取历史GPS -> 失败 -> 提示错误
    ///
    /// - Parameter completionBlock: 完成回调
    public func locate(completionBlock: LocationBlock?) {
        self.completionBlock = completionBlock
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .any) { [weak self] (location) in
            switch location {
            case .failure:
                if let location = LocationManager.shared.lastLocation {
                    self?.completionBlock?(location.coordinate, nil)
                } else {
                    LocationManager.shared.locateFromIP(service: .ipAPI, result: { (location) in
                        switch location {
                        case .failure(let error):
                            DPrint(error.localizedDescription)
                            self?.completionBlock?(nil, error.localizedDescription)
                        case .success(let place):
                            self?.completionBlock?(place.coordinates, nil)
                        }
                    })
                }
            case .success(let location):
                self?.completionBlock?(location.coordinate, nil)
            }
        }
    }
}
