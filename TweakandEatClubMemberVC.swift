//
//  TweakandEatClubMemberVC.swift
//  Tweak and Eat
//
//  Created by Mehera on 12/08/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

class TweakandEatClubMemberVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UserCallSchedule {
    func closeBtnTapped() {
          self.callSchedulePopup.removeFromSuperview()
           self.title = self.navTitle
                 self.calendarOuterView.isHidden = true
          self.navigationItem.hidesBackButton = false
      }
      var packageID = ""
      @objc var callSchedulePopup : UserCallSchedulePopUp! = nil;
      @objc var API_KEY = "rzp_live_dFMdQLcE5x9q86";
      @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
      @objc var bundle = Bundle();
      @objc var labelPriceDict = [String: AnyObject]();
      @objc var nutritionLabelPriceArray = NSMutableArray();
      let calenderView: CalenderView = {
            let v=CalenderView(theme: MyTheme.light)
            v.translatesAutoresizingMaskIntoConstraints=false
            return v
        }()
      
      var navTitle = ""
      var checkUserScheduleArray = [[String: AnyObject]]()
      @IBOutlet weak var calendarInnerView: UIView!
      @IBOutlet weak var languageTableView: UITableView!
      @IBOutlet weak var cancelBtn: UIButton!
      @IBOutlet weak var calView: UIView!
      @IBOutlet weak var calendarOuterView: UIView!
      @IBOutlet weak var scheduleBtn: UIButton!
      @IBOutlet weak var moreInfoSelectPlanView: UIView!
      @IBOutlet weak var chooseSubScriptionPlanLbl: UILabel!
      @IBOutlet weak var userCallScheduleView1: UIView!
      @IBOutlet weak var captchViewInfoLbl: UILabel!
      @IBOutlet weak var userCallScheduleView2: UIView!
      @IBOutlet weak var buyNowMoreInfoBtn: UIButton!
      @IBOutlet weak var moreInfoSubscribeTextView: UITextView!
      @IBOutlet weak var featuresViewSubscribeTextView: UITextView!
      @IBOutlet weak var featuresView: UIView!
      @IBOutlet weak var callNutritionistTextLbl1: UILabel!
      @IBOutlet weak var callNutritionistTextLbl2: UILabel!
      @IBOutlet weak var unsubScribeImageView: UIImageView!
      @IBOutlet weak var priceTableView: UITableView!
      @IBOutlet weak var priceLabel: UILabel!
      @IBOutlet weak var selectPlanView: UIView!
      var timeSlotsArray = [[String: AnyObject]]()
      var productPrice: NSDecimalNumber = NSDecimalNumber()
      @IBOutlet weak var buyNowButton: UIButton!;
      @IBOutlet weak var infoView: UIView!;
      @IBOutlet weak var innerCalendarViewHeightConstant: NSLayoutConstraint!
      @IBOutlet weak var timeSlotTextField: UITextField!
      @IBOutlet weak var languageTextField: UITextField!
      @IBOutlet weak var packageDescTextView: UITextView!;
      @IBOutlet weak var areYouSureLbl: UILabel!
      @IBOutlet weak var unSubscribeImgViewHeightContraint: NSLayoutConstraint!
      @IBOutlet weak var callNutritionistBtn2HeightContraint: NSLayoutConstraint!
      @IBOutlet weak var topImageViewHeightContraint: NSLayoutConstraint!
      @IBOutlet weak var middleImageViewHeightContraint: NSLayoutConstraint!
      @IBOutlet weak var bottomImageViewHeightContraint: NSLayoutConstraint!
      @IBOutlet weak var ourNutritionistLbl: UILabel!
      @IBOutlet weak var callNutritionistBtn2: UIButton!
      @IBOutlet weak  var paySucessView: UIView!
      @IBOutlet weak  var usdAmtLabel: UILabel!
      @IBOutlet weak  var nutritionstDescLbl: UILabel!
      var clubMembExpDate = 0
      var system = 0;
      var confirmationText = ""
      var cardImageString = "";
      var labelsPrice = "pkgPrice"
      var lables = "pkgDisplayDescription"
      var lableCount = "pkgDuration"
      @IBOutlet weak var captchaInnerView: UIView!
      var timerForShowScrollIndicator: Timer?
      @IBOutlet weak var refreshBtn: UIButton!
      @IBOutlet weak var captchInputTF: UITextField!
    @IBOutlet weak var scheduleLabel: UILabel!
      @IBOutlet weak var confirmCaptchaBtn: UIButton!
      
