//
//  main.swift
//  Sampler
//
//
import CoreMIDI

let destNames = getDestinationNames()
print("Number of MIDI Destinations: \(destNames.count)");
for destName in destNames
{
    print("  Destination: \(destName)");
}

let sourceNames = getSourceNames();

print("\nNumber of MIDI Sources: \(sourceNames.count)");
for sourceName in sourceNames
{
    print("  Source: \(sourceName)");
}


var midiClient: MIDIClientRef = 0;
var inPort:MIDIPortRef = 0;
var src:MIDIEndpointRef = MIDIGetSource(0);

MIDIClientCreate("MIDIClient", nil, nil, &midiClient);
MIDIInputPortCreate(midiClient, "MIDIInPort", MIDIReadCallback, nil, &inPort);

MIDIPortConnectSource(inPort, src, &src);