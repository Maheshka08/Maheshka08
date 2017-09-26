//
//  AwesomeTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/18/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class AwesomeTableViewCell: UITableViewCell {

    @IBOutlet weak var awesomeName: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var awesomeTime: UILabel!
    
    @IBOutlet weak var commentsHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentsLabel.text = ""
        self.awesomeTime.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
