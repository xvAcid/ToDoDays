//
//  Date+Formatters.swift
//  ToDoDays
//
//  Created by xvacid on 19/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import Foundation

public extension Date {
    func stringMonth() -> String {
        let df          = DateFormatter()
        df.locale       = Locale(identifier: "ru_RU")
        df.dateFormat   = "LLLL"
        return df.string(from: self)
    }
    
    func stringDayAndMonth() -> String {
        let df          = DateFormatter()
        df.locale       = Locale(identifier: "ru_RU")
        df.dateFormat   = "dd MMMM"
        return df.string(from: self)
    }
    
    func stringMonthAndYear() -> String {
        let df          = DateFormatter()
        df.locale       = Locale(identifier: "ru_RU")
        df.dateFormat   = "MMMM YYYY"
        return df.string(from: self)
    }
    
    func stringDayMonthAndYear() -> String {
        let df          = DateFormatter()
        df.locale       = Locale(identifier: "ru_RU")
        df.dateFormat   = "dd.MM.YYYY"
        return df.string(from: self)
    }
    
    func stringDayMonthYearWithTime() -> String {
        let df          = DateFormatter()
        df.locale       = Locale(identifier: "ru_RU")
        df.dateFormat   = "dd MMMM YYYY, HH:mm"
        return df.string(from: self)
    }
    
    func stringTime() -> String {
        let df        = DateFormatter()
        df.locale     = Locale.current
        df.timeZone   = TimeZone.current
        df.dateFormat = "HH:mm"
        return df.string(from: self)
    }
    
    func stringShortDay() -> String {
        let df        = DateFormatter()
        df.locale     = Locale.current
        df.timeZone   = TimeZone.current
        df.dateFormat = "EEE"
        let result    = df.string(from: self)
        return result.prefix(1).capitalized + result.dropFirst()
    }
    
    func getCurrentWeekDay() -> Int {
        var calendar        = Calendar.current
        calendar.timeZone   = .current
        calendar.locale     = Locale.current
        let currentWeekday  = calendar.component(.weekday, from: self)
        return currentWeekday
    }
    
    func next(_ weekday: Int, considerToday: Bool = false) -> Date {
        var calendar        = Calendar.current
        var components      = DateComponents(weekday: weekday)
        calendar.timeZone   = .current
        components.timeZone = .current
        calendar.locale     = Locale.current
        let currentWeekday  = calendar.component(.weekday, from: self)
        let direction       = weekday < currentWeekday ? Calendar.SearchDirection.backward : Calendar.SearchDirection.forward
        
        if considerToday && currentWeekday == weekday {
            return self
        }
        
        return calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime, direction: direction)!
    }
    
    static func round(date: Date, for minuteInterval: Int) -> Date {
        var calendar            = Calendar.current
        calendar.timeZone       = .current
        calendar.locale         = Locale.current
        var dateComponents      = calendar.dateComponents([.minute], from: date)
        dateComponents.timeZone = .current

        let minutes = dateComponents.minute!
        
        let intervalRemainder = Double(minutes).truncatingRemainder(
            dividingBy: Double(minuteInterval)
        )
        
        let halfInterval = Double(minuteInterval) / 2.0
        
        let roundingAmount: Int
        if  intervalRemainder > halfInterval {
            roundingAmount = minuteInterval
        } else {
            roundingAmount = 0
        }
        
        let minutesRounded = minutes / minuteInterval * minuteInterval
        let timeInterval = TimeInterval(
            60 * (minutesRounded + roundingAmount - minutes)
        )
        
        let roundedDate       = Date(timeInterval: timeInterval, since: date)
        dateComponents        = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: roundedDate)
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
    
    func checkIntersect(start: Date, end: Date) -> Bool {
        let currentInterval = self.timeIntervalSince1970
        let startInterval   = start.timeIntervalSince1970
        let endInterval     = end.timeIntervalSince1970
        if startInterval <= currentInterval && currentInterval <= endInterval {
            return true
        }
        
        return false
    }
}

