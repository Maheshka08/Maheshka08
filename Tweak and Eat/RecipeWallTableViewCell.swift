//
//  RecipeWallTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 11/29/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//  Reviewed

import UIKit

protocol AwesomeButtonCellDelegate {
    func cellTappedAwesome(_ cell: RecipeWallTableViewCell);
    func cellTappedOnAwesomeLabel(_ cell: RecipeWallTableViewCell, sender: UITapGestureRecognizer);
    func cellTappedShare(_ cell: RecipeWallTableViewCell);
    func cellTappedShareLabel(_ cell: RecipeWallTableViewCell, sender:UITapGestureRecognizer);
    func cellTappedSubView(_ cell: RecipeWallTableViewCell, sender:UITapGestureRecognizer);
    func cellTappedBuyIngredientsIcon(_ cell: RecipeWallTableViewCell, sender: Any);
    func cellTappedBuyDIYIcon(_ cell: RecipeWallTableViewCell, sender: Any);
}

class RecipeWallTableViewCell: UITableViewCell {
   
    @IBOutlet weak var sticker2ImageView: UIImageView!
    @IBOutlet weak var sticker1ImageView: UIImageView!
    @IBOutlet weak var buyIngredientsIconTrailingConstraint: NSLayoutConstraint!;
    @objc var cellIndexPath : Int = 0;
    @objc var myIndexPath : IndexPath!;
    @IBOutlet var recipeCellView: UIView!;
    @IBOutlet var shareBtn: UIButton!;
    @IBOutlet var awesomeBtn: UIButton!;
    @IBOutlet var awesomeLabel: UILabel!;
    @IBOutlet weak var shareLabel: UILabel!;
    @IBOutlet var caloriesLabel: UILabel!;
    @IBOutlet var carbsLbl: UILabel!;
    @IBOutlet var recipeImageView: UIImageView!;
    @IBOutlet weak var recipeTitleLabel: UILabel!;
    var buttonDelegate: AwesomeButtonCellDelegate?;
    
    @IBOutlet weak var videoIcon: UIImageView!;
    @IBOutlet weak var buyIngredientsIconBtn: UIButton!;
    @IBOutlet weak var buyDIYIconBtn: UIButton!;
    @IBOutlet weak var buyHotPotIconBtn: UIButton!;
    @IBOutlet weak var recipeSubView: UIView!;
    @IBOutlet weak var awesomeLbl1: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
       // self.buyIngredientsIconTrailingConstraint.constant = 8;
        // Initialization code
        self.carbsLbl.layer.cornerRadius = 3
        self.caloriesLabel.layer.cornerRadius = 3
        self.awesomeLabel.layer.cornerRadius = 3
        self.awesomeLabel.clipsToBounds = true
        self.carbsLbl.clipsToBounds = true
        self.caloriesLabel.clipsToBounds = true
        self.recipeImageView.contentMode = .scaleAspectFill
        self.recipeImageView.clipsToBounds = true
        self.sticker2ImageView.isHidden = true
        self.sticker1ImageView.isHidden = true
        self.buyDIYIconBtn.isHidden = true;
        self.buyIngredientsIconBtn.isHidden = true;
        self.recipeCellView.layer.cornerRadius = 2;
        self.awesomeLbl1.isUserInteractionEnabled = true;
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage));
        tapped.numberOfTapsRequired = 1;
        self.awesomeLbl1?.addGestureRecognizer(tapped);
        
        self.shareLabel.isUserInteractionEnabled = true;
        let tapped1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnShare));
        tapped1.numberOfTapsRequired = 1;
        self.shareLabel?.addGestureRecognizer(tapped1);
        
        self.recipeSubView.isUserInteractionEnabled = true;
        let tapped2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnSubView));
        tapped2.numberOfTapsRequired = 1;
        self.recipeSubView?.addGestureRecognizer(tapped2);
    }
    
    @objc func tappedOnImage(sender:UITapGestureRecognizer){
        self.buttonDelegate?.cellTappedOnAwesomeLabel(self,sender: sender);
       
    }
    
     @objc func tappedOnShare(sender:UITapGestureRecognizer){
        self.buttonDelegate?.cellTappedShareLabel(self,sender: sender);
    }
    
     @objc func tappedOnSubView(sender:UITapGestureRecognizer){
        self.buttonDelegate?.cellTappedSubView(self,sender: sender);
    }
    
    @IBAction func asesomeBtnTapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedAwesome(self);
            
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedShare(self);
            
        }
    }
    
    @IBAction func buyIngredientsIconTapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedBuyIngredientsIcon(self, sender: sender);
            
        }
    }
    
    @IBAction func buyDIYIconTapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedBuyDIYIcon(self, sender: sender);
            
        }
    }
   
    @IBAction func buyHotPotIconTapped(_ sender: Any) {
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

}
