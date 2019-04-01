//
//  TimeView.swift
//  The view that exists to show percent of whatever period in NSMenuItem
//
//  Created by Jacob Gold on 25/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

class PercentView: NSView {
    // UI elements declared here as they are updated over time
    let progress: JCGGProgressBar = JCGGProgressBar.init(frame: CGRect(x: 0, y: 6, width: 40, height: 14))
    let label: NSTextField = NSTextField.init(labelWithString: "%%")
    
    // Amount by which percent bar scales when hovered over
    let growthAmount: CGFloat = 20.0
    
    // Percent type for this view
    var percentPeriod: Settings.PercentType = .day
    
    // For updating
    var timer = Timer()
    
    // Required inits
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // What we like
    // Is isMenuItem parameter necessary?
    init(period: Settings.PercentType, isMenuItem: Bool = true) {
        // Assign PercentType for view
        percentPeriod = period
        
        // Setup dimensions
        // This can be static as we don't need to account for variations
        let size = NSRect(x: 0, y: 0, width: 145, height: 24)
        
        super.init(frame: size)
        
        // Setup the progress bar
        progress.barThickness = 14
        
        // Setup the percent label
        label.frame = NSRect(x: 45, y: 0, width: 100, height: 22)
        label.font = NSFont.menuBarFont(ofSize: 0)
        label.backgroundColor = NSColor.clear
        
        updatePercent()
        
        // Add the views
        self.addSubview(progress)
        self.addSubview(label)
        
        // Helps with animation smoothness when hovering
        self.wantsLayer = true
        
        // Tracking Areas
        // Only works when a subview of NSMenuItem
        // Is this necessary?
        if (isMenuItem) {
            let mouseOverTrackingArea = NSTrackingArea.init(rect: size, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
            self.addTrackingArea(mouseOverTrackingArea)
        }
        
        var interval: TimeInterval = 60
        switch(percentPeriod) {
        case .day:
            interval = 864 // approx 1% of a day
        case .month:
            interval = 26000 // approx 1% of a 29 days
        case .year:
            interval = 315000 // approx 1% of a 365 days
        }
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updatePercent), userInfo: nil, repeats: true)
        timer.tolerance = 1.0
    }
    
    @objc func updatePercent() {
        let percent = percentPeriod.percentValue
        
        progress.progressValue = CGFloat(percent)
        label.stringValue = getPercentLabel(percentage: percent)
    }
    
    // How we populate our percent strings
    private func getPercentLabel(percentage: Int) -> String {
        let period = percentPeriod.description
        return "\(period): \(percentage)%"
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
}
