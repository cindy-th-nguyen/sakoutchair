//
//  MyHistoryCollectionViewCell.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 14/07/2021.
//

import UIKit

class MyHistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func configureCell(date: String, hadGoodPosition: Bool) {
        self.backView.backgroundColor = UIColor.CustomColor.customBeige
        self.stateLabel.textColor = UIColor.CustomColor.customDarkBlue
        self.dateLabel.textColor = UIColor.CustomColor.customDarkBlue
        self.stateLabel.text = "Data received"
        self.dateLabel.text = date
        self.stateImage.image = UIImage(named: "good-position")
    }
}
