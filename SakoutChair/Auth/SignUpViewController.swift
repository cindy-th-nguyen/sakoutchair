//
//  SignUpViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 02/05/2021.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    let authManager = FirebaseAuthManager()
    
    var isIdenticalPassword: Bool {
        return passwordTextField.text == confirmPasswordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        setUpComponents()
    }
    
    func setUpComponents() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        errorLabel.isHidden = true
        errorLabel.textColor = .red
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func createAccountButtonDidTap(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Fields are empties"
            return
        }
        authManager.createUser(name: name, email: email, password: password) { [weak self] (success) in
            guard let strongSelf = self else { return }
            if success && strongSelf.isIdenticalPassword {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeViewController
                strongSelf.navigationController!.pushViewController(homeViewController, animated: true)
            } else {
                strongSelf.errorLabel.isHidden = false
                strongSelf.errorLabel.text = strongSelf.displayErrorLabel()
            }
        }
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let authViewController = storyBoard.instantiateViewController(withIdentifier: "auth") as! AuthViewController
        self.navigationController!.pushViewController(authViewController, animated: true)
    }
    
    
    func displayErrorLabel() -> String {
        if !isValidEmail(emailTextField.text ?? "") {
            return "Your email is incorrect"
        }
        
        if !isValidPassword(passwordTextField.text ?? "") {
            return "Your password is too short"
        }
        
        if !isIdenticalPassword {
            return "Your passwords do not matches"
        }
        return ""
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
    }
}
