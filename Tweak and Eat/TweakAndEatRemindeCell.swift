//
//  TweakAndEatRemindeCell.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class TweakAndEatRemindeCell: UITableViewCell {

    @IBOutlet var reminderTitle: UILabel!;
    @IBOutlet var reminderTime: UILabel!;
    @IBOutlet var enableSwitch: UISwitch!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }
}
