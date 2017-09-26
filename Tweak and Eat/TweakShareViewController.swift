//
//  TweakShareViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit


class TweakShareViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet var commentsView: UIView!
    @IBOutlet var textViewPlaceholder: UILabel!
    @IBOutlet var commentBox: UITextView!
    @IBOutlet var tweakSharedImg: UIImageView!
    @IBOutlet var sharingView: UIView!
    var parameterDict1 : [String : String]!;
    var tweakImage : UIImage!;
    var isRefill : String?
    var popUp : Bool?
    var commentBoxMinY: CGFloat = 0.0
    
    @IBOutlet weak var NutritionPopView: UIView!
    @IBOutlet weak var nutritionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentsViewBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var popUpTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tabBarController?.tabBar.isHidden = true
        commentBoxMinY = self.commentsView.frame.minY
        self.popUpTextView.delegate = self
        self.popUpTextView.layer.borderWidth = 1
        self.popUpTextView.layer.cornerRadius = 5
        self.popUpTextView.layer.borderColor = UIColor.purple.cgColor;
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.1);
        self.NutritionPopView.layer.cornerRadius = 8;
        self.placeHolderLabel.textColor = UIColor.gray
        
        self.NutritionPopView.isHidden = true
        self.okButton.layer.cornerRadius = 5
        
        self.commentBox.delegate = self;
        commentBox.layer.cornerRadius = 10;
        self.commentsView.layer.backgroundColor =  UIColor(red: 18/255, green: 24/255, blue: 3/255, alpha: 1).cgColor;
        
        self.sharingView.layer.backgroundColor =  UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor;
        tweakSharedImg.image = tweakImage
        parameterDict1["refillComments"] = ""
        parameterDict1["userComments"] = ""
      
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == commentBox{
            self.commentsViewBottomConstant.constant = -205
//            self.view.frame = CGRect(x:0, y: -240, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
        }
        else if textView == popUpTextView{
            self.nutritionTopConstraint.constant = -120
        }
    }
 
    @IBAction func infoBtnAction(_ sender: Any) {
        popUpController()
        
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            isRefill = "1"
            sender.setImage(UIImage(named: "whiteCheckedBox.png")!, for: UIControlState.normal);
        }
        else
        {
            isRefill = "0"
            sender.setImage(UIImage(named: "whiteCheckbox.png")!, for: UIControlState.normal);
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxtext: Int = 200;
        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderLabel?.isHidden = false
            textViewPlaceholder?.isHidden = false
        }
        else {
            placeHolderLabel?.isHidden = true
            textViewPlaceholder?.isHidden = true
        }
    }
  
    @IBAction func refillCommentsAction(_ sender: Any) {
        refillPopUp()
    }
    
    func refillPopUp(){
        view.endEditing(true)
        if self.commentsViewBottomConstant.constant == -205 {
            self.commentsViewBottomConstant.constant = 0
        }else  if self.nutritionTopConstraint.constant == -120 {
            self.nutritionTopConstraint.constant = 16
            
        }
        self.NutritionPopView.isHidden = false
        self.popUpTextView.text = ""
        self.popUpTextView.isUserInteractionEnabled = true
        self.commentLabel.isHidden = false
        self.placeHolderLabel.isHidden = false
        self.placeHolderLabel.text = "Enter what you plan to refill.."
        self.commentLabel.text = "You can 'Tweak' it again once you refill, or, Enter what you plan to refill below, For e.g. one more roti, or, more veggies, or one cup rice and yoghurt"
        self.popUpTextView.layer.borderWidth = 2
        self.popUpTextView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.commentLabelHeightConstraint.constant = 87
        self.popUpViewHeightConstraint.constant = 345
        
    }
    
    
    func popUpController()
    {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionistPopViewController") as! NutritionistPopViewController;
        self.addChildViewController(popOverVC);
        // popOverVC.view.frame = self.view.frame;
        popOverVC.popUp = false
        self.view.addSubview(popOverVC.view);
        popOverVC.didMove(toParentViewController: self);
        
    }
   
    @IBAction func okAction(_ sender: Any) {
        self.view.endEditing(true)
        self.NutritionPopView.isHidden = true
    }

    @IBAction func sendTweakAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "ImageUploadingViewController") as! ImageUploadingViewController;
        clickViewController.uploadedImage = tweakImage  as UIImage;
        
        parameterDict1["isRefill"] = isRefill
        parameterDict1["userComments"] = commentBox.text
        parameterDict1["refillComments"] = popUpTextView.text
    
        clickViewController.parameterDict = parameterDict1 as [String : String];
        
        self.navigationController?.pushViewController(clickViewController, animated: true);
        dismiss(animated:true, completion: nil);
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        performSegueToReturnBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        if self.commentsViewBottomConstant.constant == -205 {
           self.commentsViewBottomConstant.constant = 0
        }
        if self.nutritionTopConstraint.constant == -120 {
            self.nutritionTopConstraint.constant = 16

        }
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
