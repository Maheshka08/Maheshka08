//
//  ImageReceiverCell.swift
//  SIA
//
//  Created by Mehera on 11/01/21.
//

import UIKit

class ImageReceiverCell: UITableViewCell {
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var cellImageView: UIImageView!
    var btnReceiverDelegate: SIAButtonDelegate?
    var cellIndexPath: IndexPath!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageTextView.layer.cornerRadius = 5
        self.messageTextView.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
        self.messageTextView.adjustUITextViewHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func cellButtonTapped(_ sender: Any) {
        self.btnReceiverDelegate?.cellTappedOnImageButton(self)
    }

}
