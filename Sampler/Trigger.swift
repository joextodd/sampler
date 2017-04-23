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
        self.image = NSImage(named: "TriggerOFF")
    }
    
    override func mouseDown(with event: NSEvent) {
        sampler.playSound(self.tag)
        self.image = NSImage(named: "TriggerON")
    }
    
    override func mouseUp(with event: NSEvent) {
        self.image = NSImage(named: "TriggerOFF")
    }
    
    override func performKeyEquivalent(with key: NSEvent) -> Bool {
        if key.characters! == self.keyEquivalent {
            sampler.playSound(self.tag)
        }
        return super.performKeyEquivalent(with: key)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        delegate.triggerSelected(Int(self.tag))
    }
    
}