      @IBOutlet weak var captchaGeneratorTF: UITextField!
      @IBOutlet weak var moreInfoTableView: UITableView!

      @IBOutlet weak var captchaView: UIView!
      @objc var ptpPackage = ""
      @IBOutlet weak var packageTitle: UILabel!
      @IBOutlet weak var packagePrice: UILabel!
      @IBOutlet weak var callNutritionistBtn1: UIButton!
      @IBOutlet weak var packageDescription: UITextView!
      var pickerView: UIPickerView {
        get {
          let pickerView = UIPickerView()
          pickerView.dataSource = self
          pickerView.delegate = self
          pickerView.backgroundColor = UIColor.white
          return pickerView
        }
      }
      var accessoryToolbar: UIToolbar {
        get {
          let toolbarFrame = CGRect(x: 0, y: 0,
            width: view.frame.width, height: 44)
          let accessoryToolbar = UIToolbar(frame: toolbarFrame)
          let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self,
            action: #selector(onDoneButtonTapped(sender:)))
          let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
          accessoryToolbar.items = [flexibleSpace, doneButton]
          accessoryToolbar.barTintColor = UIColor.white
          return accessoryToolbar
        }
      }
      @objc var smallImage : String = ""
      @objc var price : String = ""
      @objc var name : String = ""
      @objc var package : String = ""
      @objc var msisdn : String = ""
      @objc var packageId : String = ""
      @objc var packageFullDesc : String = ""
      @objc var paymentType : String = ""
      @objc var currency : String = ""
      @objc var countryCode = ""
      @objc var priceInDouble : Double = 0.0
      var productIdentifier = ""
      @objc var selectedIndex: Int = 0;
      @objc var languagesArray = [[String: AnyObject]]()
      @objc var displayAmount : String = "";
      @objc var displayCurrency : String = "";
      @objc var pkgDescription : String = "";
      
