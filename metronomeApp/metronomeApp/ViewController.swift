//
//  ViewController.swift
//  phoneRandomPhotos
//
//  Created by Brooklynn Hathaway on 6/1/23.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    var bpm: Int?
    var bpmTime: Double?
    var sound: AVAudioPlayer?
    var timer: Timer? = nil
    @IBOutlet var label: UILabel!
    @IBOutlet var startStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        startStopButton.backgroundColor = .green
        startStopButton.setTitle("Start", for: .normal)
        
        if let soundURL = Bundle.main.url(forResource: "metronomeClick1", withExtension: "mp3") {
            do {
                sound = try AVAudioPlayer(contentsOf: soundURL)
                sound?.prepareToPlay()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    func startTimer(){
        // stop the timer that's already running
        timer?.invalidate()
        
        // creates new timer with new timeInterval
        timer = Timer.scheduledTimer(timeInterval: bpmTime ?? 0.5, target: self, selector: #selector(playSound), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        // Stops the timer
        timer?.invalidate()
        
        //sets it to nil
        timer = nil
    }
    
    
    func calculateTimeInterval(bpm: Int) -> TimeInterval {
        let secondsPerMinute = 60.0
        let timeInterval = secondsPerMinute / Double(bpm)
        return timeInterval
    }

    @objc func playSound() {
            sound?.play()
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let value = sender.value.rounded()
        bpm = Int(value.rounded())
        bpmTime = calculateTimeInterval(bpm: bpm ?? 60)
        label.text = "\(bpm ?? 0) bpm"
        
        // resets the timer with new interval
        startTimer()
        if timer == nil {
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = .green
        } else{
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = .red
        }
    }
    
    @IBAction func startStopButtonPushed(_ sender: UIButton){
        if timer == nil {
            startTimer()
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = .red
        } else{
            stopTimer()
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = .green
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the timer when the view is about to disappear
        timer?.invalidate()
    }
}

