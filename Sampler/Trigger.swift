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
    func triggerSelected(_ t: Int)
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
        self.layer?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
    }
    
    override func mouseDown(with event: NSEvent) {
        sampler.playSound(self.tag)
        self.layer?.backgroundColor = NSColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.8).cgColor
    }
    
    override func mouseUp(with event: NSEvent) {
        self.layer?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
    }
    
    override func performKeyEquivalent(with key: NSEvent) -> Bool {
        if key.characters! == self.keyEquivalent {
            sampler.playSound(self.tag)
            self.layer?.backgroundColor = NSColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.8).cgColor
        }
        return super.performKeyEquivalent(with: key)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        delegate.triggerSelected(Int(self.tag))
    }
    
}
