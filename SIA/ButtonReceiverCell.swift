//
//  ButtonReceiverCell.swift
//  SIA
//
//  Created by Mehera on 11/01/21.
//

import UIKit

protocol SIAButtonDelegate {
    func cellTappedOnButton(_ cell: ButtonReceiverCell)
    func cellTappedOnImageButton(_ cell: ImageReceiverCell)

}
class ButtonReceiverCell: UITableViewCell {
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!

    var btnReceiverDelegate: SIAButtonDelegate?
    var cellIndexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageTextView.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
        self.messageTextView.layer.cornerRadius = 5
        self.messageTextView.adjustUITextViewHeight()
        self.messageTextView.layer.borderWidth = 1.0
        self.messageTextView.layer.borderColor = UIColor.darkGray.cgColor
        self.messageTextView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

    }

    @IBAction func cellButtonTapped(_ sender: Any) {
        self.btnReceiverDelegate?.cellTappedOnButton(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
