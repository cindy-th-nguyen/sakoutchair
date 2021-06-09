//
//  User.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 07/05/2021.
//

import Foundation
import FirebaseAuth

struct User {
    var id: String?
    var name: String
    var email: String
    var password: String
    var hasConfigure: Bool {
        let metadata = Auth.auth().currentUser?.metadata
        if (metadata?.creationDate == metadata?.lastSignInDate) {
            return false
        } else {
            return true
        }
    }
}
