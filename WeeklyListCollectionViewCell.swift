//
//  WeeklyListCollectionViewCell.swift
//  Tweak and Eat
//
//  Created by Mehera on 02/04/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class WeeklyListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageV.layer.cornerRadius = self.imageV.frame.size.height / 2
        self.imageV.layer.borderColor = UIColor.white.cgColor
        self.imageV.layer.borderWidth = 3.0
        
    }
}
