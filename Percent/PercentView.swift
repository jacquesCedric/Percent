//
//  TimeView.swift
//  Percent
//
//  Created by Jacob Gold on 25/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

class PercentView: NSView {
    let progress: JCGGProgressBar = JCGGProgressBar.init(frame: CGRect(x: 0, y: 8, width: 40, height: 14))
    let label: NSTextField = NSTextField.init(labelWithString: "%%")
    let growthAmount:CGFloat = 20.0
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //or customized constructor/ init
    init(period: PercentType, isMenuItem: Bool = true) {
        // Setup dimensions
        // This can be static as we don't need to account for many cases
        let size = NSRect(x: 0, y: 0, width: 145, height: 24)
        
        super.init(frame: size)
        
        // Setup the progress bar
        progress.progressValue = CGFloat(getPercent(period: period))
        progress.barThickness = 14
        
        // Setup the percent label
        label.stringValue = getPercentLabel(period: period)
        label.frame = NSRect(x: 45, y: 0, width: 100, height: 24)
        label.font = NSFont.menuBarFont(ofSize: 0)
        label.backgroundColor = NSColor.clear
        
        // Add the views
        self.addSubview(progress)
        self.addSubview(label)
        
        // Helps with animation smoothness when hovering
        self.wantsLayer = true
        
        // Tracking Areas
        // Only works when a subview of NSMenuItem
        if (isMenuItem) {
            let mouseOverTrackingArea = NSTrackingArea.init(rect: size, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
            self.addTrackingArea(mouseOverTrackingArea)
        }
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
        NSAnimationContext.runAnimationGroup( { (context) -> Void in
            context.duration = 0.4
            progress.animator().frame.size.width += growthAmount
            label.animator().frame.origin.x += growthAmount
            label.animator().frame.size.width -= growthAmount
        })
    }
    
    override func mouseExited(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup( { (context) -> Void in
            context.duration = 0.4
            progress.animator().frame.size.width -= growthAmount
            label.animator().frame.origin.x -= growthAmount
            label.animator().frame.size.width += growthAmount
        })
    }
    
    override func mouseMoved(with event: NSEvent) {
        print("mouse moved over view")
    }
}
