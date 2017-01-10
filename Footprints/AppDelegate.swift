//
//  AppDelegate.swift
//  Footprints
//
//  Created by Andrey M on 03.01.17.
//  Copyright © 2017 Andrey M. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var viewController: NSViewController!
    @IBOutlet weak var leftClicksField: NSTextField!
    @IBOutlet weak var rightClicksField: NSTextField!
    @IBOutlet weak var keysPressedField: NSTextField!
    @IBOutlet weak var distanceField: NSTextField!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var popoverMonitor: GlobalMonitor?
    var globalMonitor: GlobalMonitor?
    var localMonitor: LocalMonitor?
    
    var counter = Counter()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: "MenuBar")
            button.alternateImage = NSImage(named: "MenuBarAlt")
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        popover.contentViewController = viewController
        
        popoverMonitor = GlobalMonitor(mask: [.leftMouseDown, .rightMouseDown]) {event in
            if self.popover.isShown {
                self.closePopover(event)
            }
        }
        
        globalMonitor = GlobalMonitor(mask: [.leftMouseDown, .rightMouseDown, .keyDown, .mouseMoved, .flagsChanged]) {event in
            self.countEvents(event)
        }
        globalMonitor?.start()

        localMonitor = LocalMonitor(mask: [.leftMouseDown, .rightMouseDown, .keyDown, .mouseMoved, .flagsChanged]) {event in
            return self.countLocalEvents(event)
        }
        localMonitor?.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        if (globalMonitor != nil) {
            globalMonitor?.stop()
        }
        
        if (popoverMonitor != nil) {
            popoverMonitor?.stop()
        }
        
        if (localMonitor != nil) {
            localMonitor?.stop()
        }
    }

    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        popoverMonitor?.start()
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        popoverMonitor?.stop()
    }
    
    func countEvents(_ sender: AnyObject?) {
        if (sender != nil) {
            let event = sender as! NSEvent
            counter.countEvent(event)
            keysPressedField.intValue = Int32(counter.keysPressed)
            leftClicksField.intValue = Int32(counter.mouseClicks.left)
            rightClicksField.intValue = Int32(counter.mouseClicks.right)
            distanceField.stringValue = String(format: "%.1f m", counter.mouseDistance)
        }
    }
    
    func countLocalEvents(_ sender: AnyObject?) -> NSEvent? {
        if (sender != nil) {
            let event = sender as! NSEvent
            counter.countEvent(event)
            keysPressedField.intValue = Int32(counter.keysPressed)
            leftClicksField.intValue = Int32(counter.mouseClicks.left)
            rightClicksField.intValue = Int32(counter.mouseClicks.right)
            distanceField.stringValue = String(format: "%.1f m", counter.mouseDistance)
        }
        return sender as? NSEvent
    }
}

