//
//  NutritionLabelTableViewCell.swift
//  Tweak and Eat
//
//  Created by Apple on 11/5/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

class NutritionLabelTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel!.font = UIFont(name: "QUESTRIAL-REGULAR", size: 17)
        self.textLabel?.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
