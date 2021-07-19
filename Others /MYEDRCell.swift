//
//  MYEDRCell.swift
//  Tweak and Eat
//
//  Created by mac on 10/04/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

protocol MYEDRDelegate {
    func copyMeal(_ cell: MYEDRCell)
    func rateThisMeal(_ cell: MYEDRCell)
    func askAQuestion(_ cell: MYEDRCell)
    func shareToTweakWall(_ cell: MYEDRCell)
}

class MYEDRCell: UITableViewCell {
    var delegate: MYEDRDelegate?
    var myIndex = 0
    @IBOutlet weak var genderImgView: UIImageView!
    @IBOutlet weak var userCommentsLabel: UILabel!
    @IBOutlet var borderView: UIView!;
    @IBOutlet var mealTypeView: UIView!;
    @IBOutlet var profileImageView: UIImageView!;
    @IBOutlet var starRatingView: HCSStarRatingView!;
    @IBOutlet var timelineDate: UILabel!;
    @IBOutlet var timelineTitle: UILabel!;
    @IBOutlet var ratingLabel: UILabel!;
    @IBOutlet var caloriesLabel: UILabel!;
    @IBOutlet var carbsLabel: UILabel!;
    @IBOutlet var proteinLabel: UILabel!;
    @IBOutlet var fatsLabel: UILabel!;
    @IBOutlet var mealTypeLabel: UILabel!;
    @IBOutlet var nutritionLabelsView: UIView!;
    @IBOutlet var askAQuestionHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = 15
        self.profileImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.mealTypeView.layer.cornerRadius = 10
        self.mealTypeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.borderView.layer.cornerRadius = 15
        self.borderView.layer.borderWidth = 1
        self.borderView.layer.borderColor = UIColor.lightGray.cgColor
        self.nutritionLabelsView.addBorders(color: .lightGray, margins: 0, borderLineSize: 0.5, attribute: .top)
        self.nutritionLabelsView.addBorders(color: .lightGray, margins: 0, borderLineSize: 0.5, attribute: .bottom)
        //self.borderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func copyThisMealTapped(_ sender: Any) {
        self.delegate?.copyMeal(self)
    }
    
    @IBAction func shareToTweakWallTapped(_ sender: Any) {
        self.delegate?.shareToTweakWall(self)
    }
    
    @IBAction func rateThisTweakTapped(_ sender: Any) {
        self.delegate?.rateThisMeal(self)
    }
    
    @IBAction func askAQuestionTapped(_ sender: Any) {
        self.delegate?.askAQuestion(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
