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

    func configureCell(date: String, hadGoodPosition: Bool) {
        self.nameLabel.text = "Data received"
        self.dateLabel.text = date
        self.averageDayImage.image = UIImage(named: "good-position")
    }
}
