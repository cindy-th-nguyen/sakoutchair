//
//  MyAccountViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 02/07/2021.
//

import UIKit
import FirebaseAuth

class MyAccountViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
    }
    
    private func setUpComponents() {
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.headerView.backgroundColor = UIColor.CustomColor.customBeige
        self.updatePasswordButton.customBlueRoundedButton()
        self.signOutButton.customBeigeRoundedBoutton()
        self.passwordTextfield.isSecureTextEntry = true
        FirebaseAuthManager().getCurrentUser(completion: { user in
            guard let user = user else { return }
//            self.nameLabel.text = "\(user.name)'s account"
            self.emailLabel.text = user.email
        })
    }
    
    @IBAction func updatePasswordDidTap(_ sender: Any) {
        guard let password = passwordTextfield.text else {
            return
        }
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            print(error as Any)
        }
    }
    
    @IBAction func signOutButtonDidTap(_ sender: Any) {
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
