//
//  Percentage.swift
//  Nice functions that help us get percentage.
//
//  Created by Jacob Gold on 25/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Foundation


class Percentage {
    static func getHourPercent() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        
        let percent = Int(100 * (Float(minutes) / 60.00))
        return percent
    }
    
    static func getDayPercent() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let totalMinutes = (hours * 60) + minutes
        let percent = Int(100 * (Float(totalMinutes) / 1440.00))
        
        return percent
    }
    
    static func getMonthPercent() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let days = calendar.component(.day, from: date)
        let totalDaysForMonth: Float = Float(calendar.range(of: .day, in: .month, for: date)?.count ?? 1)
        
        let percent = Int(100 * (Float(days) / totalDaysForMonth))
        return percent
    }
    
    static func getYearPercent() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let days: Int = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
        let totalDaysForYear: Float = Float(calendar.range(of: .day, in: .year, for: date)?.count ?? 365)
        
        let percent = Int(100 * (Float(days) / totalDaysForYear))
        return percent
    }    
}
