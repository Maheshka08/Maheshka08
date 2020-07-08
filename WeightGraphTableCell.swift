//
//  WeightGraphTableCell.swift
//  Tweak and Eat
//
//  Created by apple on 26/12/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

class WeightGraphTableCell: UITableViewCell {

    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
