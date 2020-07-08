//
//  RecipeDetailsCell.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 14/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class RecipeDetailsCell: UITableViewCell {

    @IBOutlet var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbl.textColor = UIColor.black;
        self.lbl.numberOfLines = 0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

}
