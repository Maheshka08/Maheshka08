//
//  DietPlanCell.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 07/04/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

protocol DietButtonCellDelegate {
    func cellTappedCheckBox(_ cell: DietPlanCell)
   
}

class DietPlanCell: UITableViewCell {
    
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    
    var dietButtonDelegate: DietButtonCellDelegate?

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        if let delegate = dietButtonDelegate {
            delegate.cellTappedCheckBox(self);
        }
    }
}
