//
//  ViewController.swift
//  Sampler
//
//

import Cocoa

class ViewController: NSViewController {
    
    var midi = MIDI()
    var sampler = Sampler()
    
    @IBOutlet var midiSrc: NSPopUpButton!
    @IBOutlet var midiDest: NSPopUpButton!

    @IBOutlet var one: NSButton!
    @IBOutlet var two: NSButton!
    @IBOutlet var three: NSButton!
    @IBOutlet var four: NSButton!
    @IBOutlet var five: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.8).CGColor
        
        one.layer?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.8).CGColor
        
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
        
        sampler.loadSound(0, path: "/Users/joetodd/Music/Samples/Paramore/Kick.wav")
    }

    override var representedObject: AnyObject? {
        didSet {
            
        }
    }
    
    @IBAction func sourceSelected(sender: NSPopUpButtonCell)
    {
        midi.connectSrc(midiSrc.indexOfSelectedItem)
    }

    @IBAction func onePressed(sender: NSButton)
    {
        sampler.playSound(0)
    }

}

