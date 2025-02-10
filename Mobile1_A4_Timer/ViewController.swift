//
//  ViewController.swift
//  Mobile1_A4_Timer
//
//  Created by Jake Gordin on 2/9/25.
//

import UIKit
import AVFoundation
var audioPlayer: AVAudioPlayer?
class ViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var backGround: UIStackView!
    @IBOutlet weak var timeRemaining: UILabel!
    var timer = Timer()
    var dateFormatter = DateFormatter()
    var backgroundDate = DateFormatter()
    var clockState = 0
    var targetTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "EE, d MMM yyyy HH:mm:ss"
        backgroundDate.dateFormat = "a"

        dateLabel.text = dateFormatter.string(from: Date())
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        timerButton.layer.cornerRadius = 0
        timerButton.layer.borderColor = UIColor.black.cgColor
        timerButton.layer.borderWidth = 1
        timeRemaining.text = ""
        checkTime()

    }
    @objc func tick() {
        dateLabel.text = dateFormatter.string(from: Date())
        checkTime()
        if (clockState == 1) {
            updateRemaining()
        }
    }
    func checkTime() {
        let currentAM = backgroundDate.string(from: Date())
        if (currentAM == "PM") {
            backGround.backgroundColor = UIColor.blue
        }
        else {
            backGround.backgroundColor = UIColor.red
        }
    }
    func updateRemaining() {
        let currentInterval = Date().timeIntervalSince1970
        let remainingSeconds = targetTime - currentInterval
        let secondsInt = Int(remainingSeconds)
        let hoursRemain = secondsInt / 3600
        let minutesRemain = ((secondsInt % 3600) / 60)
        let secondsRemain = secondsInt % 60
        let hoursString = String(format: "%02d", hoursRemain)
        let minutesString = String(format: "%02d", minutesRemain)
        let secondsString = String(format: "%02d", secondsRemain)
        timeRemaining.text = ("Time Remaining: " + hoursString + ":" + minutesString + ":" + secondsString)
        if (clockState == 1) {
            if (remainingSeconds <= 0) { // time expired
                clockState = 2
                timerButton.setTitle("Stop Music", for: .normal)
                timerButton.isHidden = false
                guard let url = Bundle.main.url(forResource: "fanfare", withExtension: "mp3") else { return }
                audioPlayer = try! AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                audioPlayer?.play()
                
            }
        }
    }
    @IBAction func buttonPressed(_ sender: Any) {
        if (clockState == 0) { //timer not running
            let currentInterval = Date().timeIntervalSince1970
            let duration = datePicker.countDownDuration
            targetTime = (currentInterval + duration)
            print("current interval ", currentInterval)
            print("duration interval ", duration)
            print("target interval ", targetTime)
            updateRemaining()
            clockState = 1
            timerButton.isHidden = true
            datePicker.isHidden = true
        }
        else if (clockState == 2) { //music playing
            audioPlayer?.stop()
            datePicker.isHidden = false
            timerButton.setTitle("Start Timer", for: .normal)
            timeRemaining.text = ""
            clockState = 0
        }
    }
}

