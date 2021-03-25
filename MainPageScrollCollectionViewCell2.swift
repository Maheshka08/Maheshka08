//
//  MainPageScrollCollectionViewCell2.swift
//  Tweak and Eat
//
//  Created by Mehera on 22/03/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class MainPageScrollCollectionViewCell2: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemLabel2: UILabel!
    @IBOutlet weak var itemLabel1: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
self.foodImageView.layer.cornerRadius = 10
        self.itemLabel1.layer.cornerRadius = 3
        self.itemLabel2.layer.cornerRadius = 3
        self.itemLabel1.clipsToBounds = true
        self.itemLabel2.clipsToBounds = true
        
        self.foodImageView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.itemLabel2.textAlignment = .center
        self.itemLabel1.textAlignment = .center
        self.foodImageView.contentMode = .scaleAspectFill
    }
    
}
