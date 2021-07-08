//
//  SetUpChairViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 08/07/2021.
//

import UIKit

class SetUpChairViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var circularViewDuration: TimeInterval = 2
    var hasFinishedToConfigure = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.backgroundColor = UIColor.CustomColor.customBeige
        self.startButton.customBlueRoundedButton()
    }
    
    @IBAction func startButtonDidTap(_ sender: Any) {
        self.startButton.isEnabled = false
        sendData()
    }
    
    func sendData() {
        
    }
}
