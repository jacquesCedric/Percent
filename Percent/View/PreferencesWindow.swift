//
//  PreferencesWindow.swift
//  Preferences window creation, saving, loading, etc.
//
//  Created by Jacob Gold on 28/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {

    @IBOutlet weak var menuBarDisplayPeriod: NSSegmentedControl!
    @IBOutlet weak var menuBarDisplayItems: NSSegmentedControl!
    
    override var windowNibName: NSNib.Name? {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        loadPreferences()
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.orderedIndex = 0
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func loadPreferences() {
        let displayPeriodPrefs = Settings.loadMenuDisplayPeriod()
        let displayItemsPrefs = Settings.loadMenuDisplayTypeConfig()
        
        menuBarDisplayPeriod.selectedSegment = displayPeriodPrefs.rawValue
        menuBarDisplayItems.setSelected(displayItemsPrefs.progressBar, forSegment: 0)
        menuBarDisplayItems.setSelected(displayItemsPrefs.period, forSegment: 1)
        menuBarDisplayItems.setSelected(displayItemsPrefs.percent, forSegment: 2)
    }
    
    @IBAction func savePreferencesClicked(_ sender: Any) {
        if let displayPeriodPrefs = Settings.PercentType.init(rawValue: menuBarDisplayPeriod.selectedSegment) {
            Settings.saveMenuDisplayPeriod(config: displayPeriodPrefs)
        }
        let displayItemsPregs = Settings.MenuDisplayItems.init(progressBar: menuBarDisplayItems.isSelected(forSegment: 0),
                                                               period: menuBarDisplayItems.isSelected(forSegment: 1),
                                                               percent: menuBarDisplayItems.isSelected(forSegment: 2))
        Settings.saveMenuDisplayTypeConfig(config: displayItemsPregs)
        
        NotificationCenter.default.post(name: Notification.Name("PercentageAppPreferencesUpdated"), object: nil)
        self.close()
    }
    
}
