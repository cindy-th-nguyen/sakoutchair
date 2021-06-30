//
//  HomeViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 01/05/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    let authManager = FirebaseAuthManager()
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
        setUpMainCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        authManager.getCurrentUser { user in
            guard let user = user else { return }
            if !user.hasConfigure {
                PopUpActionViewController.showPopup(parentVC: self)
            }
        }
    }
    
    func setUpComponents() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setUpMainCard() {
        mainCardView.clipsToBounds = true
        mainCardView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        mainCardView.layer.cornerRadius = 35
        mainCardView.backgroundColor = UIColor.CustomColor.customBeige
    }
    
    @IBAction func logOutButtonDidTap(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let authViewController = storyBoard.instantiateViewController(withIdentifier: "auth") as! AuthViewController
            self.navigationController!.pushViewController(authViewController, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
