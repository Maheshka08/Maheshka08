//
//  AvailablePremiumPackagesTableViewCell.swift
//  Tweak and Eat
//
//  Created by Apple on 4/5/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
protocol AvailablePackagesCellDelegate {
    func cellTappedOnHowToSubscribeVideo(_ cell: AvailablePremiumPackagesTableViewCell)
    func uploadReferralCodeBtnTapped(_ cell: AvailablePackagesCell2)
    func selectBtnTapped(_ cell: AvailablePackagesCell2)
    func cellTappedOnImage(_ cell: AvailablePremiumPackagesTableViewCell, sender: UITapGestureRecognizer)

}
class AvailablePremiumPackagesTableViewCell: UITableViewCell {
    @IBOutlet weak var purchasedLbl: UIView!
    @IBOutlet weak var tickMarkImageView: UIImageView!
    
    @IBOutlet weak var packagesView: UIView!
    @objc var cellIndexPath : Int = 0;
    @objc var myIndexPath : IndexPath!;
    var cellDelegate: AvailablePackagesCellDelegate?
    @IBOutlet weak var howToSubscribeVideoBtn: UIButton!
    @IBOutlet var packageImageView: UIImageView!;
    @IBOutlet weak var quarterlyLabel: UILabel!;
 
    @IBOutlet weak var expandViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var singlePackQtyTextField: UITextField!;
    @IBOutlet var multiplePackQtyTextField: UITextField!;
    @IBOutlet var familyPackQtyTextField: UITextField!;
    
    @IBOutlet weak var howToSubVideoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableView: UIView!;
    @IBOutlet weak var packageImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableViewHeightConstraint: NSLayoutConstraint!;
    
    @objc var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.expandableViewHeightConstraint.constant = 0.0;
                
            } else {
                self.expandableViewHeightConstraint.constant = 154.0;
            }
        }
    }
    
    @objc func tappedOnImage(sender:UITapGestureRecognizer){
        self.cellDelegate?.cellTappedOnImage(self,sender: sender);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.tickMarkImageView.isHidden = true
        self.packagesView.layer.cornerRadius = 15
        self.packagesView.backgroundColor = .clear
        self.packageImageView.isUserInteractionEnabled = true;
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage));
        tapped.numberOfTapsRequired = 1;
        self.packageImageView?.addGestureRecognizer(tapped);
        //self.expandViewHeightConstraint.constant = 0;
        //self.packageImageView.contentMode = .scaleToFill
      //  self.purchasedLbl.isHidden = true;

        // Initialization code
//        self.expandableView.isUserInteractionEnabled = true;
//        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnExpandableView));
//        tapped.numberOfTapsRequired = 1;
//        self.expandableView?.addGestureRecognizer(tapped);
        
    }
    
    @IBAction func howToSubcribeVideoTapped(_ sender: Any) {
        self.cellDelegate?.cellTappedOnHowToSubscribeVideo(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }
}
