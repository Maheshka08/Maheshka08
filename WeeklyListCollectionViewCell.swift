//
//  WeeklyListCollectionViewCell.swift
//  Tweak and Eat
//
//  Created by Mehera on 02/04/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class WeeklyListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekDayLabelTrends: UILabel!
    @IBOutlet weak var calorieLabelTrends: UILabel!
    @IBOutlet weak var foodPlateTrends: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodPlateTrends.layer.cornerRadius = self.foodPlateTrends.frame.size.height / 2
        self.foodPlateTrends.layer.borderColor = UIColor.white.cgColor
        self.foodPlateTrends.layer.borderWidth = 3.0
        self.foodPlateTrends.contentMode = .scaleAspectFill
        self.calorieLabelTrends.text = ""
//        self.contentView.backgroundColor = .clear
        
    }
}
