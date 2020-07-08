//
//  MainPageScrollCollectionViewCell.swift
//  GestureRecognizers
//
//  Created by apple on 19/12/19.
//  Copyright © 2019 Uday Surya. All rights reserved.
//

import UIKit

class MainPageScrollCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemLabel2: UILabel!
    @IBOutlet weak var itemLabel1: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
self.foodImageView.layer.cornerRadius = 10
        self.foodImageView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.itemLabel2.textAlignment = .center
        self.foodImageView.contentMode = .scaleAspectFill
    }
    
}