      @objc var pkgDuration : String = "";
      @objc var nutritionLabelPackagesArray = NSMutableArray();
      @objc var moreInfoPremiumPackagesArray = NSMutableArray()
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var scheduleCallButton: UIButton!
    @IBOutlet weak var topImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scheduleTextLabel: UILabel!

    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
           if self.timeSlotTextField.isFirstResponder {
           self.timeSlotTextField.resignFirstResponder()
               if self.timeSlotsArray.count > 0 && self.timeSlotTextField.text?.count == 0 {
               let dict = self.timeSlotsArray[0]
                self.timeSlotTextField.text = (dict["ncts_timeslot"] as! String)
                   
               }
              
               self.updateAreYouSureLbl()
         }
       }
    
    @IBAction func scheduleCallTapped(_ sender: Any) {
           
         
           if self.calenderView.selectedDate == 0 || self.timeSlotTextField.text?.count == 0 || self.languageTextField.text?.count == 0{
               if self.calenderView.selectedDate == 0 && self.timeSlotTextField.text?.count != 0 && self.languageTextField.text?.count != 0 {
                   TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose a date from calendar !")
               } else if self.timeSlotTextField.text?.count == 0 && self.calenderView.selectedDate != 0 && self.languageTextField.text?.count != 0 {
                   TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose time !")
               } else if self.timeSlotTextField.text?.count != 0 && self.calenderView.selectedDate != 0 && self.languageTextField.text?.count == 0 {
                   TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose the language !")
               } else {
                   TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please choose date, time and language to schedule a call from our Certified Nutritionists !")
               }
               return
           }
           self.captchaView.isHidden = false
        self.captchInputTF.becomeFirstResponder()
           self.captchViewInfoLbl.text = self.confirmationText
           

           
          }
          @IBAction func cancelCalenderViewTapped(_ sender: Any) {
           self.title = self.navTitle
           self.timeSlotTextField.text = ""
           self.calendarOuterView.isHidden = true
           self.navigationItem.hidesBackButton = false
          }
       
       func getUserCallScheduleDetails() {
           MBProgressHUD.showAdded(to: self.view, animated: true)

                 APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CHECK_USER_SCHEDULE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                     print(response!)
                     
                     let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                     let responseResult = responseDic["callStatus"] as! String;
                     if  responseResult == "GOOD" {
                         self.checkUserScheduleArray = []
                         MBProgressHUD.hide(for: self.view, animated: true);
                         let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                         if data.count == 0 {
                             
                         } else {
                             self.checkUserScheduleArray = data
                         //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_CALL_FLOATING_BUTTON"), object: nil);
                         }
                     }
                 }, failure : { error in
                     MBProgressHUD.hide(for: self.view, animated: true);
                     
                     print("failure")
                     if error?.code == -1011 {
                         TweakAndEatUtils.AlertView.showAlert(view: self, message: "Could not schedule the call. Please try again...");
                         return
                     }
                     TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
                 })
       }
          override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
                calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
            }

       @objc func updateAreYouSureLbl() {
           if self.calenderView.selectedDate != 0 && self.timeSlotTextField.text!.count > 0 {
               self.areYouSureLbl.isHidden = false
               let date = (self.calenderView.selectedDate < 10) ? "0\(self.calenderView.selectedDate)" : "\(self.calenderView.selectedDate)"
                          let month = (self.calenderView.currentMonthIndex < 10) ? "0\(self.calenderView.currentMonthIndex)" : "\(self.calenderView.currentMonthIndex)"
                          let year = "\(self.calenderView.currentYear)"
               let time = self.timeSlotTextField.text!
               let lang = self.languageTextField.text!
               self.areYouSureLbl.text = "Are you sure you want to fix a call on " + date + "/" + month + "/" + year + " at " + time + "?"
               self.confirmationText = "on " + date + "/" + month + "/" + year + " at " + time + " in " + lang
           }
       }
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event);
           view.endEditing(true);

       }
       
       var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result.characters).count < 4
        return result
       }
    @IBAction func refreshCaptcha(_ sender: Any) {
           self.captchaGeneratorTF.text = fourDigitNumber
           self.captchInputTF.text = ""

       }
    
    func updateUI(data: [[String: AnyObject]] ) {
        if data.count == 0 {
            
        } else {
          for dict in data {
              if dict["name"] as! String == "bottom_btn" {
                              DispatchQueue.global(qos: .background).async {
                      // Call your background task
                      let imgUrl = (dict["value"] as! String)
                      let data = try? Data(contentsOf: URL(string: imgUrl)!)
                      // UI Updates here for task complete.
                     
                      if let imageData = data {
                          let image = UIImage(data: imageData)
                          DispatchQueue.main.async {
                                  self.scheduleCallButton.setBackgroundImage(image, for: .normal)
                              
                              
                          }
                  }
                  

                      
                  }
              }
                  if dict["name"] as! String == "bg" {
                      let urlString = dict["value"] as! String

                    self.topImageView.sd_setImage(with: URL(string: urlString)) { (image, error, cache, url) in
                                                                       // Your code inside completion block
                      let ratio = image!.size.width / image!.size.height
                      let newHeight = self.topImageView.frame.width / ratio
                     
                          UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                animations: {
                                                 self.topImageViewHeightConstraint.constant = newHeight
                                                
                                                  self.view.layoutIfNeeded()
                                 }, completion: nil)


                      }
              }
              if dict["name"] as! String == "bottom_txt" {
                  let urlString = dict["value"] as! String

                                     self.bottomImageView.sd_setImage(with: URL(string: urlString)) { (image, error, cache, url) in
                                                                                        // Your code inside completion block
                                       let ratio = image!.size.width / image!.size.height
                                       let newHeight = self.bottomImageView.frame.width / ratio
                                      
                                           UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                                 animations: {
                                                                  self.bottomImageViewHeightConstraint.constant = newHeight
                                                                 
                                                                   self.view.layoutIfNeeded()
                                                  }, completion: nil)


                                       }              }

          }
        }
    }
    func checkNCPSchedule() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CHECK_NCP_SCHEDULE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
