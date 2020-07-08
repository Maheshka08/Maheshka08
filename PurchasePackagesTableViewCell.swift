//
//  PurchasePackagesTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 5/16/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

protocol PurchasePackageButtonCellDelegate {
    func cellTappedCall(_ cell: PurchasePackagesTableViewCell)
    func cellTappedChat(_ cell: PurchasePackagesTableViewCell)
    func cellTappedDietPlan(_ cell: PurchasePackagesTableViewCell)
    func cellTappedOnQuestions(_ cell: PurchasePackagesTableViewCell)
    func cellTappedWeightReadings(_ cell: PurchasePackagesTableViewCell)
}

class PurchasePackagesTableViewCell: UITableViewCell {
    
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    var packageButtonDelegate: PurchasePackageButtonCellDelegate?
    @IBOutlet weak var graphButton: UIButton!

    @IBOutlet weak var adherenceScore: UIButton!
    @IBOutlet weak var packageBackgroundView: UIView!
    @IBOutlet weak var packageImageView: UIImageView!
    
    @IBOutlet weak var weightTrendsLabel: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var toolBarView: UIView!
    
    @IBOutlet weak var twetoxIconsView: UIView!
    
    @IBOutlet weak var graphHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.packageTitle.font = UIFont(name: "Trebuchet MS", size: 14.0)
      
        self.graphButton.layer.cornerRadius = 10.0
        self.graphButton.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            self.graphButton.layer.borderWidth = 1

    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        if let delegate = packageButtonDelegate {
            delegate.cellTappedCall(self);
        }
    }
    
    @IBAction func chatButtonTapped(_ sender: Any) {
        if let delegate = packageButtonDelegate {
            delegate.cellTappedChat(self);
        }
    }
    
    
    @IBAction func weightReadingsTapped(_ sender: Any) {
        if let delegate = packageButtonDelegate {
            delegate.cellTappedWeightReadings(self);
        }

    }
    
    
    @IBAction func dietPlanButtonTapped(_ sender: Any) {
        if let delegate = packageButtonDelegate {
            delegate.cellTappedDietPlan(self);
        }

    }
    
    @IBAction func questionairreTapped(_ sender: Any) {
        if let delegate = packageButtonDelegate {
            delegate.cellTappedOnQuestions(self);
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
