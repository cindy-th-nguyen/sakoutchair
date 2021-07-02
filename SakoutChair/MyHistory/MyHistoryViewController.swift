//
//  MyHistoryViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 01/07/2021.
//

import UIKit

class MyHistoryViewController: UIViewController{
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpComponents()
    }
    
    private func setUpComponents() {
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        self.headerView.backgroundColor = UIColor.CustomColor.customBeige
    
    }
}
