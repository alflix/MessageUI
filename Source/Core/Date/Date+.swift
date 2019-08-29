//
//  Date+.swift
//  GGUI
//
//  Created by John on 2019/4/9.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation
import SwifterSwift

public extension Date {
    /// 日期的显示方式
    ///
    /// - today12: 今天，12小时制，只显示时间
    /// - today24: 今天，24小时制，只显示时间
    /// - yesterday: 显示昨天
    /// - weekDay: 本周内，显示星期几
    enum DisplayStyle {
        case today12
        case today24
        case yesterday
        case weekDay
    }

    /// 是否在x分钟的间隔内
    ///
    /// - Parameters:
    ///   - minutes: 分钟数
    ///   - date: 用于比较的时间
    /// - Returns: 是/否
    func isBetween(minutes: Int, by date: Date?) -> Bool {
        guard let date = date else { return false }
        if isBetween(date.adding(.minute, value: -minutes), date)
            || isBetween(date.adding(.minute, value: minutes), date) {
            return true
        }
        return false
    }

    /// 是否在5分钟的间隔内，默认和当前时间比较 
    func isBetween5Minutes(by date: Date = Date()) -> Bool {
        return isBetween(minutes: 5, by: date)
    }

    /// 日期的显示方式
    ///
    /// - Parameters:
    ///   - style: 数组，可以指定显示的方式
    ///   - todayClock: 对于今天，显示
    /// - Returns: 
    func display(style: [DisplayStyle]) -> String {
        if style.contains(.today12) && isInToday {
            return string(withFormat: "HH:mm a")
        }
        if style.contains(.today24) && isInToday {
            return string(withFormat: "HH:mm")
        }
        if style.contains(.yesterday) && isInYesterday {
            return GGUI.DateDisplayStrings.yesterday + " " + string(withFormat: "HH:mm")
        }
        if style.contains(.weekDay) && isInCurrentWeek {
            return (GGUI.DateDisplayStrings.weekdayMapString[weekday] ?? "") + " " + string(withFormat: "HH:mm")
        }
        return string(withFormat: "yyyy/MM/dd HH:mm")
    }

    var prettyDisplay: String {
        return display(style: [.today24, .yesterday, .weekDay])
    }
}

public extension Date {
    /// 将 HTTP Header 中的时间格式转换为 Date
    ///
    /// - Parameter dateString: let header = response.response?.allHeaderFields, let dateString = header["Date"] as? String
    /// - Returns: 转换好的 Date
    static func dateFromRFC1123(dateString: String) -> Date? {
        var date: Date?
        //RFC1123
        date = Date.RFC1123DateFormatter.date(from: dateString)
        if date != nil {
            return date
        }
        //RFC850
        date = Date.RFC850DateFormatter.date(from: dateString)
        if date != nil {
            return date
        }
        //asctime-date
        date = Date.asctimeDateFormatter.date(from: dateString)
        if date != nil {
            return date
        }
        return nil
    }

    private static var RFC1123DateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") //need locale for some iOS 9 verision, will not select correct default locale
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return dateFormatter
    }

    private static var RFC850DateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") //need locale for some iOS 9 verision, will not select correct default locale
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "EEEE, dd-MMM-yy HH:mm:ss z"
        return dateFormatter
    }

    private static var asctimeDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") //need locale for some iOS 9 verision, will not select correct default locale
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss yyyy"
        return dateFormatter
    }
}
