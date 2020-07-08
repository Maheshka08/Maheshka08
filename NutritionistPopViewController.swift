//
//  NutritionistPopViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 8/4/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class NutritionistPopViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var NutritionPopView: UIView!;
    @objc var viewController : WelcomeViewController? = nil;
    @objc var EDRViewController : TimelinesViewController? = nil;
    @IBOutlet var popUpTextView: UITextView!;
    @IBOutlet var commentLabel: UILabel!;
    @IBOutlet var placeHolderText: UILabel!;
    
    var popUp : Bool?;
    var popUp1 : Bool?;
    @objc var popUpText: String = "";
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var countryCode = "";
    var tweakText = ""
    @IBOutlet weak var popViewHeightConstraint: NSLayoutConstraint!;
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!;
    @IBOutlet weak var commentLabelHeight: NSLayoutConstraint!;
    @IBOutlet weak var okButton: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        bundle = Bundle.init(path: path!)! as Bundle;
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            }
        }
        
        self.popUpTextView.text = self.popUpText;
        self.popUpTextView.delegate = self;
        self.popUpTextView.layer.borderWidth = 1;
        self.popUpTextView.layer.cornerRadius = 5;
         self.popUpTextView.layer.borderColor = UIColor.purple.cgColor;
         self.view.backgroundColor = UIColor.white.withAlphaComponent(0.1);
        self.okButton.layer.cornerRadius = 5;
         self.NutritionPopView.layer.cornerRadius = 8;
        self.placeHolderText.textColor = UIColor.gray;
        self.okButton.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal);
        self.showAnimate();
        if popUp == false{
            self.commentLabel.text = bundle.localizedString(forKey: "info_text", value: nil, table: nil);
            self.textViewHeightConstraint.constant = 0;
            self.popViewHeightConstraint.constant = 165;
            self.NutritionPopView.layer.borderWidth = 2;
            self.NutritionPopView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        }else {
            
            self.popUpTextView.isUserInteractionEnabled = true;
            self.popUpTextView.layer.borderWidth = 0;
            self.placeHolderText.isHidden = true;
            self.commentLabelHeight.constant = 0;
            self.popViewHeightConstraint.constant = 258;
            
        }
        
        if popUp1 == true{
            self.commentLabel.text = tweakText;
            self.commentLabelHeight.constant = 87;
            self.textViewHeightConstraint.constant = 0;
            self.popViewHeightConstraint.constant = 230;
            self.NutritionPopView.layer.borderWidth = 2;
            self.NutritionPopView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
            
        }else{
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text);
        let numberOfChars = newText.characters.count;
        return numberOfChars < 240;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderText?.isHidden = false;
           }
        else {
            placeHolderText?.isHidden = true;
        }

    }
    
    @IBAction func okAction(_ sender: Any) {
        if popUp1 == true{
            self.removeAnimate1();
        }else{
            self.removeAnimate();
        }
    }
  
    @objc func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0;
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        });
    }
    
    @objc func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview();
                self.viewController?.checkTweakable();
                self.EDRViewController?.checkTweakable();
            }
        });
    }
    
    @objc func removeAnimate1()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview();
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
