//
//  TweakAndEatRemindeCell.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

protocol ChangeTime {
    func changeTime(_ cell: TweakAndEatRemindeCell)
}

class TweakAndEatRemindeCell: UITableViewCell {

    @IBOutlet var reminderTitle: UILabel!;
    @IBOutlet var reminderTime: UILabel!;
    @IBOutlet var enableSwitch: UISwitch!;
    @objc var myIndexPath : IndexPath!;
    var delegate: ChangeTime?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func changeBtnTapped(_ sender: Any) {
        self.delegate?.changeTime(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }
}
