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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(!(authManager.getCurrentUser()?.hasConfigure ?? true)) {
            PopUpActionViewController.showPopup(parentVC: self)
        }
    }
    func setUpComponents() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
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
