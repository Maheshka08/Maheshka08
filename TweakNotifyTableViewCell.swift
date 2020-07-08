//
//  TweakNotifyTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 11/8/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

protocol TweakNotifyTableViewCellDelegate {
   func cellTappedOnImage(_ cell: TweakNotifyTableViewCell, sender: UITapGestureRecognizer)
   func cellTappedOnMessageLbl(_ cell: TweakNotifyTableViewCell, sender: UITapGestureRecognizer)
}

class TweakNotifyTableViewCell: UITableViewCell {

    @IBOutlet var cellSubView: UIView!
    @IBOutlet var imgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var notificationMessageLbl: UILabel!
    @IBOutlet var notificationImageView: UIImageView!
    @IBOutlet weak var notificationDate: UILabel!
    @objc var cellIndexPath : Int = 0
    
    @objc var myIndexPath : IndexPath!
    var cellDelegate: TweakNotifyTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        
        self.cellSubView.layer.cornerRadius = 10;
        self.cellSubView.layer.borderWidth = 1;
        self.notificationImageView.clipsToBounds = true
        self.cellSubView.layer.borderColor = UIColor.lightGray.cgColor;
        //self.notificationImageView.layer.cornerRadius = 10.0;
        self.notificationImageView.isUserInteractionEnabled = true
        let tappedOnImageView:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage))
        tappedOnImageView.numberOfTapsRequired = 1
        self.notificationImageView?.addGestureRecognizer(tappedOnImageView)
        
        self.notificationMessageLbl.isUserInteractionEnabled = true
        let tappedOnMessageLbl:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnMessageLabel))
        tappedOnMessageLbl.numberOfTapsRequired = 1
        self.notificationMessageLbl?.addGestureRecognizer(tappedOnMessageLbl)
    }
    
    @objc func tappedOnImage(sender:UITapGestureRecognizer){
        self.cellDelegate?.cellTappedOnImage(self,sender: sender)
    }
    
    @objc func tappedOnMessageLabel(sender:UITapGestureRecognizer){
        self.cellDelegate?.cellTappedOnMessageLbl(self,sender: sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
