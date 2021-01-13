//
//  ChatTypingIndicatorCell.swift
//  Tweak and Eat
//
//  Created by Mehera on 13/01/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class ChatTypingIndicatorCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var overlayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.cellImageView.layer.cornerRadius = 5
        self.overlayLabel.layer.cornerRadius = 5
        self.overlayLabel.clipsToBounds = true

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
