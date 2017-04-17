//
//  MIDI.swift
//  Sampler
//
import CoreMIDI


class MIDI
{
    var midiClient: MIDIClientRef
    var inPort:MIDIPortRef
    var src:MIDIEndpointRef
    
    /*
     * Initialise MIDI client
     */
    init()
    {
        print("Setting up MIDI")
        
        midiClient = 0
        inPort = 0
        src = MIDIGetSource(0)
        MIDIClientCreate("MIDIClient", nil, nil, &midiClient)
        
        
        print("------------------")
    }
    
    /*
     * Connect to MIDI source port
     */
    func connectSrc(n: Int) -> Void
    {
        let endpoint:MIDIEndpointRef = MIDIGetSource(n);
        print("Setting source to: \(getDisplayName(endpoint))")
        
        inPort = UInt32(n)
        src = MIDIGetSource(n)
        
        MIDIInputPortCreate(midiClient, "MIDIInPort", MIDIReadCallback, nil, &inPort)
        MIDIPortConnectSource(inPort, src, &src)
    }
    
    /*
     * Get display name of MIDI reference
     */
    func getDisplayName(obj: MIDIObjectRef) -> String
    {
        var param: Unmanaged<CFString>?
        var name: String = "Error"
        
        let err: OSStatus = MIDIObjectGetStringProperty(obj, kMIDIPropertyDisplayName, &param)
        if err == OSStatus(noErr)
        {
            name =  param!.takeRetainedValue() as String
        }
        
        return name
    }
    
    /*
     * Returns available MIDI destination names.
     */
    func getDestinationNames() -> [String]
    {
        var names:[String] = [];
        
        let count: Int = MIDIGetNumberOfDestinations();
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetDestination(i);
            
            if (endpoint != 0)
            {
                names.append(getDisplayName(endpoint));
            }
        }
        return names;
    }
    
    /*
     * Prints available MIDI destinations to console.
     */
    func printDestinations()
    {
        let destNames = getDestinationNames()
        
        print("Number of MIDI Destinations: \(destNames.count)")
        for destName in destNames
        {
            print("  Destination: \(destName)")
        }
        
        print("------------------")
    }
    
    /*
     * Returns available MIDI source names.
     */
    func getSourceNames() -> [String]
    {
        var names:[String] = [];
        
        let count: Int = MIDIGetNumberOfSources();
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetSource(i);
            if (endpoint != 0)
            {
                names.append(getDisplayName(endpoint));
            }
        }
        return names;
    }
    
    /*
     * Prints available MIDI sources to console.
     */
    func printSources()
    {
        let sourceNames = getSourceNames()
        
        print("Number of MIDI Sources: \(sourceNames.count)")
        for sourceName in sourceNames
        {
            print("  Source: \(sourceName)")
        }
        
        print("------------------")
    }
    
}

/*
 * C style callback to handle MIDI input packets.
 */
func MIDIReadCallback(pktList: UnsafePointer<MIDIPacketList>,
                      readProcRefCon: UnsafeMutablePointer<Void>,
                      srcConnRefCon: UnsafeMutablePointer<Void>) -> Void
{
    let packetList:MIDIPacketList = pktList.memory
    
    var packet:MIDIPacket = packetList.packet
    for _ in 1...packetList.numPackets
    {
        let cmd = packet.data.0
        let note = packet.data.1
        let velocity = packet.data.2
        
        if ((cmd & 240) == 144)  {
            print(note, velocity)
        }
        
        packet = MIDIPacketNext(&packet).memory
    }
}
