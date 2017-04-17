//
//  MIDI.swift
//  Sampler
//
import CoreMIDI


class MIDI
{
    var midiClient: MIDIClientRef = 0
    var inPort:MIDIPortRef = 0
    var src:MIDIEndpointRef = MIDIGetSource(0)
    
    /*
     * Connect to MIDI source port
     */
    func connectSrc(n: Int) -> Void
    {
        let endpoint:MIDIEndpointRef = MIDIGetSource(n);
        print("Setting source to: \(getDisplayName(endpoint))")
        
        inPort = UInt32(n)
        src = MIDIGetSource(n)
        
        MIDIClientCreate("MIDIClient", nil, nil, &midiClient)
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
        
        if (packet.length > 3) {
            print("Error: Not yet implemented")
        }
        
        packet = MIDIPacketNext(&packet).memory
    }
}
