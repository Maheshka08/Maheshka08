//
//  TweakShareViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 7/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase

class TweakShareViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var sectionsForGamifyArray = [[String: AnyObject]]()
    @IBOutlet var commentsView: UIView!;
    @IBOutlet weak var mealTypeLabel: UILabel!;
    @IBOutlet var commentBox: UITextView!;
    @IBOutlet var tweakSharedImg: UIImageView!;
    @IBOutlet var sharingView: UIView!;
    @objc var parameterDict1 : [String : AnyObject]!;
    @objc var tweakImage : UIImage!;
    @objc var commentBoxMinY: CGFloat = 0.0;
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @objc var isRefill = "0";
    var popUp : Bool?;
    var mealTypeValue = 0;
    
    @IBOutlet weak var mealTypeTableViewHeightConstraint: NSLayoutConstraint!;
    @IBOutlet weak var sendTweakBtn: UIButton!;
    @IBOutlet weak var mealTypeTableView: UITableView!;
    
    @IBOutlet weak var NutritionPopView: UIView!;
    @IBOutlet weak var nutritionTopConstraint: NSLayoutConstraint!;
    @IBOutlet weak var commentsViewBottomConstant: NSLayoutConstraint!;
    @IBOutlet weak var okButton: UIButton!;
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!;
    @IBOutlet weak var commentLabelHeightConstraint: NSLayoutConstraint!;
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!;
    @IBOutlet weak var popUpTextView: UITextView!;
    @IBOutlet weak var infoBtn: UIButton!;
    @IBOutlet var textViewPlaceholder: UILabel!;
    @IBOutlet weak var commentLabel: UILabel!;
    
    @IBOutlet weak var refillLabel: UILabel!;
    @IBOutlet weak var planningRefill: UIButton!;
    @IBOutlet weak var placeHolderLabel: UILabel!;
    var mealTypeArray = [[String: AnyObject]]();
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var countryCode = "";
    var ptpPackage = "";
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dropDownTapped(_ sender: Any) {
        self.view.endEditing(true)
        if self.commentsViewBottomConstant.constant == -255 {
                  self.commentsViewBottomConstant.constant = 0
               }
               if self.nutritionTopConstraint.constant == -120 {
                   self.nutritionTopConstraint.constant = 16
               }
        MBProgressHUD.showAdded(to: self.mealTypeTableView, animated: true)
        self.getMealTypes()
       
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        self.commentBox.becomeFirstResponder()
        self.checkBoxBtn.layer.borderWidth = 4
        self.checkBoxBtn.layer.borderColor = UIColor.lightGray.cgColor
        
       // self.getMealTypes()
        self.commentsView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        self.commentBox.autocorrectionType = .no
        self.mealTypeLabel.layer.cornerRadius = 4;
        self.mealTypeTableView.delegate = self
        self.mealTypeTableView.dataSource = self
        //self.mealTypeLabel.text = ""
        self.mealTypeLabel.textAlignment = .left
//        Breakfast (internal value: 1)
//        Brunch (internal value: 2)
//        Lunch (internal value: 3)
//        Evening Snack (internal value: 5)
//        Dinner (internal value: 7)
      //  self.mealTypeArray = [["mealType": "Breakfast", "value": 1],["mealType": "Brunch", "value": 2],["mealType": "Lunch", "value": 3],["mealType": "Evening Snack", "value": 5],["mealType": "Dinner", "value": 7],] as [[String : AnyObject]]
        self.mealTypeTableView.reloadData()
//        tweakSharedImg.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        tweakSharedImg.clipsToBounds = true

        tweakSharedImg.contentMode = .scaleToFill
        tweakSharedImg.image = tweakImage
        self.addBackButton()
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        
        sendTweakBtn.layer.cornerRadius = 8
        //sendTweakBtn.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.black.cgColor
        
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
                commentLabel.font = commentLabel.font.withSize(13)
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
                commentLabel.font = commentLabel.font.withSize(15)
            }
        }
        
        self.refillLabel.text = bundle.localizedString(forKey: "refill", value: nil, table: nil)
        
        self.okButton.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal)
        self.planningRefill.setTitle(bundle.localizedString(forKey: "planning_to_refill", value: nil, table: nil), for: .normal)
        self.textViewPlaceholder.text = bundle.localizedString(forKey: "refill_comment", value: nil, table: nil)
        
        self.tabBarController?.tabBar.isHidden = true
        commentBoxMinY = self.commentsView.frame.minY
        self.popUpTextView.delegate = self
        self.popUpTextView.layer.borderWidth = 1
        self.popUpTextView.layer.cornerRadius = 5
        self.popUpTextView.layer.borderColor = UIColor.purple.cgColor;
        self.NutritionPopView.layer.cornerRadius = 8;
        self.placeHolderLabel.textColor = UIColor.darkText
        
        self.NutritionPopView.isHidden = true
        self.okButton.layer.cornerRadius = 5
        
        self.commentBox.delegate = self;
        commentBox.layer.borderWidth = 4
        commentBox.layer.borderColor = UIColor.yellow.cgColor
