//
//  AudioRecorder.swift
//  AudioRecorder
//

import AVFoundation

class AudioRecorder {
    
    private var audioRecorder: AVAudioRecorder!
    internal var audioPlayer: AVAudioPlayer!
    //0408 add
    internal var reccount=0
    
    internal func record() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord)
        try! session.setActive(true)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
        audioRecorder.record()
    }
    
    internal func recordStop() -> Data?{
        audioRecorder.stop()
        let data   = try? Data(contentsOf: getURL())
        return data
    }
    
    internal func recordStop2(){
        audioRecorder.stop()
    }
    
    internal func play() {
        audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
        audioPlayer.volume = 8.0
        audioPlayer.play()
        print(getURL())
    }
    
    internal func playStop() {
        if audioPlayer.isPlaying{
        audioPlayer.stop()
        }
    }
    
    private func getURL() -> URL{
        //0408 added
        let countNum=reccount.description
        reccount+=1
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("_sound.m4a")
    }
}
