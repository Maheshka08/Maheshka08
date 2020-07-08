//
//  IAPCell.swift
//  Tweak and Eat
//
//  Created by kk on 26/09/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var subscriptionType: UILabel!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buyBtnTapped(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
