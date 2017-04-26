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
        let note = sampler.samples[self.tag].note
        looper.addEvent(UInt8(self.tag))
        midi.queue.async {
            midi.playNote(note: note, velocity: 100)
        }
        sampler.queue.async {
            sampler.playSound(self.tag)
        }
        self.image = NSImage(named: "TriggerON")
    }
    
    override func mouseUp(with event: NSEvent) {
        let note = sampler.samples[self.tag].note
        midi.queue.async {
            midi.playNote(note: note, velocity: 0)
        }
        self.image = NSImage(named: "TriggerOFF")
    }
    
    override func performKeyEquivalent(with key: NSEvent) -> Bool {
        if key.characters! == self.keyEquivalent {
            let note = sampler.samples[self.tag].note
            looper.addEvent(UInt8(self.tag))
            midi.queue.async {
                midi.playNote(note: note, velocity: 100)
            }
            sampler.queue.async {
                sampler.playSound(self.tag)
            }
            midi.queue.asyncAfter(deadline: .now() + 0.5) {
                midi.playNote(note: note, velocity: 0)
            }
        }
        return super.performKeyEquivalent(with: key)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        delegate.triggerSelected(Int(self.tag))
    }
    
}
