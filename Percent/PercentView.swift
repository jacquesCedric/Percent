//
//  TimeView.swift
//  Percent
//
//  Created by Jacob Gold on 25/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

class PercentView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //or customized constructor/ init
    init(period: PercentType) {
        // Setup dimensions
        // This can be static as we don't need to account for many cases
        let size = NSRect(x: 0, y: 0, width: 145, height: 24)
        
        super.init(frame: size)
        
        // Setup the progress bar
        let progress: JCGGProgressBar = JCGGProgressBar.init(frame: CGRect(x: 0, y: 8, width: 40, height: 14))
        progress.progressValue = CGFloat(getPercent(period: period))
        progress.barThickness = 14
        
        // Setup the percent label
        let label: NSTextField = NSTextField.init(labelWithString: getPercentLabel(period: period))
        label.frame = NSRect(x: 45, y: 0, width: 100, height: 24)
        label.font = NSFont.menuBarFont(ofSize: 0)
        
        // Add the views
        self.addSubview(progress)
        self.addSubview(label)
        
        // Two trakcing areas as otherwise we encounter some strange bugs
        let mouseOverTrackingArea = NSTrackingArea.init(rect: size, options: [.activeAlways, .mouseMoved], owner: self, userInfo: nil)
        let mouseOverTrackingArea2 = NSTrackingArea.init(rect: size, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        self.addTrackingArea(mouseOverTrackingArea)
        self.addTrackingArea(mouseOverTrackingArea2)
    }
    
    // Get the percent for whatever period
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
    
    // How we populate our percent strings
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
    
    // Mouse tracking events
    override func mouseEntered(with event: NSEvent) {
        print("help")
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    override func mouseMoved(with event: NSEvent) {
        print("mouse moved over view")
    }
}
