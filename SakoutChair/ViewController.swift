//
//  ViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 25/04/2021.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    let firebaseAuthManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if firebaseAuthManager.isLoggedIn {
            displayHomePage()
        } else {
            displayLoginPage()
        }
    }
    
    func displayHomePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        let navigation = UINavigationController(rootViewController: homeViewController)
        self.view.addSubview(navigation.view)
        self.addChild(navigation)
        navigation.didMove(toParent: self)
    }
    
    func displayLoginPage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "auth") as! AuthViewController
        let navigation = UINavigationController(rootViewController: loginViewController)
        self.view.addSubview(navigation.view)
        self.addChild(navigation)
        navigation.didMove(toParent: self)
    }
}
