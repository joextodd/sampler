//
//  Sampler.swift
//  Sampler
//
//  Created by Joe Todd on 17/04/2017.
//  Copyright © 2017 Joe Todd. All rights reserved.
//
import AVFoundation

struct Sample {
    var note: UInt8
    var url: NSURL
    var path: String
    var sound: AVAudioPlayer
}

class Sampler
{
    var samples = [Sample]()
    
    init() {
        for _ in 0..<5 {
            samples.append(Sample(note: 0, url: NSURL(), path: "", sound: AVAudioPlayer()));
        }
    }
    
    func loadSound(s: Int, path: String)
    {
        samples[s].path = path
        samples[s].url = NSURL(string: path)!
        
        do {
            samples[s].sound = try AVAudioPlayer(contentsOfURL: samples[s].url)
            guard case samples[s].sound = samples[s].sound else { return }
            
            samples[s].sound.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playSound(s: Int)
    {        
        samples[s].sound.prepareToPlay()
        samples[s].sound.play()
    }
}