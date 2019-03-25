//
//  TimeView.swift
//  Percent
//
//  Created by Jacob Gold on 25/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

class TimeView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //or customized constructor/ init
    init(period: PercentType) {
        let size = NSRect(x: 0, y: 0, width: 200, height: 24)
        
        super.init(frame: size)
        
        let progress: JCGGProgressBar = JCGGProgressBar.init(frame: CGRect(x: 0, y: 4, width: 80, height: 16))
        progress.progressValue = CGFloat(getPercent(period: period))
        
        let label: NSTextField = NSTextField.init(labelWithString: getPercentLabel(period: period))
        label.frame = NSRect(x: 85, y: 0, width: 115, height: 24)
        label.font = NSFont.systemFont(ofSize: 14)
        
        self.addSubview(progress)
        self.addSubview(label)
    }
    
    func getPercent(period: PercentType) -> Int {
        switch(period) {
        case .day:
            return Percentage.getDayPercent()
        case .month:
            return Percentage.getMonthPercent()
        case .year:
            return Percentage.getYearPercent()
        }
    }
    
    func getPercentLabel(period: PercentType) -> String {
        switch(period) {
        case .day:
            return "Day: \(getPercent(period: period))%"
        case .month:
            return "Month: \(getPercent(period: period))%"
        case .year:
            return "Year: \(getPercent(period: period))%"
        }
    }
}
