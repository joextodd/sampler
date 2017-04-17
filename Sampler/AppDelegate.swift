//
//  AppDelegate.swift
//  Sampler
//
//  Created by Joe Todd on 17/04/2017.
//  Copyright © 2017 Joe Todd. All rights reserved.
//

import Cocoa
import CoreMIDI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        print("Sampler")
        print("------------------")
        
        let midi = MIDI()
        midi.printSources()
        midi.connectSrc(4)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

}
