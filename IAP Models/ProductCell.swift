//
//  IAPCell.swift
//  Tweak and Eat
//
//  Created by kk on 26/09/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            self.subscriptionType.text = product.localizedTitle
            

        }
    }
    
    @IBOutlet weak var subscriptionType: UILabel!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        self.insideView.layer.cornerRadius = 10.0
        self.insideView.layer.borderColor = UIColor.white.cgColor
        self.insideView.layer.borderWidth = 2
        
    }

    @IBAction func buyBtnTapped(_ sender: Any) {
        buyButtonHandler?(product!)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
