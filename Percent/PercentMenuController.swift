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
    var preferencesWindow: PreferencesWindow!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        statusItem.button?.title = "%"
        addPercentViewsToMenu()
        
        preferencesWindow = PreferencesWindow()
        
        setBarAsMenuTitle()
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    // Adding percentage stats to menu
    func addPercentViewsToMenu() {
        let timers: [Settings.PercentType] = [Settings.PercentType.day, Settings.PercentType.month, Settings.PercentType.year]
        _ = timers.reversed().map{ addPercentView(type: $0) }
    }
    
    func addPercentView(type: Settings.PercentType) {
        let timerView = NSMenuItem(title: "percentAdded", action: nil, keyEquivalent: "")
        
        timerView.view = PercentView.init(period: type)
        statusMenu.insertItem(timerView, at: 0)   
    }
    
    
    func setBarAsMenuTitle() {
        // Hacky solution to adding percent bar to menu, given how replacing view is deprecated
        let period = Settings.loadMenuDisplayPeriod()
        
        let title = Settings.loadMenuDisplayTypeConfig()
        statusItem.button?.attributedTitle = title.menuBarString()
        let menuButtonView = JCGGProgressBar.init(frame: CGRect(x: 0, y: 4, width: 60, height: 14))
        
        // Get what we need
        let progress = period.percentValue
        
        // Set our progress bar up and add it to the menu
        menuButtonView.progressValue = CGFloat(progress)
        menuButtonView.barThickness = 14
        statusItem.button?.addSubview(menuButtonView)
    }
}
