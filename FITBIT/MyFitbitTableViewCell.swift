//
//  MyFitbitTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 2/22/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit


class MyFitbitTableViewCell: UITableViewCell {
    
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    
    @IBOutlet weak var connectedLabel: UIImageView!
    @IBOutlet weak var deviceLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.connectedLabel.isHidden = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