//        self.commentsView.layer.backgroundColor =  UIColor(red: 18/255, green: 24/255, blue: 3/255, alpha: 1).cgColor;
        
        self.sharingView.layer.backgroundColor =  UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor;
        
        parameterDict1["refillComments"] = "" as AnyObject
        parameterDict1["userComments"] = "" as AnyObject
        commentBox.autocorrectionType = .yes
        popUpTextView.autocorrectionType = .yes
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mealTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mealTypeTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cellDict = self.mealTypeArray[indexPath.row];
        cell.textLabel?.textAlignment = .center;
        cell.textLabel?.text = (cellDict["name"] as! String)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellDict = self.mealTypeArray[indexPath.row];
        self.mealTypeValue = cellDict["value"] as! Int
        self.mealTypeLabel.text = "  " + (cellDict["name"] as! String)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        
                        self.mealTypeTableViewHeightConstraint.constant = 0
                        self.view.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
        })
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Please select your meal type:"
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == commentBox{
            self.commentsViewBottomConstant.constant = -255
        }
        else if textView == popUpTextView{
           // self.nutritionTopConstraint.constant = -120
        }
    }
 
    @IBAction func infoBtnAction(_ sender: Any) {
        popUpController()
        
    }
    
    func getMealTypes() {
        APIWrapper.sharedInstance.getMealTypes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    self.mealTypeArray = (response["data"] as AnyObject as! NSArray) as! [[String : AnyObject]]
                    
                    print(self.mealTypeArray)
                    self.mealTypeTableView.reloadData()
                    MBProgressHUD.hide(for: self.mealTypeTableView, animated: true);
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                   animations: {
                                    
                                    self.mealTypeTableView.isHidden = false
                                    self.mealTypeTableViewHeightConstraint.constant = 250
                                    self.view.layoutIfNeeded()
                    },  completion: {(_ completed: Bool) -> Void in
                    })
                    }
                
            }else {
                //error
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.mealTypeTableView, animated: true);
                }
                print("error")
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.mealTypeTableView, animated: true);
            }
            
            print("error")
            
        }
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            isRefill = "1"
            sender.setImage(UIImage(named: "whiteCheckedBox.png")!, for: UIControl.State.normal);
        }
        else
        {
            isRefill = "0"
            sender.setImage(UIImage(named: "whiteCheckbox.png")!, for: UIControl.State.normal);
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxtext: Int = 200;
        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext;
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == commentBox {
            if !textView.hasText {
                textViewPlaceholder?.isHidden = false
            }
            else {
                textViewPlaceholder?.isHidden = true
            }
        } else if textView == popUpTextView {
            if !textView.hasText {
                placeHolderLabel?.isHidden = false
            }
            else {
                placeHolderLabel?.isHidden = true
            }
        }
    
//        if !textView.hasText {
//            placeHolderLabel?.isHidden = false
//            textViewPlaceholder?.isHidden = false
//        }
//        else {
//            placeHolderLabel?.isHidden = true
//            textViewPlaceholder?.isHidden = true
//        }
    }
  
    @IBAction func refillCommentsAction(_ sender: Any) {
        refillPopUp()
    }
    
    @objc func refillPopUp() {
        view.endEditing(true)
        if self.commentsViewBottomConstant.constant == -255 {
            self.commentsViewBottomConstant.constant = 0
        }else  if self.nutritionTopConstraint.constant == -120 {
            self.nutritionTopConstraint.constant = 16
            
        }
        self.NutritionPopView.isHidden = false
        self.popUpTextView.text = ""
        self.popUpTextView.isUserInteractionEnabled = true
        self.commentLabel.isHidden = false
        self.placeHolderLabel.isHidden = false
        self.placeHolderLabel.text = bundle.localizedString(forKey: "refill_placeholder_text", value: nil, table: nil)
        self.commentLabel.text = bundle.localizedString(forKey: "refill_text", value: nil, table: nil)
        self.popUpTextView.layer.borderWidth = 2
        self.popUpTextView.layer.borderColor = TweakAndEatColorConstants.AppDefaultColor.cgColor;
        self.commentLabelHeightConstraint.constant = 87
       // self.popUpViewHeightConstraint.constant = 345
        
    }
 
    @objc func popUpController() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionistPopViewController") as! NutritionistPopViewController;
        self.addChild(popOverVC);
        popOverVC.popUp = false
        self.view.addSubview(popOverVC.view);
        popOverVC.didMove(toParent: self);
        
    }
   
    @IBAction func okAction(_ sender: Any) {
        self.view.endEditing(true)
        self.NutritionPopView.isHidden = true
    }

    @IBAction func sendTweakAction(_ sender: UIButton) {
        if self.mealTypeValue == 0 {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please select your meal type !")
            return
        }
        if self.countryCode == "91" {
                       self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
                   } else if self.countryCode == "1" {
                       self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
                   } else if self.countryCode == "65" {
                       self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
                   } else if self.countryCode == "62" {
                       self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
                   } else if self.countryCode == "60" {
                       self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
                   } else if self.countryCode == "63" {
                       self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
                   }
        parameterDict1["isRefill"] = isRefill as AnyObject
        parameterDict1["userComments"] = commentBox.text as AnyObject
        parameterDict1["refillComments"] = popUpTextView.text as AnyObject
        parameterDict1["mealType"] = self.mealTypeValue as AnyObject
        if self.countryCode == "91" {
            var tweakCount = 0
                  if UserDefaults.standard.value(forKey: "TWEAK_COUNT") != nil {
                   tweakCount = UserDefaults.standard.value(forKey: "TWEAK_COUNT") as! Int
                  }
                  var labelsCount = 0
                  if UserDefaults.standard.value(forKey: "USER_LABELS_COUNT") != nil {
                      labelsCount = UserDefaults.standard.value(forKey: "USER_LABELS_COUNT") as! Int
                  }
                  
                  if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil || UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil || UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil || UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil || tweakCount > 50 || labelsCount > 10 {
                      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                            let clickViewController = storyBoard.instantiateViewController(withIdentifier: "ImageUploadingViewController") as! ImageUploadingViewController;
                            clickViewController.uploadedImage = tweakImage  as UIImage;
                            
                        
                            clickViewController.parameterDict = parameterDict1
                            
                            self.navigationController?.pushViewController(clickViewController, animated: true);
                            dismiss(animated:true, completion:  nil);
                   } else {
                      
                      self.getGlobalVariablesData()
                  }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let clickViewController = storyBoard.instantiateViewController(withIdentifier: "ImageUploadingViewController") as! ImageUploadingViewController;
                clickViewController.uploadedImage = tweakImage  as UIImage;
                
            
                clickViewController.parameterDict = parameterDict1
                
                self.navigationController?.pushViewController(clickViewController, animated: true);
                dismiss(animated:true, completion:  nil);
            
        }
      
      
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "gamify" {
                   let destination = segue.destination as! GamifyViewController;
            destination.fromWhichController = "TweakShareViewController"
            destination.uploadedImage = tweakImage  as UIImage;
                         
                             destination.parameterDict = parameterDict1
                   if self.sectionsForGamifyArray.count > 1 {
                   destination.lastIndexSection = self.sectionsForGamifyArray.last!
                   } else if self.sectionsForGamifyArray.count == 1 {
                   destination.lastIndexSection = self.sectionsForGamifyArray.first!
                   }
                   var sectionsArray = [[String: AnyObject]]()
                   for obj in self.sectionsForGamifyArray {
                       let sections = obj
                       if sections.index(forKey: "title") != nil {
                       sectionsArray.append(sections)
                       }
                   }
                   destination.sectionsArray = sectionsArray

               }
    }
    func getGlobalVariablesData() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        Database.database().reference().child("GlobalVariables").child("Pages").child("GamifyingLevel1").child(self.countryCode).child("iOS").observe(DataEventType.value, with: { (snapshot) in
                   
                    if snapshot.childrenCount > 0 {
                         self.sectionsForGamifyArray = []
                                let dispatch_group1 = DispatchGroup();
                                dispatch_group1.enter();
                                   for obj in snapshot.children.allObjects as! [DataSnapshot] {
                                    if obj.key == "Sections" {
                                        let sectionsArray = obj.value as AnyObject as! NSArray
                                        self.sectionsForGamifyArray = sectionsArray as AnyObject as! [[String : AnyObject]]
                                        
                                    }
                               
                        
                    }
                    
                        dispatch_group1.leave();

                        dispatch_group1.notify(queue: DispatchQueue.main) {
                            self.performSegue(withIdentifier: "gamify", sender: self)
                        }
                        
                    }
                   
                    
                   
                    
                })
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        performSegueToReturnBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        if self.commentsViewBottomConstant.constant == -255 {
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
    @objc func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
