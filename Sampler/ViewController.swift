//
//  ViewController.swift
//  Sampler
//
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var midiSrc: NSPopUpButton!
    @IBOutlet var midiDest: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.8).CGColor
        
        midiSrc.removeAllItems()
        midiDest.removeAllItems()
        midiSrc.addItemsWithTitles(midi.getSourceNames())
        midiDest.addItemsWithTitles(midi.getDestinationNames())
        
        if midiSrc.numberOfItems == 0 {
            midiSrc.addItemWithTitle("No MIDI inputs available")
        }
        if midiDest.numberOfItems == 0 {
            midiDest.addItemWithTitle("No MIDI outputs available")
        }
    }

    override var representedObject: AnyObject? {
        didSet {
            
        }
    }
    
    @IBAction func sourceSelected(sender: NSPopUpButtonCell)
    {
        midi.connectSrc(midiSrc.indexOfSelectedItem)
    }

}


class Trigger: NSButton {
    
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
        sampler.playSound(self.tag)
        self.layer?.backgroundColor = NSColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.8).CGColor
        return super.performKeyEquivalent(key)
    }
    
    override func rightMouseDown(event: NSEvent) {
        let fileMenu = NSOpenPanel()
        fileMenu.allowsMultipleSelection = false
        fileMenu.canChooseDirectories = false
        fileMenu.canCreateDirectories = false
        fileMenu.allowedFileTypes = ["mp3", "wav", "aiff", "flac", "m4a"]

        let f = fileMenu.runModal()
        if (f == NSModalResponseOK) {
            sampler.setSound(self.tag, url: fileMenu.URL!)
            sampler.savePreset()
        }
    }
    
}