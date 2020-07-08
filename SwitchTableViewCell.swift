//
//  SwitchTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/2/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func cellTappedOnSwitch(_ cell: SwitchTableViewCell)
    func cellTappedOnSwitchAnswerTV(_ cell: SwitchTableViewCell)
    func cellDidBeginOnSwitchAnswerTV(_ cell: SwitchTableViewCell)
    func cellSwitchTextViewDidChangeAnswerTV(_ cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    var switchDelegate: SwitchCellDelegate?
    @objc var placeholderLabel : UILabel!

    @IBOutlet weak var subQuestionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answersSubView: UIView!
    @IBOutlet weak var answerSwitch: UISwitch!
    
    @IBAction func switchTapped(_ sender: Any) {
    self.switchDelegate?.cellTappedOnSwitch(self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.answerTextView.text = ""
        self.answerTextView.keyboardType = UIKeyboardType.default
        self.answerTextView.isUserInteractionEnabled = true
        self.answerTextView.layer.cornerRadius = 10.0
        self.answerTextView.delegate = self
        self.placeholderLabel = UILabel()
        self.placeholderLabel.text = "Fill with your comments"
        self.placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.answerTextView.font?.pointSize)!)
        self.placeholderLabel.sizeToFit()
        self.answerTextView.addSubview(self.placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.answerTextView.font?.pointSize)! / 2)
        self.placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.isHidden = !self.answerTextView.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let delegate = switchDelegate {
            delegate.cellTappedOnSwitchAnswerTV(self)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if let delegate = switchDelegate {
            delegate.cellDidBeginOnSwitchAnswerTV(self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
        switchDelegate?.cellSwitchTextViewDidChangeAnswerTV(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }

}
