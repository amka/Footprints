//
//  EventMonitor.swift
//  Footprints
//
//  Created by Andrey M on 05.01.17.
//  Copyright © 2017 Andrey M. All rights reserved.
//

import Foundation
import Cocoa

class LocalMonitor {
    
    fileprivate var monitor: AnyObject?
    fileprivate let mask: NSEventMask
    fileprivate let handler: (NSEvent?) -> NSEvent?
    
    public init (mask: NSEventMask, handler: @escaping (NSEvent?) -> NSEvent?) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    open func start() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: handler) as AnyObject?
    }
    
    open func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
