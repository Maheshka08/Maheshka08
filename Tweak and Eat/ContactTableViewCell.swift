//
//  ContactTableViewCell.swift
//  Tweak and Eat
//
//  Created by admin on 21/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!;
    @IBOutlet weak var fullNameContact: UILabel!;
    @IBOutlet weak var phoneNumberContact: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contactImage.layer.cornerRadius = 33.0;
        self.contactImage.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
        // Configure the view for the selected state
    }
    
    class func nib() -> UINib {
        return UINib.init(nibName: "ContactTableViewCell", bundle: nil);
    }
    
}
