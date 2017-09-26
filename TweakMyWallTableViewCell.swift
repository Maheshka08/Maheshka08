//
//  TweakMyWallTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/14/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
protocol ButtonCellDelegate {
    func cellTappedAwesome(_ cell: TweakMyWallTableViewCell)
    func cellTappedComments(_ cell: TweakMyWallTableViewCell)
    func cellTappedShare(_ cell: TweakMyWallTableViewCell)
    func cellTappedUserComments(_ cell: TweakMyWallTableViewCell)
    func cellTappedLikes(_ cell: TweakMyWallTableViewCell)
    func cellTappedOnImage(_ cell: TweakMyWallTableViewCell, sender: UITapGestureRecognizer)
}

class TweakMyWallTableViewCell: UITableViewCell {
    var cellIndexPath : Int = 0
    var myIndexPath : IndexPath!
    var buttonDelegate: ButtonCellDelegate?
    
    @IBOutlet var cellCommentsLbl: UILabel!
    @IBOutlet var cellAwesomeLbl: UILabel!
    @IBOutlet var userCommentsHeightConstraint: NSLayoutConstraint!
    @IBOutlet var likesHeightConstraint: NSLayoutConstraint!
    @IBOutlet var userCommentsBtn: UIButton!
    @IBOutlet var likesBtn: UIButton!
    @IBOutlet var admobView: UIView!
    @IBOutlet var awesomeBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var borderView: UIView!
    var isLiked : Bool?
    var boostedButton = UIImage(named: "AwesomeFilledIcon.png")

    
    @IBOutlet weak var postedOn: UILabel!
    @IBOutlet weak var tweakOwner: UILabel!
    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var feedContent: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet var imgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var adMobViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var profilePic: UIImageView!
    
    @IBAction func awesomeAction(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedAwesome(self)
             
        }
    }
    
    @IBAction func userCommentsTapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedUserComments(self)
        }

    }
    @IBAction func likesTapped(_ sender: Any) {
        
        if let delegate = buttonDelegate {
            delegate.cellTappedLikes(self)
        }
    }
    @IBAction func shareAction(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedShare(self)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedComments(self)
        }
    }
    
    @IBAction func commentsBtn2Tapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedComments(self)
        }

    }
    
    @IBAction func awesomeBtn2Tapped(_ sender: Any) {
        if let delegate = buttonDelegate {
            delegate.cellTappedAwesome(self)
            
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isLiked = false
        self.likesBtn.isHidden = true
        self.userCommentsBtn.isHidden = true
        self.adMobViewHeightConstraint.constant = 0
        self.imageUrl.isUserInteractionEnabled = true
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TappedOnImage))
        tapped.numberOfTapsRequired = 1
        self.imageUrl?.addGestureRecognizer(tapped)
    }
    
    func TappedOnImage(sender:UITapGestureRecognizer){
        self.buttonDelegate?.cellTappedOnImage(self,sender: sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }
}


