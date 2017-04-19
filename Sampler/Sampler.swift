//
//  Sampler.swift
//  Sampler
//
//
import AVFoundation

// TODO: Fix multiple sounds on one trigger

struct Sample {
    var note: UInt8
    var url: NSURL
    var path: String
    var velocity: Int
    var sound: AVAudioPlayer
}

class Sampler
{
    var numSamples = 15
    var samples = [Sample]()
    
    init() {
        for _ in 0..<numSamples {
            samples.append(Sample(
                note: 0,
                url: NSURL(),
                path: "",
                velocity: 1,
                sound: AVAudioPlayer()
            ));
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
        if samples[s].path != "" {
            if (samples[s].sound.playing) {
                samples[s].sound.stop();
            }
            samples[s].sound.currentTime = 0;
            samples[s].sound.prepareToPlay()
            samples[s].sound.play()
        }
    }
    
    func setSound(s: Int, url: NSURL)
    {
        loadSound(s, path: url.path!)
    }
    
    func savePreset(p: Int)
    {
        var data: [[String: AnyObject]] = []
        let presets = NSUserDefaults()
        
        for s in 0..<numSamples {
            data.append([
                "note": String(samples[s].note),
                "path": String(samples[s].path),
                "velocity": String(samples[s].velocity)
            ])
        }
        
        presets.setObject(data, forKey: String(p))
        presets.synchronize()
    }
    
    func loadPreset(p: Int)
    {
        let presets = NSUserDefaults()
        let data = presets.arrayForKey(String(p)) as? [[String: AnyObject]]
        
        if data != nil {
            for (s, smpl) in data!.enumerate() {
                let sample = Sample(
                    note: UInt8(smpl["note"] as! String)!,
                    url: NSURL(),
                    path: smpl["path"] as! String,
                    velocity: Int(smpl["velocity"] as! String)!,
                    sound: AVAudioPlayer()
                )
                samples[s] = sample
                if samples[s].path != "" {
                    loadSound(s, path: samples[s].path)
                }
            }
        }
    }
    
    func clearPreset(p: Int) {
        var data: [[String: AnyObject]] = []
        let presets = NSUserDefaults()
        
        for _ in 0..<numSamples {
            data.append([
                "note": String(0),
                "path": "",
                "velocity": String(1)
            ])
        }
        presets.setObject(data, forKey: String(p))
        presets.synchronize()
    }
}