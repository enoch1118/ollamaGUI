//
//  TTSUtil.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/29/24.
//

import Foundation
import AVFoundation

class TTSUtil {
   let synthesizer = AVSpeechSynthesizer()
    
    
    func speak(_ text:String) -> Void {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.2
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
    }
}

