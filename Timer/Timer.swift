//
//  Timer.swift
//  Timer
//
//  Created by Forrest Syrett on 5/7/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class Timer: NSObject {
    
    static let secondTickNotification = "secondTick"
    static let timerCompleteNotification = "timerComplete"
    
    
    private(set) var seconds = NSTimeInterval(0)
    
    private(set) var totalSeconds = NSTimeInterval(0)
    
    private var timer: NSTimer?
    
    
    
    var isOn: Bool {
        get {
            if timer != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    var setTimeAsString: String {
        get {
            
            let totalSeconds = Int(self.seconds)
            
            let hours = totalSeconds/3600
            let minutes = (totalSeconds - (hours * 3600))/60
            let seconds = totalSeconds - (hours * 3600) - (minutes * 60)
            
            var hoursString = ""
            if hours > 0 {
                hoursString = "\(hours):"
            }
            
            var minutesString = ""
            if minutes < 10 {
                minutesString = "0\(minutes)"
            } else {
                minutesString = "\(minutes)"
            }
            
            var secondsString = ""
            if seconds < 10  {
                secondsString = ":0\(seconds)"
            } else {
                secondsString = ":\(seconds)"
            }
            return hoursString + minutesString + secondsString
            
        }
        
    }
    
    
    func setTimer(seconds: NSTimeInterval, totalSeconds: NSTimeInterval) {
        self.seconds = seconds
        self.totalSeconds = totalSeconds
        
    }
    
    func startTimer() {
        if isOn == false {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(Timer.secondTick), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if isOn {
            timer?.invalidate()
            timer = nil
        }
    }
    func secondTick() {
        seconds -= 1
        NSNotificationCenter.defaultCenter().postNotificationName(Timer.secondTickNotification, object: self)
        if seconds <= 0 {
            stopTimer()
            NSNotificationCenter.defaultCenter().postNotificationName(Timer.timerCompleteNotification, object: self)
            
        }
    }
}