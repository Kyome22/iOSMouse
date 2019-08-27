//
//  ViewController.swift
//  iOSMouseMother
//
//  Created by Takuto Nakamura on 2019/08/27.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, BLEManagerDelegate {

    private let ble = BLEManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ble.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func push(_ sender: NSButton) {
        if sender.tag == 0 {
            ble.scan()
        } else {
            ble.stop()
        }
    }
    
    func updateData(_ data: Data) {
        let res = String(data: data, encoding: .utf8) ?? ""
        Swift.print(res)
        var location = NSEvent.mouseLocation
        for screen in NSScreen.screens {
            if screen.frame.contains(location) {
                location = CGPoint(x: location.x, y: NSHeight(screen.frame) - location.y)
                break
            }
        }
        switch res {
        case "leftDown":
            leftClickDown(position: location)
        case "rightDown":
            rightClickDown(position: location)
        case "leftUp":
            leftClickUp(position: location)
        case "rightUp":
            rightClickUp(position: location)
        default:
            let phi = CGFloat(Int(res) ?? 0) / 180 * CGFloat.pi
            let dx: CGFloat = 3.0 * cos(phi)
            let dy: CGFloat = 3.0 * sin(phi)
            moveMouse(dx: dx, dy: dy)
        }
    }
    
    // Left Side
    func leftClickDown(position: CGPoint) {
        let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let event = CGEvent(mouseEventSource: source, mouseType: CGEventType.leftMouseDown,
                            mouseCursorPosition: position, mouseButton: CGMouseButton.left)
        event?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func leftClickUp(position: CGPoint) {
        let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let event = CGEvent(mouseEventSource: source, mouseType: CGEventType.leftMouseUp,
                            mouseCursorPosition: position, mouseButton: CGMouseButton.left)
        event?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    // Right Side
    func rightClickDown(position: CGPoint) {
        let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let event = CGEvent(mouseEventSource: source, mouseType: CGEventType.rightMouseDown,
                            mouseCursorPosition: position, mouseButton: CGMouseButton.left)
        event?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    func rightClickUp(position: CGPoint) {
        let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let event = CGEvent(mouseEventSource: source, mouseType: CGEventType.rightMouseUp,
                            mouseCursorPosition: position, mouseButton: CGMouseButton.left)
        event?.post(tap: CGEventTapLocation.cghidEventTap)
    }

    // Move
    private func moveMouse(dx: CGFloat, dy: CGFloat) {
        let location = NSEvent.mouseLocation
        for screen in NSScreen.screens {
            if screen.frame.contains(location) {
                let pos = CGPoint(x: location.x + dx, y: NSHeight(screen.frame) - location.y + dy)
                CGDisplayMoveCursorToPoint(0, pos)
                break
            }
        }
    }

}
