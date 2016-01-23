//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Timur Ridjanovic on 1/17/16.
//  Copyright © 2016 Timur Ridjanovic. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    private var audioRecorder:AVAudioRecorder?
    private var recordedAudio:RecordedAudio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        } else {
            print("recording was not successful")
            setIconsToStopRecording()
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        startRecording()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        stopRecording()
    }
    
    private func setIconsToStartRecording() {
        recordButton.enabled = false
        stopButton.hidden = false
        recordingInProgress.text = "Recording in progress"
    }
    
    private func setIconsToStopRecording() {
        recordingInProgress.text = "Tap to record"
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    private func getFilePath() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true
        )[0] as String

        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        return filePath!
    }
    
    private func startRecordingSession() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryRecord)
    }
    
    private func stopRecordingSession() {
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    private func startRecording() {
        setIconsToStartRecording()
        let filePath = getFilePath()
        startRecordingSession()
    
        try! audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
        if let audioRecorder = audioRecorder {
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    private func stopRecording() {
        setIconsToStopRecording()
        audioRecorder?.stop()
        stopRecordingSession()
    }
}
