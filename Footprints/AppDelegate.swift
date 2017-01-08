//
//  AppDelegate.swift
//  Footprints
//
//  Created by Andrey M on 03.01.17.
//  Copyright © 2017 Andrey M. All rights reserved.
//

import Cocoa
import SwiftKVC

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var viewController: NSViewController!
    @IBOutlet weak var leftClicksField: NSTextField!
    @IBOutlet weak var rightClicksField: NSTextField!
    @IBOutlet weak var keysPressedField: NSTextField!
    @IBOutlet weak var distanceField: NSTextField!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var popoverMonitor: EventMonitor?
    var eventMonitor: EventMonitor?
    
    var counter = Counter()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.title = "👣"
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        popover.contentViewController = viewController
        
        popoverMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) {event in
            if self.popover.isShown {
                self.closePopover(event)
            }
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown, .keyDown, .mouseMoved, .flagsChanged]) {event in
            self.countEvents(event)
        }
        eventMonitor?.start()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        if (eventMonitor != nil) {
            eventMonitor?.stop()
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
            switch event.type {
            case NSEventType.leftMouseDown:
                counter.addLeftClick(1)
                leftClicksField.intValue = Int32(counter.mouseClicks.left)
            case NSEventType.rightMouseDown:
                counter.addRightClick(1)
                rightClicksField.intValue = Int32(counter.mouseClicks.right)
            case NSEventType.keyDown:
                counter.addKeysPress(1.0)
                keysPressedField.intValue = Int32(counter.keysPressed)
            case NSEventType.flagsChanged:
                counter.addKeysPress(0.5)
                keysPressedField.intValue = Int32(counter.keysPressed)
            case NSEventType.mouseMoved:
                counter.travelMouse(to: event.locationInWindow)
                distanceField.stringValue = String(format: "%.1f m", counter.mouseDistance)
                
            default: break
            }
        }
    }
}

