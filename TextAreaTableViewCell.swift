//
//  TextAreaTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/2/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
protocol TextViewDelegate {
    func cellTappedOnAnswerTV(_ cell: TextAreaTableViewCell)
    func cellDidBeginOnAnswerTV(_ cell: TextAreaTableViewCell)
}
class TextAreaTableViewCell: UITableViewCell, UITextViewDelegate {
    @objc var placeholderLabel : UILabel!
    @objc var cellIndexPath: Int = 0
    @objc var myIndexPath: IndexPath!
    var cellDelegate: TextViewDelegate?
    @IBOutlet weak var answerTextView: UITextView!
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
        if let delegate = cellDelegate {
            delegate.cellTappedOnAnswerTV(self)
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let delegate = cellDelegate {
            delegate.cellDidBeginOnAnswerTV(self)
        }
    }
    
   
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
