//
//  FirebaseAuthManager.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 29/04/2021.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

public class FirebaseAuthManager {
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var ref: DatabaseReference!
    
    func createUser(name: String, email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                self.ref = Database.database(url: "https://sakoutchair-default-rtdb.europe-west1.firebasedatabase.app/").reference()
                let userData : [String : Any] = ["name": name,
                                                 "email": email,
                                                 "hasConfigure": false]
                self.ref.child("users").child(user.uid).setValue(userData)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func getCurrentUser(completion: @escaping ((User?)->Void)) {
        let ref = Database.database(url: "https://sakoutchair-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        var currentUser: User?
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userEmail = value?["email"] as? String ?? ""
            let userName = value?["name"] as? String ?? ""
            let hasConfigure = value?["hasConfigure"] as? Bool ?? false
            currentUser = User(id: userID, name: userName, email: userEmail, hasConfigure: hasConfigure)
            completion(currentUser)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
