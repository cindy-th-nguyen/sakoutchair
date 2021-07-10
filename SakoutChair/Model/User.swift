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
    var hasConfigure: Bool = false
    var history: [UserSensorsData]?
}

struct UserSensorsData {
    var date: String
    var hour: String
    var payload: Payload
}
