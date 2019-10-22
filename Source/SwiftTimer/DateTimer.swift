//
//  DateTimer.swift
//  GGUI
//
//  Created by John on 08/28/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation
import UIKit
import SwiftTimer

public struct StopWatch {
    var totalSeconds: Int

    public init(totalSeconds: Int) {
        self.totalSeconds = totalSeconds
    }
    public var years: Int {
        return totalSeconds / 31536000
    }

    public var days: Int {
        return (totalSeconds % 31536000) / 86400
    }

    public var hours: Int {
        return (totalSeconds % 86400) / 3600
    }

    public var minutes: Int {
        return (totalSeconds % 3600) / 60
    }

    public var seconds: Int {
        return totalSeconds % 60
    }

    public var hoursMinutesAndSeconds: (hours: Int, minutes: Int, seconds: Int) {
        return (hours, minutes, seconds)
    }

    public var dayshoursMinutesAndSeconds: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        return (days, hours, minutes, seconds)
    }
}

public typealias DateTimerClosure = (_ second: Int, _ stopWatch: StopWatch) -> Void

public class DateTimer {
    private var timer: SwiftCountDownTimer?
    private var beginDate: Date
    private var endDate: Date
    private var completion: DateTimerClosure?

    public init(beginDate: Date, endDate: Date, handler: DateTimerClosure?) {
        self.beginDate = beginDate
        self.endDate = endDate
        self.completion = handler
        beginCountDown()
    }

    public func beginCountDown() {
        let seconds = endDate.timeIntervalSince(beginDate).int
        timer = SwiftCountDownTimer(interval: .fromSeconds(1),
                                    times: seconds,
                                    handler: { [weak self] (_, seconds) in
                                        guard let strongSelf = self else { return }
                                        let watch = StopWatch(totalSeconds: seconds)
                                        strongSelf.completion?(seconds, watch)
        })
        timer?.start()
    }
}
