//
//  TextSenderCell.swift
//  SIA
//
//  Created by Mehera on 11/01/21.
//

import UIKit

class TextSenderCell: UITableViewCell {
    @IBOutlet weak var messageTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageTextView.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
        self.messageTextView.layer.cornerRadius = 5
        self.messageTextView.adjustUITextViewHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
