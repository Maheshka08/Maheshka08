//
//  InAppPackagePriceViewCell.swift
//  Tweak and Eat
//
//  Created by Mehera on 13/05/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class InAppPackagePriceViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.imgView.contentMode = .scaleAspectFit
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
