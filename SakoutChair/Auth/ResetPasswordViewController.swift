//
//  ResetPasswordViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 02/05/2021.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
    }
    
    func setUpComponents() {
        emailTextField.keyboardType = .emailAddress
        resetButton.customBlueRoundedButton()
        headerView.backgroundColor = UIColor.CustomColor.customBeige
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error ?? "")
            }
        }
    }
}
