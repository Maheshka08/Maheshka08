//
//  CheckBoxTableViewCell.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/2/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

protocol CheckboxDelegate {
    func cellTappedOnCheckBox(_ cell: CheckBoxTableViewCell)
    func cellTappedOnCheckBoxAnswerTV(_ cell: CheckBoxTableViewCell)
    func cellDidBeginOnCheckBoxAnswerTV(_ cell: CheckBoxTableViewCell)
    func cellCheckBoxTextViewidChangeAnswerTV(_ cell: CheckBoxTableViewCell)
}

class CheckBoxTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var checkBxDelegate: CheckboxDelegate?
    @objc var placeholderLabel : UILabel!

    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answersSubView: UIView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkBoxQuestionLabel: UILabel!
    @IBOutlet weak var subQuestionLabel: UILabel!
    
    @IBAction func checkBoxTapped(_ sender: Any) {
         self.checkBxDelegate?.cellTappedOnCheckBox(self);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
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
        if let delegate = checkBxDelegate {
            delegate.cellTappedOnCheckBoxAnswerTV(self)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let delegate = checkBxDelegate {
            delegate.cellDidBeginOnCheckBoxAnswerTV(self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
        if let delegate = checkBxDelegate {
            delegate.cellCheckBoxTextViewidChangeAnswerTV(self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
