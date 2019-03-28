//
//  PercentMenuController.swift
//  Percent
//
//  Created by Jacob Gold on 24/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

class PercentMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        statusItem.button?.title = "%"
        addPercentViewsToMenu()
        
        setBarAsMenuTitle(period: PercentType.day)
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    // Adding percentage stats to menu
    func addPercentViewsToMenu() {
        let timers: [PercentType] = [PercentType.day, PercentType.month, PercentType.year]
        _ = timers.reversed().map{ addPercentView(type: $0) }
    }
    
    func addPercentView(type: PercentType) {
        let timerView = NSMenuItem(title: "percentAdded", action: nil, keyEquivalent: "")
        
        timerView.view = PercentView.init(period: type)
        statusMenu.insertItem(timerView, at: 0)   
    }
    
    
    func setBarAsMenuTitle(period: PercentType) {
        // Hacky solution to adding percent bar to menu, given how replacing view is deprecated
        // Set invisible text of right length for a bar
        statusItem.button?.attributedTitle = NSAttributedString.init(string: "%%%%..",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: NSColor.clear])
        let menuButtonView = JCGGProgressBar.init(frame: CGRect(x: 0, y: 4, width: 60, height: 14))
        
        // Get what we need
        var progress = 0
        switch(period) {
        case .day:
            progress = Percentage.getDayPercent()
        case .month:
            progress = Percentage.getMonthPercent()
        case .year:
            progress = Percentage.getYearPercent()
        }
        
        // Set our progress bar up and add it to the menu
        menuButtonView.progressValue = CGFloat(progress)
        menuButtonView.barThickness = 14
        statusItem.button?.addSubview(menuButtonView)
    }
}
