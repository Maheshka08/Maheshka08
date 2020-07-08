//
//  GamifyTableCell.swift
//  Tweak and Eat
//
//  Created by Mehera on 05/05/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit
protocol GamifyBtnCell {
    func cellBtnTapped(_ cell: GamifyTableCell)
   
}
class GamifyTableCell: UITableViewCell {
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    var buttonDelegate: GamifyBtnCell?

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var buttonCell: UIButton!
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLbl.textColor = .white
        self.innerView.layer.cornerRadius = 15
        self.outerView.layer.cornerRadius = 15
        self.backgroundColor = .clear
        self.btnWidthConstraint.constant = 276
        
        self.layer.cornerRadius = 15
        self.titleLbl.layer.cornerRadius = 15
//        if #available(iOS 11.0, *) {
//            self.titleLbl.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        } else {
//            // Fallback on earlier versions
//        } // Top right corner, Top left corner respectively

    }
    @IBAction func btnAction(_ sender: Any) {
        if let delegate = buttonDelegate {
                  delegate.cellBtnTapped(self)
              }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
