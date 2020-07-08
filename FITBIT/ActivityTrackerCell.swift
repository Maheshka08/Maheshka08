//
//  ActivityTrackerCell.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 22/02/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

class ActivityTrackerCell: UITableViewCell {

    @IBOutlet weak var activeMinLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var floorsLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var stepsTitle: UILabel!
    @IBOutlet weak var activeMinsTitle: UILabel!
    @IBOutlet weak var caloriesTitle: UILabel!
    @IBOutlet weak var distanceTitle: UILabel!
    @IBOutlet weak var floorsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
