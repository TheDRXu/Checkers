//
//  Sound.swift
//  Wordle
//
//  Created by Dwayne Reinaldy on 4/7/22.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?


func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }
        catch{
            print("ERROR")
        }
    }
    
}
