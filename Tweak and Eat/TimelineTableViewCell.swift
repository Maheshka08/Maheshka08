//
//  TimelineTableViewCell.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit


class TimelineTableViewCell: UITableViewCell  {
    
    @IBOutlet var borderView: UIView!;
    @IBOutlet var profileImageView: UIImageView!;
    @IBOutlet var starRatingView: HCSStarRatingView!;
    @IBOutlet var timelineDate: UILabel!;
    @IBOutlet var timelineTitle: UILabel!;
    @IBOutlet var ratingLabel: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }
    
}
