//
//  FloatingCell.swift
//  Tweak and Eat
//
//  Created by apple on 10/03/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

class FloatingCell: UITableViewCell {

    @IBOutlet weak var pkgName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.pkgName.numberOfLines = 0
        self.pkgName.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)

   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
