//
//  HistoryCollectionViewCell.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 30/06/2021.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var averageDayImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(date: String, hour: String, wasGood: Bool) {
        self.nameLabel.text = date
        self.dateLabel.text = hour
        self.averageDayImage.image = wasGood ? UIImage(named: "good-image") : UIImage(named: "bad-image")
        self.averageDayImage.frame = CGRect(x: 100, y: 150, width: 150, height: 150)
    }
}
