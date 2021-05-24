//
//  ScrollCell.swift
//  AutoScroll
//
//  Created by apple on 10/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


class ScrollCell: UICollectionViewCell {
    
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imgViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.descView.layer.cornerRadius = 8
        self.descView.layer.borderColor = UIColor.lightGray.cgColor
        self.descView.layer.borderWidth = 1
        if UIScreen.main.bounds.size.height == 667 {
            self.imgViewHeightConstraint.constant = 280
        }
//        self.imgView.clipsToBounds = true
//        self.imgView.layer.masksToBounds = true
    }
}

