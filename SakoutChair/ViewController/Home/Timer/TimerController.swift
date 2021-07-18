//
//  Timer.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 16/07/2021.
//

import UIKit

class TimerController {
    var timer = Timer()
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func timerAction(){
        print("timer fired!")
    }
}