//                    let dateFormatter = DateFormatter()
//                                  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
//                    if responseDic.index(forKey: "ncpc_call_date") != nil {
//                                  let expDateStr =  responseDic["ncpc_call_date"] as! String;
//                    let sepearatedDateArray = expDateStr.components(separatedBy: "T")
//                        print(sepearatedDateArray)
//                        let extractedDate = sepearatedDateArray[0]
//                        print(extractedDate)
//                        let dateArray = extractedDate.components(separatedBy: "-")
//                       // let onlyDate = dateArray.last!
//                        self.clubMembExpDate = Int(dateArray.last!)!
//
//
//
//
//                    }
                   
                        if data.count == 0 {
                        self.scheduleCallButton.isHidden = false
                        self.bottomImageView.isHidden = true
                    } else {
                        
                        let info = data.first
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                        if (info?["ncpc_call_date"] is NSNull) {
                           return
                        }
                        let expDateStr =  info?["ncpc_call_date"] as? String
                        //let expDateStr =  "2019-07-24T17:19:43.000Z"
                        let expDate = dateFormatter.date(from: expDateStr!);
                        dateFormatter.dateFormat = "EEEE, MMM dd yyyy 'at' hh:mm a"
                        let formattedDate = dateFormatter.string(from: expDate!)
                        let stringValue = "When: " + formattedDate
                               let whenRange = stringValue.range(of: "When:")
                               let atRange = stringValue.range(of: "at")
                        
                               let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                               attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(whenRange!, in: stringValue))
                               attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(whenRange!, in: stringValue))
                               attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(atRange!, in: stringValue))

                              
                               
                               let userMsisdn = info?["ncpc_usr_msisdn"] as! String
                               let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number " + userMsisdn
                               let msisdnRange = certNutText.range(of: userMsisdn)
                               let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                               certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                               certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                        self.scheduleLabel.isHidden = false
                        self.scheduleLabel.text = certNutText + " on " + formattedDate + "."
                       self.scheduleCallButton.isHidden = true
                        self.bottomImageView.isHidden = false
                        
                       
                    }
                    self.ncpLanding()

                  } else if responseResult == "USER_NOT_NC_PACKAGE_USER" {
                    self.scheduleCallButton.isHidden = true
                    self.bottomImageView.isHidden = true
                    self.ncpLanding()
                }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    
    func checkClubMemberSchedule() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CHECK_CLUB_MEMBER_SCHEDULE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                    let dateFormatter = DateFormatter()
                                  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    if responseDic.index(forKey: "clubSubExpDttm") != nil {
                                  let expDateStr =  responseDic["clubSubExpDttm"] as! String;
                    let sepearatedDateArray = expDateStr.components(separatedBy: "T")
                        print(sepearatedDateArray)
                        let extractedDate = sepearatedDateArray[0]
                        print(extractedDate)
                        let dateArray = extractedDate.components(separatedBy: "-")
                       // let onlyDate = dateArray.last!
                        self.clubMembExpDate = Int(dateArray.last!)!
                        
                        
                        
                        
                    }
                    if data.count == 0 {
                        self.scheduleCallButton.isHidden = false
                        self.bottomImageView.isHidden = true
                    } else {
                        
                        
                       self.scheduleCallButton.isHidden = true
                        self.bottomImageView.isHidden = false
                        
                       
                    }
                    self.clubLanding()

                  } else if responseResult == "USER_NOT_CLUB_MEMBER" {
                    self.scheduleCallButton.isHidden = true
                    self.bottomImageView.isHidden = true
                    self.clubLanding()
                }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    
    func ncpLanding() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.NCP_LANDING, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                    self.updateUI(data: data)

                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    
    func clubLanding() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_LANDING, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                    self.updateUI(data: data)

                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }

    @IBAction func confirmCaptchaScheduleCall(_ sender: Any) {
        if self.captchaGeneratorTF.text != self.captchInputTF.text {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please enter a valid 4 digit number!")
            self.captchInputTF.text = ""
            
            return
        }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let date = (self.calenderView.selectedDate < 10) ? "0\(self.calenderView.selectedDate)" : "\(self.calenderView.selectedDate)"
                let month = (self.calenderView.currentMonthIndex < 10) ? "0\(self.calenderView.currentMonthIndex)" : "\(self.calenderView.currentMonthIndex)"
                let year = "\(self.calenderView.currentYear)"
                let time = "\(self.timeSlotTextField.text?.replacingOccurrences(of: " AM", with: ":00").replacingOccurrences(of: " PM", with: ":00") ?? "")"
                let timeSlot: String = year + "-" + month + "-" + date + " " + self.timeSlotTextField.text!
        let paramsDictionary = ["callDateTime": timeSlot, "lang": self.languageTextField.text!] as [String : AnyObject]
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(self.packageID == "-NcInd5BosUcUeeQ9Q32" ? TweakAndEatURLConstants.NCP_CALL_SCHEDULE : TweakAndEatURLConstants.SCHEDULE_CLUB_MEMBER_CALL, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: paramsDictionary , success: { response in
                    print(response!)
                    
                    let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                    let responseResult = responseDic["callStatus"] as! String;
                    if  responseResult == "GOOD" {
                       
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.captchaView.isHidden = true
                        self.view.endEditing(true)
                        self.callSchedulePopup = (Bundle.main.loadNibNamed("UserCallSchedulePopUp", owner: self, options: nil)! as NSArray).firstObject as? UserCallSchedulePopUp;
                                                     self.callSchedulePopup.frame = CGRect(0, 0, self.view.frame.width, self.view.frame.height);
                                                            self.callSchedulePopup.userCallScheduleDelegate = self;
                                                            self.callSchedulePopup.beginning();
                        self.view.addSubview(self.callSchedulePopup)
                        self.callSchedulePopup.yourCallLabel.text = "Your CALL has been scheduled !"
                         let data = responseDic["data"] as! [String: AnyObject]
                        let callDateTime: String = data["callDateTime"] as! String
                        let stringValue = "When: " + callDateTime
                                              let whenRange = stringValue.range(of: "When: ")
                                              
                                              let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                                              attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(whenRange!, in: stringValue))
                                              attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(whenRange!, in: stringValue))
                                              

                                             
                                              self.callSchedulePopup.whenLbl.attributedText = attributedString
                        let userMsisdn = data["userMsisdn"] as! String
                        
                        let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number " + userMsisdn
                        let scheduleDetails = ["callDateTime": callDateTime, "certNutText":certNutText, "userMsisdn": userMsisdn] as [String: AnyObject];
                        UserDefaults.standard.set(scheduleDetails, forKey: "CALL_SCHEDULED_FROM_CLUB");
                        UserDefaults.standard.synchronize()
                       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_CALL_FLOATING_BUTTON"), object: nil);
                                              let msisdnRange = certNutText.range(of: userMsisdn)
                                              let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                                              certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                                              certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                                              self.callSchedulePopup.ourCerifiedNutritionistLbl.attributedText = certAttrStr
                        self.scheduleLabel.isHidden = false
                        self.scheduleLabel.text = certNutText + " on " + callDateTime + "."
                        self.scheduleCallButton.isHidden = true
                        self.bottomImageView.isHidden = false
                       
                    } else if responseResult == "USER_NOT_CLUB_MEMBER" {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.scheduleCallButton.isHidden = true
                        self.bottomImageView.isHidden = true
                                            self.captchaView.isHidden = true
                                            self.view.endEditing(true)
                                            self.callSchedulePopup = (Bundle.main.loadNibNamed("UserCallSchedulePopUp", owner: self, options: nil)! as NSArray).firstObject as? UserCallSchedulePopUp;
                                                                         self.callSchedulePopup.frame = CGRect(0, 0, self.view.frame.width, self.view.frame.height);
                                                                                self.callSchedulePopup.userCallScheduleDelegate = self;
                                                                                self.callSchedulePopup.beginning();
                                            self.view.addSubview(self.callSchedulePopup)
                                            self.callSchedulePopup.yourCallLabel.text = "Your CALL has been scheduled !"
                                             let data = responseDic["data"] as! [String: AnyObject]
                                            let callDateTime: String = data["callDateTime"] as! String
                                            let stringValue = "When: " + callDateTime
                                                                  let whenRange = stringValue.range(of: "When: ")
                                                                  
                                                                  let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                                                                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(whenRange!, in: stringValue))
                                                                  attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(whenRange!, in: stringValue))
                                                                  

                                                                 
                                                                  self.callSchedulePopup.whenLbl.attributedText = attributedString
                                            let userMsisdn = data["userMsisdn"] as! String
                                            
                                            let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn
                                            let scheduleDetails = ["callDateTime": callDateTime, "certNutText":certNutText, "userMsisdn": userMsisdn] as [String: AnyObject];
                                            UserDefaults.standard.set(scheduleDetails, forKey: "CALL_SCHEDULED_FROM_CLUB");
                                            UserDefaults.standard.synchronize()
                                           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_CALL_FLOATING_BUTTON"), object: nil);
                                                                  let msisdnRange = certNutText.range(of: userMsisdn)
                                                                  let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                                                                  certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                                                                  certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                                                                  self.callSchedulePopup.ourCerifiedNutritionistLbl.attributedText = certAttrStr
                                            
                    }
                }, failure : { error in
                    MBProgressHUD.hide(for: self.view, animated: true);
                    
                    print("failure")
                    if error?.code == -1011 {
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your payment was declined.");
                        return
                    }
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
                })
        

    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
           
           let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
           let strTimeStamp: String = "\(milliseconds)"
           return strTimeStamp
       }
    @IBAction func callScheduleButtonTApped(_ sender: Any) {
        self.navigationItem.hidesBackButton = true
        self.gettimeSlots()
        
    }
    func gettimeSlots() {
        self.timeSlotsArray = []
        MBProgressHUD.showAdded(to: self.view, animated: true);
                           
                                      APIWrapper.sharedInstance.getTimeSlots({ (responceDic : AnyObject!) -> (Void) in
                               if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                                   let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                                   
                                   if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                       MBProgressHUD.hide(for: self.view, animated: true)
                                       self.timeSlotsArray = (response["data"] as AnyObject) as! [[String : AnyObject]]
                                   self.navigationItem.hidesBackButton = true
                                    self.showCalendarView()
                                   } else {
                                           MBProgressHUD.hide(for: self.view, animated: true)
                                       }
                                   }
                                else {
                                   //error
                                   MBProgressHUD.hide(for: self.view, animated: true)
                               }
                           }) { (error : NSError!) -> (Void) in
                               //error
                               if error?.code == -1011 {
                                              
                                          } else {
                                              TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
                                          }
                                      }
    }
    func showCalendarView() {
        self.calendarOuterView.isHidden = false
        self.title = "SCHEDULE YOUR CALL"
        self.areYouSureLbl.layer.cornerRadius = 10
        self.calendarInnerView.layer.cornerRadius = 10
        self.calView.layer.cornerRadius = 10
      
        self.areYouSureLbl.isHidden = true
        self.calendarOuterView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        if self.packageID != "-NcInd5BosUcUeeQ9Q32" {
        calenderView.clubMemberExpDate = self.clubMembExpDate
        }
        self.calView.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: self.calView.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: self.calView.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: self.calView.leftAnchor, constant: 12).isActive=true
        calenderView.bottomAnchor.constraint(equalTo: self.calView.bottomAnchor, constant: 10).isActive=true
        let userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
                       
                       let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn
                   
                                             let msisdnRange = certNutText.range(of: userMsisdn)
                                             let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                                             certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                                             certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                                             self.ourNutritionistLbl.attributedText = certAttrStr
        if IS_iPHONE678 {
            //.self.innerCalendarViewHeightConstant.isActive = false
        calenderView.heightAnchor.constraint(equalToConstant: 250).isActive=true
        }else if IS_iPHONE678P {
            //.self.innerCalendarViewHeightConstant.isActive = false
        calenderView.heightAnchor.constraint(equalToConstant: 310).isActive=true
        }  else {
            //self.innerCalendarViewHeightConstant.isActive = false
            calenderView.heightAnchor.constraint(equalToConstant: 340).isActive=true
        }
    }
    @IBAction func getTimeSlotsBtnTapped(_ sender: Any) {
           self.timeSlotTextField.becomeFirstResponder()
              if self.timeSlotsArray.count > 0 {
              let dict = self.timeSlotsArray[0]
               //self.timeSlotTextField.text = (dict["ncts_timeslot"] as! String)
               self.pickerView.reloadAllComponents()

              }
              
       }
    @IBAction func languageBtnTapped(_ sender: Any) {
        if self.languageTableView.isHidden == true {
            MBProgressHUD.showAdded(to: self.view, animated: true)
                    APIWrapper.sharedInstance.getJSON(url: TweakAndEatURLConstants.CALL_SCHEDULE_LANGUAGES , { (responceDic : AnyObject!) -> (Void) in
                        if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                            let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                            
                            if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.languagesArray = response["data"] as! [[String: AnyObject]]
                                self.languageTableView.isHidden = false
                                self.languageTableView.reloadData()

                            } else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                            }
                         else {
                            //error
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }) { (error : NSError!) -> (Void) in
                        //error
                        if error?.code == -1011 {
                                       
                                   } else {
                                       TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
                                   }
                               }
                    }

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        scheduleLabel.numberOfLines = 0
        scheduleLabel.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)

