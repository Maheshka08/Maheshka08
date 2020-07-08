//
//  MYEDRCell.swift
//  Tweak and Eat
//
//  Created by mac on 10/04/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

class MYEDRCell: UITableViewCell {
    @IBOutlet weak var genderImgView: UIImageView!
    @IBOutlet weak var userCommentsLabel: UILabel!
    @IBOutlet var borderView: UIView!;
    @IBOutlet var profileImageView: UIImageView!;
    @IBOutlet var starRatingView: HCSStarRatingView!;
    @IBOutlet var timelineDate: UILabel!;
    @IBOutlet var timelineTitle: UILabel!;
    @IBOutlet var ratingLabel: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
