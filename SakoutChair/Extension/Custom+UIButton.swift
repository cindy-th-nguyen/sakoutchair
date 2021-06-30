//
//  Custom+UIButton.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 30/06/2021.
//

import UIKit

extension UIButton {
    func customBlueRoundedButton() {
        layer.cornerRadius = 20
        backgroundColor = UIColor.CustomColor.customDarkBlue
        setTitleColor(UIColor.CustomColor.customBeige, for: .normal)
    }
    
    func customBeigeRoundedBoutton() {
        layer.cornerRadius = 20
        layer.borderWidth = 5
        layer.borderColor = UIColor.CustomColor.customBeige.cgColor
        setTitleColor(UIColor.CustomColor.customDarkBlue, for: .normal)
        backgroundColor = .white
    }
}
