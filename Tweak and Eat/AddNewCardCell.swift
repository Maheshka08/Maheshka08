//
//  AddNewCardCell.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 06/04/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
protocol PaymentButtonCellDelegate {
    func cellTappedPaymentBtn(_ cell: AddNewCardCell)
   
}

class AddNewCardCell: UITableViewCell {
    
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    var paymentButtonDelegate: PaymentButtonCellDelegate?

    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cardHolderNameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardHolderNameLabel.layer.cornerRadius = 10;
        self.cardHolderNameLabel.layer.masksToBounds = true;
        self.payButton.layer.cornerRadius = 5;
    }

    @IBAction func payButtonTapped(_ sender: Any) {
        if let delegate = paymentButtonDelegate {
            delegate.cellTappedPaymentBtn(self);
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }

}
