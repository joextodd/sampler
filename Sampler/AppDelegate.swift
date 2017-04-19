//
//  AppDelegate.swift
//  Sampler
//
//  Created by Joe Todd on 17/04/2017.
//  Copyright © 2017 Joe Todd. All rights reserved.
//

import Cocoa
import CoreMIDI

var midi = MIDI()
var sampler = Sampler()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        print("Sampler")
        print("------------------")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        print("Bye!")
    }

}
