//
//  SonarTest.swift
//  SakoutcherMqttTester
//
//  Created by Oudjama on 29/06/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let capteurJSON = try? newJSONDecoder().decode(CapteurJSON.self, from: jsonData)

import Foundation

// MARK: - CapteurJSON
class MqttPayload: Codable {
    let payload: Payload
    
    init(payload: Payload) {
        self.payload = payload
    }
}

// MARK: - Capteurs
class Payload: Codable {
    let sonar: [Float]
    let seatLeft: Bool
    let seatRight: Bool
    
    init(sonar: [Float], seatLeft: Bool, seatRight: Bool) {
        self.sonar = sonar
        self.seatLeft = seatLeft
        self.seatRight = seatRight
    }
    
    enum CodingKeys: String, CodingKey {
        case sonar 
        case seatLeft = "seat_left"
        case seatRight = "seat_right"
    }
}

class SensorDataManager {
    var data:[Float] = [0,0,0]
    static let sharedInstance: SensorDataManager = {
        let instance = SensorDataManager()
        return instance
    }()
}

class SeatDataManager {
    var data: [Bool] = [false, false]
    static let sharedInstance: SeatDataManager = {
        let instance = SeatDataManager()
        return instance
    }()
}

class IsHereDataManager {
    var data: Bool = false
    static let sharedInstance: IsHereDataManager = {
        let instance = IsHereDataManager()
        return instance
    }()
}

