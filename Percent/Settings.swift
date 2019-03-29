//
//  Settings.swift
//  Percent
//
//  Created by Jacob Gold on 29/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

//import Foundation
import Cocoa

class Settings {
    // Consider adding custom at some stage?
    enum PercentType: Int {
        case day = 0
        case month = 1
        case year = 2
        
        var description: String {
            switch self {
            case .day:
                return "Day"
            case .month:
                return "Month"
            case .year:
                return "Year"
            }
        }
        
        var percentValue: Int {
            switch self {
            case .day:
                return Percentage.getDayPercent()
            case .month:
                return Percentage.getMonthPercent()
            case .year:
                return Percentage.getYearPercent()
            }
        }
    }
    
    struct MenuDisplayItems: Codable {
        var progressBar: Bool
        var period: Bool
        var percent: Bool
        
        init(progressBar: Bool = true, period: Bool = false, percent: Bool = true) {
            self.progressBar = progressBar
            self.period = period
            self.percent = percent
            
            if (!self.progressBar && !self.period && !self.percent) { self.progressBar = true }
        }
        
        func menuBarString() -> NSMutableAttributedString {
            var attrstring: NSMutableAttributedString
            var string: String = ""
            let percentPeriod = Settings.loadMenuDisplayPeriod()
            var space = 6 // How much string to make transparent
            
            if progressBar { string += "%%%%.." }
            if (progressBar && (period || percent)) {
                string += "_"
                space += 1
            }
            if period  { string += "\(percentPeriod.description)" }
            if (period && percent) { string += ": " }
            if percent { string += "\(percentPeriod.percentValue)%" }
            
            attrstring = NSMutableAttributedString(string: string)
            if progressBar { attrstring.addAttribute(NSAttributedString.Key.foregroundColor,
                                                     value: NSColor.clear,
                                                     range: NSRange(location: 0, length: space)) }
            return attrstring
        }
    }
    
    // Saving and loading period to display in menu bar
    static func saveMenuDisplayPeriod(config: PercentType) {
        saveData(data: config.rawValue, key: "MenuDisplayPeriod")
    }
    
    static func loadMenuDisplayPeriod() -> PercentType {
        guard let data = loadData(key: "MenuDisplayPeriod", type: PercentType.RawValue.self) else {
            return Settings.PercentType.day
        }
        
        return Settings.PercentType.init(rawValue: data) ?? Settings.PercentType.day
    }
    
    // Saving and loading finer settings for System Menu title display option
    static func saveMenuDisplayTypeConfig(config: MenuDisplayItems) {
        let data: [Bool] = [config.progressBar, config.period, config.percent]
        saveData(data: data, key: "SystemMenuDisplayItemsConfig")
    }
    
    static func loadMenuDisplayTypeConfig() -> MenuDisplayItems {
        guard let data = loadData(key: "SystemMenuDisplayItemsConfig", type: [Bool].self) else {
            return Settings.MenuDisplayItems.init()
        }
        
        return Settings.MenuDisplayItems.init(progressBar: data[0], period: data[1], percent: data[2])
    }
    
    
    // Saving and loading master functions.
    fileprivate static func loadData<T>(key: String, type: T.Type) -> T? {
        guard let savedData = UserDefaults.standard.object(forKey: key) as? NSData else {
            print("Could not retrieve saved data: \(key)")
            return nil
        }
        
        guard let retrievedData = NSKeyedUnarchiver.unarchiveObject(with: savedData as Data) as? T else {
            print("Could not unarachive: \(key) data!")
            return nil
        }
        
        return retrievedData
    }
    
    // Catch all save function
    fileprivate static func saveData(data: Any, key: String) {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(savedData, forKey: key)
    }
}
