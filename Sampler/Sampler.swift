//
//  Sampler.swift
//  Sampler
//
//
import AVFoundation

// TODO: Fix multiple sounds on one trigger

struct Sample {
    var note: UInt8
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
                path: "",
                velocity: 1,
                sound: AVAudioPlayer()
            ));
        }
    }
    
    func loadSound(_ s: Int, path: String)
    {
        let url = URL(string: path)!
        samples[s].path = path
        
        do {
            samples[s].sound = try AVAudioPlayer(contentsOf: url)
            guard case samples[s].sound = samples[s].sound else { return }
            
            samples[s].sound.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playSound(_ s: Int)
    {
        if samples[s].path != "" {
            if (samples[s].sound.isPlaying) {
                samples[s].sound.stop();
            }
            samples[s].sound.currentTime = 0;
            samples[s].sound.prepareToPlay()
            samples[s].sound.play()
        }
    }
    
    func setSound(_ s: Int, path: String)
    {
        loadSound(s, path: path)
    }
    
    func savePreset(_ p: Int)
    {
        var data: [[String: AnyObject]] = []
        let presets = UserDefaults()
        
        for s in 0..<numSamples {
            data.append([
                "note": String(samples[s].note) as AnyObject,
                "path": String(samples[s].path) as AnyObject,
                "velocity": String(samples[s].velocity) as AnyObject
            ])
        }
        
        presets.set(data, forKey: String(p))
        presets.synchronize()
    }
    
    func loadPreset(_ p: Int)
    {
        let presets = UserDefaults()
        let data = presets.array(forKey: String(p)) as? [[String: AnyObject]]
        
        if data != nil {
            for (s, smpl) in data!.enumerated() {
                let sample = Sample(
                    note: UInt8(smpl["note"] as! String)!,
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
    
    func clearPreset(_ p: Int) {
        var data: [[String: AnyObject]] = []
        let presets = UserDefaults()
        
        for _ in 0..<numSamples {
            data.append([
                "note": String(0) as AnyObject,
                "path": "" as AnyObject,
                "velocity": String(1) as AnyObject
            ])
        }
        presets.set(data, forKey: String(p))
        presets.synchronize()
    }
}
