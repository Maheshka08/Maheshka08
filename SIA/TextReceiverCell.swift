//
//  TextReceiverCell.swift
//  SIA
//
//  Created by Mehera on 10/01/21.
//

import UIKit
extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = false
     //   self.sizeToFit()
        self.isScrollEnabled = false
        self.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    }
}
class TextReceiverCell: UITableViewCell {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageTextView.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
        self.messageTextView.layer.cornerRadius = 5
        self.messageTextView.adjustUITextViewHeight()
        self.textViewWidthConstraint.constant = UIScreen.main.bounds.size.width - 100
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
