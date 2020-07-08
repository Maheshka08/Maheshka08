//
//  AiDPCollectionViewCell.swift
//  Tweak and Eat
//
//  Created by Apple on 10/16/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

class AiDPCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl: UILabel!;
    @IBOutlet weak var redLbl: UILabel!;
    @IBOutlet weak var greenLbl: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor;
    }
}
