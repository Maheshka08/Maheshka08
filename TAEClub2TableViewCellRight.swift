//
//  TAEClub2TableViewCellRight.swift
//  Tweak and Eat
//
//  Created by Mehera on 07/08/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

class TAEClub2TableViewCellRight: UITableViewCell {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

       @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if IS_iPHONE5 {
            self.imageViewWidthConstraint.constant = 60
            self.imageViewHeightConstraint.constant = 60
                          self.nameLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 13.0)
                          self.descLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 10.0)
                      } else if IS_iPHONE678 || IS_iPHONEXXS {
                          self.nameLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 16.0)
                          self.descLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 13.0)
                      } else {
                      self.nameLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 20.0)
                      self.descLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 15.0)
    }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
