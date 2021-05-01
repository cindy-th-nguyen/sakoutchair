//
//  FirebaseAuthManager.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 29/04/2021.
//

import FirebaseAuth
import UIKit

public class FirebaseAuthManager {
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
}