//        self.scheduleLabel.layer.cornerRadius = 5
//        self.scheduleLabel.layer.borderWidth = 1
//        self.scheduleLabel.layer.borderColor = UIColor.darkGray.cgColor
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .groupTableViewBackground
        if self.packageID == "-NcInd5BosUcUeeQ9Q32" {
            self.title = "Nutritionist Consultant"
            self.navTitle = "Nutritionist Consultant"

        } else {
            self.title = "Tweak & Eat Club Member"
            self.navTitle = "Tweak & Eat Club Member"

        }
        self.captchaInnerView.layer.cornerRadius = 10
        self.refreshBtn.layer.cornerRadius = 10
        self.confirmCaptchaBtn.layer.cornerRadius = 10
        
        self.captchaGeneratorTF.text = fourDigitNumber
        self.languageTableView.backgroundColor = UIColor.groupTableViewBackground
         NotificationCenter.default.addObserver(self, selector: #selector(MoreInfoPremiumPackagesViewController.updateAreYouSureLbl), name: NSNotification.Name(rawValue: "DATE_SELECTED"), object: nil)
        self.scheduleBtn.layer.cornerRadius = 15
        self.cancelBtn.layer.cornerRadius = 15
        self.timeSlotTextField.delegate = self
        self.timeSlotTextField.inputView = self.pickerView
        self.timeSlotTextField.inputAccessoryView = self.accessoryToolbar
        if self.packageID == "-NcInd5BosUcUeeQ9Q32" {
            self.checkNCPSchedule()
        } else {
        self.checkClubMemberSchedule()
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             if tableView == moreInfoTableView {
                return self.moreInfoPremiumPackagesArray.count;
            } else if tableView == languageTableView {
                return self.languagesArray.count;
            } else {
                return self.nutritionLabelPriceArray.count
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //var cell :UITableViewCell!
            if tableView == moreInfoTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MoreInfoPackageTableViewCell;
                let cellDict = self.moreInfoPremiumPackagesArray[indexPath.row] as! [String : AnyObject];
                if countryCode == "1" || countryCode == "60" || countryCode == "91" || countryCode == "62" || countryCode == "65" {
                    let cellStr = cellDict["text"] as? String
                    cell.featuresLabel.text = "\n" + cellStr! + "\n"
                    if cellDict["free"] as! Bool == true {
                        cell.freeImage.image = UIImage.init(named: "tick_icon");
                        
                    } else {
                        cell.freeImage.image = UIImage.init(named: "x-icon.png");
                        
                        // cell.freeImage.isHidden = true;
                    }
                    if cellDict["paid"] as! Bool == true {
                        //cell.premiumImage.isHidden = false;
                        cell.premiumImage.image = UIImage.init(named: "tick_icon");
                        
                    } else {
                        cell.premiumImage.image = UIImage.init(named: "x-icon.png");
                        
                        
                        //cell.premiumImage.isHidden = true;
                    }
                } else  {
                    var cellStr = ""
                    if  cellDict["name"] as? String != nil {
                        cellStr = (cellDict["name"] as? String)!
                    }
                    
                    cell.featuresLabel.text =  "\n" + cellStr + "\n"
                    if cellDict["isFree"] as! Bool == true {
                        cell.freeImage.isHidden = false;
                    } else {
                        cell.freeImage.isHidden = true;
                    }
                    if cellDict["isPremium"] as! Bool == true {
                        cell.premiumImage.isHidden = false;
                    } else {
                        cell.premiumImage.isHidden = true;
                    }
                }
                return cell
                
            } else if tableView == languageTableView {
                       let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
                cell.contentView.backgroundColor = .groupTableViewBackground
                let cellDict = self.languagesArray[indexPath.row] ;
                cell.textLabel?.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = cellDict["mcl_name"] as? String
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pricesCell", for: indexPath)
                let cellDict = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
                let labels = (cellDict[lables] as? String)! + " ("
                let amount = "\(cellDict["display_amount"] as AnyObject as! Double)" + " "
                let currency = (cellDict["display_currency"] as? String)! + ")"
                let totalDesc: String = labels + amount + currency;
                cell.textLabel?.text = totalDesc
                
                cell.textLabel?.font = cell.textLabel?.font.withSize(16);
                cell.textLabel?.numberOfLines = 0
                return cell
            }
            // return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if tableView == self.priceTableView {
                return "Please choose a subscription plan"
            } else {
                return ""
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == priceTableView {
                selectedIndex = indexPath.row;
                self.labelPriceDict  = self.nutritionLabelPriceArray[indexPath.row] as! [String : AnyObject];
                self.pkgDescription = "\(labelPriceDict["pkgDescription"] as AnyObject as! String)";
                self.pkgDuration = labelPriceDict["pkgDuration"] as AnyObject as! String;
                self.price = "\(labelPriceDict["transPayment"] as AnyObject as! Double)";
                self.priceInDouble = labelPriceDict["transPayment"] as AnyObject as! Double;
                self.currency = "\(labelPriceDict["currency"] as AnyObject as! String)";
                let labels =  (self.labelPriceDict[lables] as? String)! + " ("
                let amount = "\(labelPriceDict["display_amount"] as AnyObject as! Double)" + " "
                
                let currency = (self.labelPriceDict["display_currency"] as? String)! + ")"
                let totalDesc: String = labels + amount + currency;
                if self.featuresView.isHidden == false {
                self.priceLabel.text = " " + totalDesc
                } else {
                    self.chooseSubScriptionPlanLbl.text = " " + totalDesc

                }
                
                self.buyNowButton.isEnabled = true
                self.priceTableView.isHidden = true
                self.productIdentifier = self.labelPriceDict["productIdentifier"] as AnyObject as! String
            } else if tableView == languageTableView {
                       let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
                
                let cellDict = self.languagesArray[indexPath.row] ;
                
                self.languageTextField.text = cellDict["mcl_name"] as? String
                self.languageTableView.isHidden = true
                self.updateAreYouSureLbl()
            }
        }
        
        @IBAction func closCaptchaView(_ sender: Any) {
            self.captchaView.isHidden = true
            self.view.endEditing(true)
        }
        

}
// MARK: - UIPickerViewDataSource

extension TweakandEatClubMemberVC: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int) -> Int {
    return self.timeSlotsArray.count
  }
}

// MARK: - UIPickerViewDelegate

extension TweakandEatClubMemberVC: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int) -> String? {
    let dict = self.timeSlotsArray[row];
    return (dict["ncts_timeslot"] as! String)
  }

  // Called when the scrolling stops and the row
  // in the center is set as selected.
  func pickerView(_ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int) {
    let dict = self.timeSlotsArray[row];
    self.timeSlotTextField.text = (dict["ncts_timeslot"] as! String)
  }
}
