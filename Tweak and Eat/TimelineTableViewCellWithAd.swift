//
//  TimelineTableViewCell.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 29/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

protocol TapOnAdsDelegate {
    func adTapped(_ cell: TimelineTableViewCellWithAd)
}

class TimelineTableViewCellWithAd: UITableViewCell  {
    
    @IBOutlet var borderView: UIView!;
    @IBOutlet var profileImageView: UIImageView!;
    @IBOutlet var starRatingView: HCSStarRatingView!;
    @IBOutlet var timelineDate: UILabel!;
    @IBOutlet var timelineTitle: UILabel!;
    @IBOutlet weak var imageADView: UIImageView!
    @IBOutlet var ratingLabel: UILabel!;
    @IBOutlet var adMobView: UIView!;
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    var buttonDelegate: TapOnAdsDelegate?
    @objc var adId: Int = 0
    @objc var adLocalUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        self.imageADView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickOnAD))
        self.imageADView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func clickOnAD() {
        if let delegate = buttonDelegate {
            self.buttonDelegate?.adTapped(self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
        
        // Configure the view for the selected state
    }
}

