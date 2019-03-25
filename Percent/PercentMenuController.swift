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
        statusItem.button?.title = "Percentage"
        
        // Add CALayer if you like
        // Change subview of statusItem.button
        
        addTimersToMenu()
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    func addTimersToMenu() {
        let timers: [PercentType] = [PercentType.day, PercentType.month, PercentType.year]
        _ = timers.reversed().map{ addTimerView(type: $0) }
    }
    
    func addTimerView(type: PercentType) {
        let timerView = NSMenuItem(title: "percentAdded", action: nil, keyEquivalent: "")
        
        timerView.view = TimeView.init(period: type)
        statusMenu.insertItem(timerView, at: 0)
        
    }
}
