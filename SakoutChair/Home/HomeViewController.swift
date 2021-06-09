//
//  HomeViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 01/05/2021.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
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
