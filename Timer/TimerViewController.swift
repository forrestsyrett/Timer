//
//  TimerViewController.swift
//  Timer
//
//  Created by Forrest Syrett on 5/7/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //    MARK: - Outlets
    
    @IBOutlet var timerProgressBar: UIProgressView!
    @IBOutlet var hoursPickerView: UIPickerView!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesPickerView: UIPickerView!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButtonLabel: UIButton!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var pauseButtonLabel: UIButton!
    
    let minutePickerData: [Int] = Array(0...59)
    let hourPickerData: [Int] = Array(0...23)
    
    var timer = Timer()
    
    //    MARK: - Delegates
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.updateTimerViews), name: Timer.secondTickNotification, object: timer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.timerComplete), name: Timer.timerCompleteNotification, object: timer)
        timerLabel.hidden = true
        
        minutesPickerView.selectRow(1, inComponent: 0, animated: false)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //    MARK: - UIPickerView Protocol
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == hoursPickerView {
            return hourPickerData.count
        } else {
            return minutePickerData.count
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    
    
    //    MARK: - Actions
    
    func toggleTimer() {
        if timer.isOn {
            timer.stopTimer()
            switchToPickerView()
        } else {
            switchToTimerView()
            let hours = hoursPickerView.selectedRowInComponent(0)
            let minutes = minutesPickerView.selectedRowInComponent(0) + (hours * 60)
            let totalSecondSetOnTimer = NSTimeInterval(minutes * 60)
            
            timer.setTimer(totalSecondSetOnTimer, totalSeconds: totalSecondSetOnTimer)
            updateTimerViews()
            timer.startTimer()
        }
    }
    
    func updateTimerLabel() {
        timerLabel.text = timer.setTimeAsString
    }
    
    func updateProgressView() {
        
        let secondsElasped = timer.totalSeconds - timer.seconds
        
        let progress = Float(secondsElasped) / Float(timer.totalSeconds)
        
        progressView.setProgress(progress, animated: true)
    }
    
    func updateTimerViews() {
        updateTimerLabel()
        updateProgressView()
    }
    
    @IBAction func startTimerButton(sender: AnyObject) {
        if startButtonLabel.titleLabel?.text == "Start" {
            toggleTimer()
            switchToTimerView()
        } else {
            timer.stopTimer()
            switchToPickerView()
            progressView.progress = 0.0
        }
        
    }
    
    @IBAction func pauseTimerButton(sender: UIButton) {
        if timer.isOn {
            timer.stopTimer()
            pauseButtonLabel.setTitle("Resume", forState: .Normal)
        } else if timer.isOn == false && startButtonLabel.titleLabel?.text == "Cancel" {
            timer.startTimer()
            pauseButtonLabel.setTitle("Pause", forState: .Normal)
        }
    }
    
    
    func timerComplete() {
        switchToPickerView()
    }
    
    func switchToTimerView() {
        timerLabel.hidden = false
        hoursPickerView.hidden = true
        minutesPickerView.hidden = true
        hoursLabel.hidden = true
        minutesLabel.hidden = true
        startButtonLabel.setTitle("Cancel", forState: .Normal)
    }
    func switchToPickerView() {
        timerLabel.hidden = true
        hoursPickerView.hidden = false
        minutesPickerView.hidden = false
        hoursLabel.hidden = false
        minutesLabel.hidden = false
        startButtonLabel.setTitle("Start", forState: .Normal)
        pauseButtonLabel.setTitle("Pause", forState: .Normal)
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
