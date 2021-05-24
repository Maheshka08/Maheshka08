//
//  NutritionLabelsPaymentHistoryTableViewCell.swift
//  Tweak and Eat
//
//  Created by Apple on 11/29/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

class NutritionLabelsPaymentHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var labelsCount: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.amountLabel!.font = UIFont(name: "QUESTRIAL-REGULAR", size: 14)
        self.amountLabel?.numberOfLines = 0
        
        self.labelsCount!.font = UIFont(name: "QUESTRIAL-REGULAR", size: 14)
        self.labelsCount?.numberOfLines = 0
        
        self.dateLabel!.font = UIFont(name: "QUESTRIAL-REGULAR", size: 14)
        self.dateLabel?.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
