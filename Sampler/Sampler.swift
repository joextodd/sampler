//
//  Sampler.swift
//  Sampler
//
//
import AVFoundation


struct Sample {
    var note: UInt8
    var path: String
    var velocity: UInt8
    var sound: AVAudioPlayer
}

class Sampler
{
    var numSamples = 15
    var samples = [Sample]()
    var queue = DispatchQueue(label: "SamplerQueue", qos: .userInteractive)
    
    init() {
        for s in 0..<numSamples {
            samples.append(Sample(
                note: UInt8(60 + s),
                path: "",
                velocity: 100,
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
            samples[s].sound.volume = Float(samples[s].velocity) / 128.0
            samples[s].sound.prepareToPlay()
            samples[s].sound.play()
        }
    }
    
    func setSound(_ s: Int, path: String)
    {
        loadSound(s, path: path)
    }
    
    func setVelocity(_ s: Int, velocity: UInt8)
    {
        samples[s].velocity = velocity
    }
    
    func getVelocity(_ s: Int) -> UInt8
    {
        return samples[s].velocity
    }
    
    func playNote(_ n: UInt8)
    {
        for s in 0..<numSamples {
            if samples[s].note == n {
                playSound(s)
            }
        }
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
                    velocity: UInt8(smpl["velocity"] as! String)!,
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
        
        for s in 0..<numSamples {
            samples[s] = Sample(
                note: UInt8(60 + s),
                path: "",
                velocity: 100,
                sound: AVAudioPlayer()
            )
            data.append([
                "note": String(60 + s) as AnyObject,
                "path": "" as AnyObject,
                "velocity": String(100) as AnyObject
            ])
        }
        presets.set(data, forKey: String(p))
        presets.synchronize()
    }
}
