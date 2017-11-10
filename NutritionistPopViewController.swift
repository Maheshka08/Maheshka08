//
//  NutritionistPopViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 8/4/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit


class NutritionistPopViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var NutritionPopView: UIView!
    var viewController : WelcomeViewController? = nil;
    @IBOutlet var popUpTextView: UITextView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var placeHolderText: UILabel!
    var popUp : Bool?
    
    @IBOutlet weak var popViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.popUpTextView.delegate = self
         self.popUpTextView.layer.borderWidth = 1
         self.popUpTextView.layer.cornerRadius = 5
         self.popUpTextView.layer.borderColor = UIColor.purple.cgColor;
         self.view.backgroundColor = UIColor.white.withAlphaComponent(0.1);
         self.okButton.layer.cornerRadius = 5
         self.NutritionPopView.layer.cornerRadius = 8;
         self.placeHolderText.textColor = UIColor.gray
       
        self.showAnimate();
        if popUp == false{
            self.commentLabel.text = "write a comment to the nutritionist about your plate. For e.g. this is a ghee dosa, or that green is coriander chutney etc"
            self.textViewHeightConstraint.constant = 0
            self.popViewHeightConstraint.constant = 165
            self.NutritionPopView.layer.borderWidth = 2
            self.NutritionPopView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        }else {
            
            self.popUpTextView.isUserInteractionEnabled = false
            self.popUpTextView.layer.borderWidth = 0
            self.placeHolderText.isHidden = true
            self.commentLabelHeight.constant = 0
            self.popViewHeightConstraint.constant = 258
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 240;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderText?.isHidden = false
           }
        else {
            placeHolderText?.isHidden = true
        }

    }
    
    @IBAction func okAction(_ sender: Any) {
      
         self.removeAnimate();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview();
                self.viewController?.takephoto()
            }
        });
    }

}
