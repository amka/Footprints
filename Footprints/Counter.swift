//
//  Counter.swift
//  Footprints
//
//  Created by Andrey M on 08.01.17.
//  Copyright © 2017 Andrey M. All rights reserved.
//

import Cocoa

struct MouseClicks {
    var left = 0, right = 0
}

class Counter {
    
    var wRatio = Double()
    var hRatio = Double()
    fileprivate var prevPoint : NSPoint?
    
    fileprivate var _mouseClicks = MouseClicks()
    fileprivate var _keysPressed : Float = 0.0
    fileprivate var _mouseDistance : Double = 0.0
    
    var mouseClicks : MouseClicks {
        return _mouseClicks
    }
    
    var mouseDistance : Double {
        return _mouseDistance
    }
    
    var keysPressed : Int {
        return Int(_keysPressed)
    }
    
    func addLeftClick(_ count: Int) {
        _mouseClicks.left += count
    }
    
    func addRightClick(_ count: Int) {
        _mouseClicks.right += count
    }
    
    /**
     Increment keys pressed value by given count
     
     - parameters:
        - count: increment keys pressed value by count
     */
    func addKeysPress(_ count: Float) {
        _keysPressed += count
    }
    
    init() {
        getScreenDimensions()
    }
    
    fileprivate func getScreenDimensions() {
        let screenDesc = NSScreen.main()?.deviceDescription
        let displayPixelSize = screenDesc?["NSDeviceSize"] as! NSSize
        let displayPhysicalSize = CGDisplayScreenSize(screenDesc?["NSScreenNumber"]! as! CGDirectDisplayID)
        wRatio = Double(displayPhysicalSize.width) / Double(displayPixelSize.width)
        hRatio = Double(displayPhysicalSize.height) / Double(displayPixelSize.height)
    }
    
    /**
     Calculate distance travelled by mouse pointer over screen.
     
     - parameters:
        - point: NSPoint which mouse pointer travelled to
     */
    func travelMouse(to point: NSPoint) {
        if (prevPoint != nil) {
            let distance = (pow(wRatio * Double(point.x - prevPoint!.x), 2) +
                pow(hRatio * Double(point.y - prevPoint!.y), 2)).squareRoot()
            _mouseDistance += distance / 1000.0
        }
        prevPoint = point
    }
}
