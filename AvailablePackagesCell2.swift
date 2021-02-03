//
//  AvailablePackagesCell2.swift
//  Tweak and Eat
//
//  Created by Mehera on 03/02/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import UIKit

class AvailablePackagesCell2: UITableViewCell {
    @IBOutlet weak var tickMarkImageView: UIImageView!
    @IBOutlet var packageImageView: UIImageView!;
    @IBOutlet weak var packagesView: UIView!
    @IBOutlet weak var packageImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadReferralCodeBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @objc var cellIndexPath : Int = 0;
    @objc var myIndexPath : IndexPath!;
    var cellDelegate: AvailablePackagesCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tickMarkImageView.isHidden = true
        self.packagesView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func uploadReferralCodeBtnTapped(_ sender: Any) {
        self.cellDelegate?.uploadReferralCodeBtnTapped(self)

    }
    
    @IBAction func selectBtnTapped(_ sender: Any) {
        self.cellDelegate?.selectBtnTapped(self)

    }

}
