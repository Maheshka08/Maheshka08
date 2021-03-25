//
//  HorizontalStepsIntroCell.swift
//  Tweak and Eat
//
//  Created by Mehera on 22/03/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class HorizontalStepsIntroCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemImageView.image = UIImage.init(named: "step_1")
        
    }
}
