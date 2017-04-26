//
//  MIDI.swift
//  Sampler
//
import CoreMIDI


class MIDI
{
    // TODO: Dispatch event to light trigger on MIDI IN
    
    var channel = 1
    var midiClient: MIDIClientRef = 0
    var inPort:MIDIPortRef = 0
    var outPort:MIDIPortRef = 0
    var src:MIDIEndpointRef = MIDIGetSource(0)
    var dst:MIDIEndpointRef = MIDIGetDestination(0)
    var queue = DispatchQueue(label: "MIDIQueue", qos: .userInitiated)
    
    init()
    {
        MIDIClientCreate("MIDIClient" as CFString, nil, nil, &midiClient)
    }
    
    /*
     * Connect to MIDI source port
     */
    func connectSrc(_ n: Int)
    {
        let endpoint:MIDIEndpointRef = MIDIGetSource(n);
        print("Setting source to: \(getDisplayName(endpoint))")
        
        inPort = UInt32(n)
        src = MIDIGetSource(n)
        
        MIDIInputPortCreate(midiClient, "MIDIInPort" as CFString, MIDIReadCallback, nil, &inPort)
        MIDIPortConnectSource(inPort, src, &src)
    }
    
    /*
     * Connect to MIDI destination port
     */
    func connectDest(_ n: Int)
    {
        let endpoint:MIDIEndpointRef = MIDIGetDestination(n)
        print("Setting destination to: \(getDisplayName(endpoint))")
        
        outPort = UInt32(n)
        dst = MIDIGetDestination(n)
        
        MIDIOutputPortCreate(midiClient, "MIDIOutPort" as CFString, &outPort)
    }
    
    /*
     * Get display name of MIDI reference
     */
    func getDisplayName(_ obj: MIDIObjectRef) -> String
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
        var names:[String] = []
        
        let count: Int = MIDIGetNumberOfDestinations()
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetDestination(i)
            
            if (endpoint != 0)
            {
                names.append(getDisplayName(endpoint))
            }
        }
        return names;
    }
    
    /*
     * Returns available MIDI source names.
     */
    func getSourceNames() -> [String]
    {
        var names:[String] = []
        
        let count: Int = MIDIGetNumberOfSources()
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetSource(i)
            if (endpoint != 0)
            {
                names.append(getDisplayName(endpoint))
            }
        }
        return names;
    }
    
    /*
     * Send MIDI note to destination.
     */
    func playNote(note: UInt8, velocity: UInt8)
    {
        var packet:MIDIPacket = MIDIPacket()
        packet.timeStamp = 0
        packet.length = 1
        
        let cmd = velocity > 0 ? 0x90 : 0x80
        packet.data.0 = UInt8(cmd + (channel - 1))
        packet.data.1 = note
        packet.data.2 = velocity
        
        var packetList:MIDIPacketList = MIDIPacketList(numPackets: 1, packet: packet)
        MIDISend(outPort, dst, &packetList)
    }
}


/*
 * Callback to handle MIDI input packets.
 */
func MIDIReadCallback(pktList: UnsafePointer<MIDIPacketList>,
                      readProcRefCon: UnsafeMutableRawPointer?,
                      srcConnRefCon: UnsafeMutableRawPointer?) -> Void
{
    let packetList:MIDIPacketList = pktList.pointee
    
    var packet:MIDIPacket = packetList.packet
    for _ in 1...packetList.numPackets
    {
        let cmd = packet.data.0
        let note = packet.data.1
        let velocity = packet.data.2
        
        if (cmd & 0xF0) == 0x90 {
            if velocity > 0 {
                sampler.queue.async {
                    sampler.playNote(note)
                }
            }
        }
        
        if (packet.length > 3) {
            print("Error: Not yet implemented")
        }
        
        packet = MIDIPacketNext(&packet).pointee
    }
}
