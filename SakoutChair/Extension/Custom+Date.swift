//
//  Custom+Date.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 09/07/2021.
//

import Foundation
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
