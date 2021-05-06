//
//  AuthViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 29/04/2021.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpComponents()
        self.emailTextfield.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func setUpComponents() {
        emailTextfield.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        
        emailTextfield.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        
        logInButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.borderWidth = 5
        
        titleLabel.textColor = UIColor.CustomColor.customDarkBlue
        headView.backgroundColor = UIColor.CustomColor.customBeige
        signUpButton.layer.borderColor = UIColor.CustomColor.customBeige.cgColor
        signUpButton.setTitleColor(UIColor.CustomColor.customDarkBlue, for: .normal)
        signUpButton.backgroundColor = .white
        logInButton.backgroundColor = UIColor.CustomColor.customDarkBlue
        logInButton.setTitleColor(UIColor.CustomColor.customBeige, for: .normal)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func logInButtonDidTap(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Your email or your password is empty!"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                strongSelf.errorLabel.isHidden = false
                strongSelf.errorLabel.text = "Your email or your password is wrong!"
                return
            }
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeViewController
            let navigation = UINavigationController(rootViewController: homeViewController)
            strongSelf.view.addSubview(navigation.view)
            strongSelf.addChild(navigation)
            navigation.didMove(toParent: self)
        }
    }
    
    @IBAction func signUpButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "signUp") as! SignUpViewController
        self.navigationController!.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func forgotPasswordButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let resetPasswordViewController = storyBoard.instantiateViewController(withIdentifier: "resetPassword") as! ResetPasswordViewController
        self.navigationController?.present(resetPasswordViewController, animated: true)
    }
}
