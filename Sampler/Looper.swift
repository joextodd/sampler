//
//  Looper.swift
//  Sampler
//
//
import Foundation

struct Event {
    var s: UInt8
    var ts: UInt64
}

struct Loop {
    var start: UInt64
    var end: UInt64
    var events: [Event]
    var queue: DispatchQueue
    
    mutating func addEvent(s: UInt8, ts: UInt64) {
        events.append(Event(s: s, ts: ts))
    }
}


class Looper
{
    var rows = [Loop]()
    
    init()
    {
        for _ in 0..<3 {
            rows.append(Loop(
                start: 0,
                end: 0,
                events: [],
                queue: DispatchQueue(label: "LooperQueue", qos: .userInteractive)
            ))
        }
    }
    
    func startLoop(_ r: Int)
    {
        rows[r].start = DispatchTime.now().uptimeNanoseconds
    }
    
    func endLoop(_ r: Int)
    {
        rows[r].end = DispatchTime.now().uptimeNanoseconds
        self.endOfLoop(r)
    }
    
    func endOfLoop(_ r: Int)
    {
        let now = DispatchTime.now().uptimeNanoseconds
        
        for event in rows[r].events {
            let ts = now + (event.ts - rows[r].start)
            sampler.queue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: ts)) {
                sampler.playSound(Int(event.s))
            }
        }
        
        let next = now + (rows[r].end - rows[r].start)
        rows[r].queue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: next)) {
            self.endOfLoop(r)
        }
    }
    
    func stopLoop(_ r: Int)
    {
        rows[r] = Loop(
            start: 0,
            end: 0,
            events: [],
            queue: DispatchQueue(label: "LooperQueue", qos: .userInteractive)
        )
    }
    
    func addEvent(_ s: UInt8)
    {
        let r = Int(s / 5)
        if rows[r].start != 0 {
            rows[r].addEvent(s: s, ts: DispatchTime.now().uptimeNanoseconds)
        }
    }
}
