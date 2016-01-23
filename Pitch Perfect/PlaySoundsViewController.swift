//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Timur Ridjanovic on 1/18/16.
//  Copyright © 2016 Timur Ridjanovic. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    private var audioPlayer: AVAudioPlayer?
    internal var receivedAudio: RecordedAudio?
    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    private let SlowRate: Float = 0.5
    private let FastRate: Float = 1.5
    private let ChipmunkPitch: Float = 1000
    private let DarthVaderPitch: Float = -1000
    private let EchoDelay: Float = 0.3
    private let ReverbWetDryMix: Float = 60
    private let Volume: Float = 1.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let filePathUrl = receivedAudio?.filePathUrl {
            initAudio(filePathUrl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowEvent(sender: UIButton) {
        changeRateAndPlay(SlowRate)
    }
    
    @IBAction func playFastEvent(sender: UIButton) {
        changeRateAndPlay(FastRate)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(ChipmunkPitch)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(DarthVaderPitch)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithVariableDelay(EchoDelay)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithVariableWetDryMix(ReverbWetDryMix)
    }
    
    @IBAction func stopPlayingEvent(sender: UIButton) {
        stopPlaying()
    }
    
    private func initAudio(filePathUrl: NSURL) {
        audioPlayer = try! AVAudioPlayer(contentsOfURL: filePathUrl)
        audioFile = try! AVAudioFile(forReading: filePathUrl)
        audioPlayer?.enableRate = true
        audioEngine = AVAudioEngine()
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
    }
    
    private func changeRateAndPlay(rate: Float) {
        stopPlaying()
        if let audioPlayer = audioPlayer {
            audioPlayer.rate = rate
            audioPlayer.volume = Volume
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    private func attachNodeAndPlay(node: AVAudioNode) {
        stopPlaying()
        if let audioEngine = audioEngine, audioFile = audioFile {
            let audioPlayerNode = AVAudioPlayerNode()
            audioPlayerNode.volume = Volume
            audioEngine.attachNode(audioPlayerNode)
            audioEngine.attachNode(node)
            audioEngine.connect(audioPlayerNode, to: node, format: nil)
            audioEngine.connect(node, to: audioEngine.outputNode, format: nil)
            
            audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            try! audioEngine.start()
            audioPlayerNode.play()
        }
    }
    
    private func playAudioWithVariablePitch(pitch: Float) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        attachNodeAndPlay(changePitchEffect)
    }
    
    private func playAudioWithVariableDelay(delay: Float) {
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(delay)
        attachNodeAndPlay(echoNode)
    }
    
    private func playAudioWithVariableWetDryMix(wetDryMix: Float) {
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = wetDryMix
        attachNodeAndPlay(reverbNode)
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        resetAudioEngine()
    }
    
    private func resetAudioEngine() {
        audioEngine?.stop()
        audioEngine?.reset()
    }
}
