//
//  ViewController.swift
//  Sampler
//
//
import Cocoa


class ViewController: NSViewController, TriggerDelegate {
    
    var selectedTrigger: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        
        midiSrc.removeAllItems()
        midiDest.removeAllItems()
        midiSrc.addItems(withTitles: midi.getSourceNames())
        midiDest.addItems(withTitles: midi.getDestinationNames())
        
        if midiSrc.numberOfItems == 0 {
            midiSrc.addItem(withTitle: "No MIDI inputs available")
        }
        if midiDest.numberOfItems == 0 {
            midiDest.addItem(withTitle: "No MIDI outputs available")
        }
        
        triggerVelocity.minValue = 0
        triggerVelocity.maxValue = 128
        
        setTriggerDelegates()
    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
    
    @IBAction func sourceSelected(_ sender: NSPopUpButton)
    {
        midi.connectSrc(midiSrc.indexOfSelectedItem)
    }
    
    @IBAction func destSelected(_ sender: NSPopUpButton)
    {
        midi.connectDest(midiDest.indexOfSelectedItem)
    }
    
    @IBAction func backPreset(_ sender: NSButton)
    {
        selectedTrigger = selectedTrigger == 0 ? 255 : selectedTrigger - 1
        sampler.loadPreset(selectedTrigger)
        preset.title = String(selectedTrigger)
    }
    
    @IBAction func nextPreset(_ sender: NSButton)
    {
        selectedTrigger = (selectedTrigger + 1) % 256
        sampler.loadPreset(selectedTrigger)
        preset.title = String(selectedTrigger)
    }
    
    @IBAction func clearPreset(_ sender: NSButton)
    {
        sampler.clearPreset(selectedTrigger)
    }
    
    @IBAction func selectFile(_ sender: NSButton)
    {
        let fileMenu = NSOpenPanel()
        fileMenu.allowsMultipleSelection = false
        fileMenu.canChooseDirectories = false
        fileMenu.canCreateDirectories = false
        fileMenu.allowedFileTypes = ["mp3", "wav", "aiff", "flac", "m4a"]
        
        let f = fileMenu.runModal()
        if (f == NSModalResponseOK) {
            sampler.setSound(selectedTrigger, path: fileMenu.url!.path)
            sampler.savePreset(Int(preset.title)!)
        }
    }
    
    @IBAction func changeVelocity(_ sender: NSSlider)
    {
        sampler.setVelocity(selectedTrigger, velocity: UInt8(sender.floatValue))
        sampler.savePreset(Int(preset.title)!)
    }
    
    func triggerSelected(_ t: Int) {
        selectedTrigger = t
        triggerNo.title = String(t)
        triggerVelocity.floatValue = Float(sampler.getVelocity(selectedTrigger))
    }
    
    @IBAction func startZeroLoop(_ sender: NSButton) { looper.startLoop(0) }
    @IBAction func loopZeroLoop(_ sender: NSButton) { looper.endLoop(0) }
    @IBAction func stopZeroLoop(_ sender: NSButton) { looper.stopLoop(0) }

    @IBOutlet var t1: Trigger!
    @IBOutlet var t2: Trigger!
    @IBOutlet var t3: Trigger!
    @IBOutlet var t4: Trigger!
    @IBOutlet var t5: Trigger!
    @IBOutlet var t6: Trigger!
    @IBOutlet var t7: Trigger!
    @IBOutlet var t8: Trigger!
    @IBOutlet var t9: Trigger!
    @IBOutlet var t10: Trigger!
    @IBOutlet var t11: Trigger!
    @IBOutlet var t12: Trigger!
    @IBOutlet var t13: Trigger!
    @IBOutlet var t14: Trigger!
    @IBOutlet var t15: Trigger!
    
    @IBOutlet var presetBack: NSButton!
    @IBOutlet var preset: NSButton!
    @IBOutlet var presetNext: NSButton!
    @IBOutlet var presetClear: NSButton!

    @IBOutlet var midiSrc: NSPopUpButton!
    @IBOutlet var midiDest: NSPopUpButton!
    
    @IBOutlet var triggerNo: NSButton!
    @IBOutlet var triggerMidi: NSButton!
    @IBOutlet var triggerFile: NSButton!
    @IBOutlet var triggerVelocity: NSSlider!
    
    @IBOutlet var startZero: NSButton!
    @IBOutlet var loopZero: NSButton!
    @IBOutlet var endZero: NSButton!
    
    func setTriggerDelegates()
    {
        t1.delegate = self; t2.delegate = self; t3.delegate = self; t4.delegate = self
        t5.delegate = self; t6.delegate = self; t7.delegate = self; t8.delegate = self
        t9.delegate = self; t10.delegate = self; t11.delegate = self; t12.delegate = self
        t13.delegate = self; t14.delegate = self; t15.delegate = self
    }
    
}
