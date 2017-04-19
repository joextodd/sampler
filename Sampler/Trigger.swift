//
//  Trigger.swift
//  Sampler
//
//
import Cocoa

/*
 * Delegate trigger actions to View Controller
 */
protocol TriggerDelegate {
    func triggerSelected(t: Int)
}

/*
 * A Sample Trigger
 */
class Trigger: NSButton {
    
    var delegate:TriggerDelegate!
    
    convenience init(title: String,
                     target: Any?,
                     action: Selector?) {
        self.init(title: title, target: target, action: action)
        self.layer?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.8).CGColor
    }
    
    override func mouseDown(event: NSEvent) {
        sampler.playSound(self.tag)
        self.layer?.backgroundColor = NSColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.8).CGColor
    }
    
    override func mouseUp(event: NSEvent) {
        self.layer?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.8).CGColor
    }
    
    override func performKeyEquivalent(key: NSEvent) -> Bool {
        // TODO: Only play sound if allowable character
        sampler.playSound(self.tag)
        self.layer?.backgroundColor = NSColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.8).CGColor
        return super.performKeyEquivalent(key)
    }
    
    override func rightMouseDown(event: NSEvent) {
        delegate.triggerSelected(Int(self.tag))
    }
    
}