//
//  WelcomeViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 02/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AssetsLibrary
import CoreLocation
import AVKit
import AVFoundation
import MobileCoreServices
import CoreData
import OneSignal
import Realm
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import CoreImage
import Realm
import RealmSwift

class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet var shadowImageTopConstraint: NSLayoutConstraint!
    @IBOutlet var ButtonTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var myEDRButton: UIButton!
    @IBOutlet var myProfileButton: UIButton!
    
    @IBOutlet var buzzButton: UIButton!
    
    @IBOutlet var myWallButton: UIButton!
    
    @IBOutlet var notificationBadgeLabel: UILabel!
    
    @IBOutlet var birdieImgView: UIImageView!
    @IBOutlet var tweakStreakCountButton: UIButton!
    @IBOutlet var settingsBarButton: UIBarButtonItem!
    @IBOutlet var faceDetectionImageView: UIImageView!
    @IBOutlet var faceDetectionView: UIView!
    var tweakView : TweakAnimationWelcomeView! = nil;
    var tweakTextView : TweakAndEatWelcomeScreen! = nil;
    var tweakOTPView : TweakAndEatOTPView! = nil;
    var tweakOptionView : TweakAndEatOptionsView! = nil;
    var tweakFinalView : TweakAndEatFinalIntroScreen! = nil;
    var tweakSelection : TweakAndEatSelectionView! = nil;
    var tweakTermsServiceView : TweakServiceAgreement! = nil;
    var tweakNoNetworkView : TweakAndEatNOIntenetVIew! = nil;
    var getTimelines : TimelinesDetailsViewController! = nil;
    var pieChartView : TweakPieChartView! = nil;
    
    @IBOutlet var tweakReactView: UIView!
    @IBOutlet weak var streakTextView: UIView!
    
    @IBOutlet weak var randomMessages: UILabel!
    var badgeCount: Int = 0
    var faceBox : UIView!
    var locManager = CLLocationManager();
    var selectedDate : String!;
    let requestId = "Request ID";
    let categoryId = "Category ID";
    var introTextArray : [AnyObject]? = nil;
    var comingFromSettings : Bool = false;
    var locationManager = CLLocationManager();
    var picker = UIImagePickerController();
    var dbArray:[AnyObject] = [];
    let textSaperator : String = "#";
    let realm :Realm = try! Realm()

    
    @IBOutlet weak var roundImageView: UIImageView!;
    
    @IBOutlet var shadowView: UIView!;
    var reachability : Reachability!;
    var latitude : String! = "0.0";
    var longitude : String! = "0.0";
    
    var appDelegateTAE : AppDelegate!;
    
    var msisdn : String? = nil;
    var selectedAge : NSString? = nil;
    var selectedGender : NSString! = "M";
    var selectedBodyShape : UIImageView? = nil;
    var weight : NSString? = nil;
    var height : NSString? = nil;
    
    override func viewDidLayoutSubviews() {
//        if UIScreen.main.bounds.size.height == 480 {
//            self.birdieImgView.isHidden = true
//            self.streakTextView.frame = CGRect(x:52, y: 245, width: self.streakTextView.frame.size.width, height: self.streakTextView.frame.size.height)
//            self.tweakReactView.frame = CGRect(x:26, y: 300, width: self.tweakReactView.frame.size.width, height: self.tweakReactView.frame.size.height)
//
//        }
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                self.setConstraints(forBtnTop: 20.0, forMyShadowTop: 0.0)
            case 1334:
                print("iPhone 6/6S/7/8")
                self.setConstraints(forBtnTop: 83.0, forMyShadowTop: 0.0)

            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                self.setConstraints(forBtnTop: 95.0, forMyShadowTop: 0.0)

            case 2436:
                print("iPhone X")
                self.setConstraints(forBtnTop: 105.0, forMyShadowTop: 0.0)

            default:
                print("unknown")
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.notificationBadgeLabel.layer.cornerRadius = self.notificationBadgeLabel.frame.size.width / 2
        self.notificationBadgeLabel.clipsToBounds = true
        self.notificationBadgeLabel.isHidden = true
        appDelegateTAE = UIApplication.shared.delegate as! AppDelegate;

        picker.delegate = self;
        self.tweakReactView.layer.borderWidth = 1;
        self.tweakReactView.layer.borderColor = UIColor.white.cgColor;
        self.tweakReactView.layer.cornerRadius = 5.0;
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.checkTweakable));
        roundImageView.isUserInteractionEnabled = true;
        roundImageView.addGestureRecognizer(tapGestureRecognizer);
        
        self.reachability = Reachability.forInternetConnection();
        self.reachability.startNotifier();
        
        self.tweakTermsServiceView = (Bundle.main.loadNibNamed("TweakServiceAgreement", owner: self, options: nil)! as NSArray).firstObject as! TweakServiceAgreement;
        
        locManager.delegate = self;
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        locManager.requestWhenInUseAuthorization();
        locManager.startMonitoringSignificantLocationChanges();
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            
            latitude = "\(locManager.location?.coordinate.latitude ?? 0.0)";
            longitude = "\(locManager.location?.coordinate.longitude ?? 0.0)";
            
        } else {
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.reachabilityChanged(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.badgeCountChanged(notification:)), name: NSNotification.Name(rawValue: "BADGECOUNT"), object: nil);
        self.getStaticText()
        
    }
    
    func showBadge() {
        let entities = self.realm.objects(BadgeCount.self)
        let id = entities.max(ofProperty: "id") as Int?
        let entity = id != nil ? entities.filter("id == %@", id!).first : nil
        if entity == nil {
            self.badgeCount = 0
        } else {
            self.badgeCount = (entity?.badgeCount)!
        }
        DispatchQueue.main.async(execute: {
            if self.badgeCount == 0 {
                self.notificationBadgeLabel.isHidden = true
            } else {
                self.notificationBadgeLabel.isHidden = false
                self.notificationBadgeLabel.text = String(self.badgeCount)
            }
            
        })
    }
    
    func badgeCountChanged(notification : NSNotification) {
      
       self.showBadge()
    }
    
    func setConstraints(forBtnTop: CGFloat, forMyShadowTop: CGFloat) {
        if forBtnTop != 0.0 {
            self.ButtonTopConstraint.constant = forBtnTop
        }
        
        if forMyShadowTop != 0.0 {
            self.shadowImageTopConstraint.constant = forMyShadowTop
        }
    }
    
    func getStaticText() {
        let showRegistration : Bool?  = UserDefaults.standard.value(forKey: "showRegistration") as? Bool;
        if(showRegistration == nil || showRegistration!) {
            
            self.tabBarController?.tabBar.isHidden = true;
            self.navigationController?.isNavigationBarHidden = true;
            
            tweakView = (Bundle.main.loadNibNamed("TweakAnimationWelcomeView", owner: self, options: nil)! as NSArray).firstObject as! TweakAnimationWelcomeView;
            tweakView.frame = self.view.frame;
            tweakView.delegate = self;
            self.view.addSubview(tweakView);
            tweakView.beginning();
            appDelegateTAE = UIApplication.shared.delegate as! AppDelegate;
            appDelegateTAE.networkReconnectionBlock = {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                APIWrapper.sharedInstance.getStaticText({ (responceDic : AnyObject!) ->(Void) in
                    if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                        self.tweakView.refreshView.isHidden = true

                        let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                        var welcomeText : NSString? = nil;
                        if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                            self.introTextArray = response[TweakAndEatConstants.DATA] as? [AnyObject];
                            if(self.introTextArray != nil) {
                                let introTextDic = self.introTextArray!.filter({ (element) -> Bool in
                                    if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.INTRO_TEXT) {
                                        return true;
                                    } else {
                                        return false;
                                    }
                                })
                                
                                if(introTextDic .count > 0) {
                                    welcomeText = (introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? NSString;
                                }
                                
                                if(welcomeText != nil) {
                                    let notesArray : [String] = welcomeText!.components(separatedBy: self.textSaperator)
                                    if(notesArray.count > 0) {
                                        self.tweakView.setWelcomeViewText(notesArray[0] as String, looseWeightText: notesArray[1] as String);
                                        MBProgressHUD.hide(for: self.view, animated: true);
                                        self.tweakView.animateLogo();
                                    }
                                }
                            }
                        }
                    } else {
                        //error
                        MBProgressHUD.hide(for: self.view, animated: true);
                    }
                }) { (error : NSError!) -> (Void) in
                    //error
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.tweakView.refreshView.isHidden = false

                }
            }
            if(self.reachability.currentReachabilityStatus() == NetworkStatus.NotReachable) {
                MBProgressHUD.hide(for: self.view, animated: true);
                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                // self.showNetworkFailureScreen();
                self.tweakView.refreshView.isHidden = false
            } else {
                appDelegateTAE.networkReconnectionBlock!();
            }
        }
    }
    
    func registrationProcess(){
        TweakAndEatUtils.AlertView.showAlert(view: self, message: "You account is in 'Blocked' status\n\nAn account is usually blocked if a user violates our 'Terms of Use'.You can please contact us at appsmanager@purpleteal.com to request ‘Unblocking’ the account.")
        
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.isNavigationBarHidden = true;
        tweakView = (Bundle.main.loadNibNamed("TweakAnimationWelcomeView", owner: self, options: nil)! as NSArray).firstObject as! TweakAnimationWelcomeView;
        tweakView.frame = self.view.bounds;
        tweakView.delegate = self;
        self.view.addSubview(tweakView);
        tweakView.beginning();
        appDelegateTAE = UIApplication.shared.delegate as! AppDelegate;
        appDelegateTAE.networkReconnectionBlock = {
            MBProgressHUD.showAdded(to: self.view, animated: true);
            APIWrapper.sharedInstance.getStaticText({ (responceDic : AnyObject!) ->(Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                    var welcomeText : NSString? = nil;
                    if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                        self.introTextArray = response[TweakAndEatConstants.DATA] as? [AnyObject];
                        if(self.introTextArray != nil) {
                            let introTextDic =  self.introTextArray!.filter({ (element) -> Bool in
                                if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.INTRO_TEXT) {
                                    return true;
                                } else {
                                    return false;
                                }
                            })
                            
                            if(introTextDic .count > 0) {
                                welcomeText = (introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? NSString;
                            }
                            
                            if(welcomeText != nil) {
                                let notesArray : [String] = welcomeText!.components(separatedBy: self.textSaperator)
                                if(notesArray.count > 0) {
                                    self.tweakView.setWelcomeViewText(notesArray[0] as String, looseWeightText: notesArray[1] as String);
                                    MBProgressHUD.hide(for: self.view, animated: true);
                                    self.tweakView.animateLogo();
                                }
                            }
                        }
                    }
                } else {
                    //error
                    MBProgressHUD.hide(for: self.view, animated: true);
                }
            }) { (error : NSError!) -> (Void) in
                //error
                MBProgressHUD.hide(for: self.view, animated: true);
                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
//        if(self.reachability.currentReachabilityStatus() == NetworkStatus.NotReachable) {
//            self.showNetworkFailureScreen();
//        } else {
//            appDelegateTAE.networkReconnectionBlock!();
//        }
        //  }
    }
    
    func takephoto()
    {
        
        let optionMenu = UIAlertController(title: nil, message: "Please choose or capture food items only!", preferredStyle: .actionSheet);
        
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true, completion: nil);
            }
            
        })
        let saveAction = UIAlertAction(title: "Choose from Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true, completion: nil);
            }
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(cameraAction);
        optionMenu.addAction(saveAction);
        optionMenu.addAction(cancelAction);
        
        // 5
        self.present(optionMenu, animated: true, completion: nil);
    }
    
    func ageAlert(){
        let alert = UIAlertController(title: "Alert", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
        super.touchesBegan(touches, with: event);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        roundImageView.layer.borderWidth = 5.0;
        roundImageView.backgroundColor = UIColor.white;
        roundImageView.clipsToBounds = true;
        roundImageView.layer.cornerRadius = roundImageView.frame.size.width / 2;
        shadowView.layer.cornerRadius = shadowView.frame.size.width / 2;
        roundImageView.layer.borderColor = UIColor(red: 196/255, green: 142/255, blue: 242/255, alpha: 1.0).cgColor;
        
        roundImageView.contentMode = UIViewContentMode.scaleAspectFill
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userdefaults = UserDefaults.standard
        if userdefaults.string(forKey: "userSession") != nil{
            self.tabBarController?.tabBar.isHidden = false
        }
           
        else {
            self.tabBarController?.tabBar.isHidden = true
            
        }
        if userdefaults.string(forKey: "USERBLOCKED") != nil{
            
            print("Here you will get saved value")
            UserDefaults.standard.removeObject(forKey: "USERBLOCKED")
            UserDefaults.standard.removeObject(forKey: "userSession")
            UserDefaults.standard.removeObject(forKey: "showRegistration")
            self.deleteAllData(entity: "TBL_Tweaks")
            self.deleteAllData(entity: "TBL_Contacts")
            self.deleteAllData(entity: "TBL_Reminders")
            self.alert()
            self.del()
            self.registrationProcess()
            
            //registrationProcess()
            return
        } else {
            print("No value in Userdefault,Either you can save value here or perform other operation")
            userdefaults.set("Here you can save value", forKey: "key")
        }
        
        if UserDefaults.standard.value(forKey: "userSession") as? String != nil {
            //  foodHabitsImages()
            // randomTitbitMessage()
            homeInfoApiCalls()
        }
        
        if(comingFromSettings == true){
            UIView.animate(withDuration: 1.0) {
                self.tabBarController?.tabBar.isHidden = false;
            }
            comingFromSettings = false;
        }
    }
    
    func alert(){
        self.registrationProcess()
    }
    
    
    func scheduleNotification(hour : String, min : String, title:String, body: String) {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init();
            content.title = title;
            content.body = body;
            content.categoryIdentifier = self.categoryId + hour + min;
            content.sound = UNNotificationSound(named: "birds018.wav");
            var dateInfo = DateComponents();
            dateInfo.hour = Int(hour);
            dateInfo.minute = Int(min);
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true);
            let request = UNNotificationRequest.init(identifier: self.requestId  + hour + min, content: content, trigger: trigger);
            
            schedule(request: request);
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 10.0, *)
    internal func schedule(request: UNNotificationRequest!) {
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
               // print("Your internet connection appears to be offline !!" as String!);
            }
        }
    }
    
    func addReminders() {
        
        APIWrapper.sharedInstance.getReminders(type: TBL_ReminderConstants.REMINDER_TYPE_TWEAK, { (responseDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                
                let reminders =  [
                    [
                        "rmdr_id": 1,
                        "rmdr_type": 1,
                        "rmdr_name": "Breakfast Tweak Reminder",
                        "rmdr_time": "08:00",
                        "rmdr_status": "N"
                    ] ,
                    [
                        "rmdr_id": 2,
                        "rmdr_type": 1,
                        "rmdr_name": "Lunch Tweak Reminder",
                        "rmdr_time": "13:00",
                        "rmdr_status": "Y"
                    ],
                    [
                        "rmdr_id": 3,
                        "rmdr_type": 1,
                        "rmdr_name": "Dinner Tweak Reminder",
                        "rmdr_time": "20:00",
                        "rmdr_status": "Y"
                    ]
                ]
                
                if(reminders.count > 0) {
                    for reminderObj in reminders {
                        
                        DataManager.sharedInstance.saveReminders(reminder: reminderObj as [String : AnyObject]);
                        let time = reminderObj["rmdr_time"] as AnyObject;
                        let rmdrName = reminderObj["rmdr_name"] as AnyObject;
                        var rmdrBody = "";
                        
                        if rmdrName as! String == "Breakfast Tweak Reminder"{
                            rmdrBody = " Good Morning! We’re ready to Tweak your Breakfast (7:30AM to 10AM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                        } else if rmdrName as! String == "Lunch Tweak Reminder"{
                            rmdrBody = " Good Afternoon! We’re ready to Tweak your Lunch (12:30PM to 3PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                            let timeArray = time.components(separatedBy: ":");
                            Notifications.schedule(hour: timeArray[0], min: timeArray[1], title: "Tweak & Eat" , body: reminderObj["rmdr_name"] as! String + rmdrBody)
                        } else if rmdrName as! String == "Dinner Tweak Reminder"{
                            rmdrBody = " Good Evening! We’re ready to Tweak your Dinner (7:30PM to 10PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                            let timeArray = time.components(separatedBy: ":");
                            Notifications.schedule(hour: timeArray[0], min: timeArray[1], title: "Tweak & Eat" , body: reminderObj["rmdr_name"] as! String + rmdrBody)
                            
                        }
                        
                        
                    }
                }
            }
        }) { (error : NSError!) -> (Void) in
            print("Error in reminders");
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func addReminder2(){
        
        APIWrapper.sharedInstance.getReminders(type: TBL_ReminderConstants.REMINDER_TYPE_DAILYTIP, { (responseDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responseDic as! [String:AnyObject];
                
                let reminder =  [
                    [
                        "rmdr_id": 4,
                        "rmdr_type": 2,
                        "rmdr_name": "Daily Tips",
                        "rmdr_time": "10:00",
                        "rmdr_status": "Y",
                        "rmdr_sort": 1
                    ]
                ]
                
                if(reminder.count > 0) {
                    for reminderObj in reminder {
                        DataManager.sharedInstance.saveReminders(reminder: reminderObj as [String : AnyObject]);
                        let time = reminderObj["rmdr_time"] as AnyObject;
                        let timeArray = time.components(separatedBy: ":");
                        
                        Notifications.schedule(hour: timeArray[0], min: timeArray[1], title: "Daily Tips" , body: "Your daily tip from Tweak & Eat! Click here.");
                        
                    }
                }
                
            }
            
        }) { (error : NSError!) -> (Void) in
            print("Error in reminders");
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func checkTweakable(){
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.CHECKTWEAKABLE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String
            if  responseResult == "GOOD" {
                print("Sucess")
                self.takephoto();
                
            } else{
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionistPopViewController") as! NutritionistPopViewController;
                self.addChildViewController(popOverVC);
                popOverVC.viewController = self
                popOverVC.popUp = true
                self.view.addSubview(popOverVC.view);
                popOverVC.didMove(toParentViewController: self);
                
            }
        }, failure : { error in
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
    
    func randomTitbitMessage(){
        
        APIWrapper.sharedInstance.getRandomTitBitMessage({(responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                let responseMessage = response["message"] as! String
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    self.randomMessages.text = responseMessage
                   // self.tweakStreak()
                }
            } else {
                
                print("error")
                
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func tweakStreak(){
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.TWEAKSTREAK, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String
            let tweakStreakCountValue = responseDic["tweakStreak"] as! Int
            if  responseResult == "GOOD" {
                print("Sucess")
                self.tweakStreakCountButton.titleLabel?.text =  String(tweakStreakCountValue as! Int)
                
            } else{
                let alertController = UIAlertController.init(title: nil, message: "Error", preferredStyle : .alert);
                alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler : nil));
                self.present(alertController, animated: true, completion: nil);
            }
        }, failure : { error in
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    
    
    func foodHabitsImages(){
    APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.USER_HOMEPAGE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            
            self.roundImageView.sd_setImage(with: URL(string: responseDic["homeImage"] as! String));
            
            
        }, failure : { error in
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    
    
    func homeInfoApiCalls(){
        
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.HOMEINFO, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            var responseDic : [String:AnyObject] = response as! [String:AnyObject];
            
            let tweakStreakCountValue = responseDic["tweakStreak"] as! Int
            UserDefaults.standard.setValue(responseDic["userStatus"], forKey: "userStatusInfo")
            
            let userStatus = responseDic["userStatus"] as! Int
            
            if  userStatus ==  1 {
                
                self.roundImageView.sd_setImage(with: URL(string: responseDic["homeImage"] as! String));
                self.tweakStreakCountButton.setTitle(String(tweakStreakCountValue ), for: .normal)
                self.showBadge()
                
                
                
            }
            else if  userStatus == 0{
                UserDefaults.standard.removeObject(forKey: "userSession")
                UserDefaults.standard.removeObject(forKey: "showRegistration")
                UserDefaults.standard.setValue("YES", forKey: "USERBLOCKED")
                self.deleteAllData(entity: "TBL_Tweaks")
                self.deleteAllData(entity: "TBL_Contacts")
                self.deleteAllData(entity: "TBL_Reminders")
                self.alert()
                self.del()
                
            }
            self.randomTitbitMessage()
            
        }, failure : { error in
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            MBProgressHUD.hide(for: self.view, animated: true);
        })
    }
    
    
    // delete all records fom CoreData
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    func del(){
        
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    func reachabilityChanged(notification : NSNotification) {
        //        let networkStatus : NetworkStatus = self.reachability.currentReachabilityStatus();
        //        if(networkStatus == NetworkStatus.NotReachable) {
        //            self.showNetworkFailureScreen();
        //        } else {
        //            if(appDelegateTAE.networkReconnectionBlock != nil) {
        //                appDelegateTAE.networkReconnectionBlock!();
        //            }
        //            if(tweakNoNetworkView != nil) {
        //                tweakNoNetworkView.removeFromSuperview();
        //                tweakNoNetworkView = nil;
        //            }
        //        }
    }
    
    func showNetworkFailureScreen() {
        if(tweakNoNetworkView == nil) {
            tweakNoNetworkView = (Bundle.main.loadNibNamed("TweakAndEatNOIntenetVIew", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatNOIntenetVIew;
            tweakNoNetworkView.frame = self.view.frame;
            tweakNoNetworkView.beginning();
            self.view.addSubview(tweakNoNetworkView);
        } else {
            self.view.addSubview(tweakNoNetworkView);
        }
    }
    
    func switchToSecondScreen() {
        if(self.introTextArray != nil && (self.introTextArray?.count)! > 0) {
            
            tweakTextView = (Bundle.main.loadNibNamed("TweakAndEatWelcomeScreen", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatWelcomeScreen;
            tweakTextView.frame = self.view.frame;
            tweakTextView.delegate = self;
            tweakTextView.beginning();
            self.view.addSubview(tweakTextView);
            
            tweakView.removeFromSuperview();
            let introTextDic = self.introTextArray!.filter({ (element) -> Bool in
                if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.DATA_TEXT) {
                    return true;
                } else {
                    return false;
                }
            })
            
            
            var welcomeText : String? = nil;
            
            if(introTextDic.count > 0) {
                welcomeText = (introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? String;
            }
            
            
            if(welcomeText != nil) {
                self.changeFonts((welcomeText!.html2AttributedString.mutableCopy()) as! NSMutableAttributedString);
            }
            
        }
    }
    
    func switchToThirdScreen() {
        
        tweakOTPView = (Bundle.main.loadNibNamed("TweakAndEatOTPView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatOTPView;
        tweakOTPView.frame = self.view.frame;
        tweakOTPView.delegate = self;
        tweakOTPView.beginning();
        self.view.addSubview(tweakOTPView);
        tweakTextView.removeFromSuperview();
        
    }
    
    func switchToFourthScreen() {
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        appDelegateTAE.networkReconnectionBlock = {
            TweakAndEatUtils.showMBProgressHUD();
            APIWrapper.sharedInstance.getAgeGroups({ (responceDic : AnyObject!) -> (Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                    
                    if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                        let ageGroups : [AnyObject]? = response[TweakAndEatConstants.DATA] as? [AnyObject];
                        
                        if(ageGroups != nil && (ageGroups?.count)! > 0) {
                            self.tweakOptionView = (Bundle.main.loadNibNamed("TweakAndEatOptionsView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatOptionsView;
                            self.tweakOptionView.frame = self.view.frame;
                            self.view.addSubview(self.tweakOptionView);
                            self.tweakOTPView.removeFromSuperview();
                            self.tweakOptionView.beginning();
                            self.tweakOptionView.delegate = self;
                            self.perform(#selector(WelcomeViewController.setAgeAndGenderView(_:)), with: ageGroups, afterDelay: 1.0);
                        } else {
                            TweakAndEatUtils.hideMBProgressHUD();
                        }
                    }
                } else {
                    //error
                    TweakAndEatUtils.hideMBProgressHUD();
                }
            }) { (error : NSError!) -> (Void) in
                //error
                TweakAndEatUtils.hideMBProgressHUD();
                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        appDelegateTAE.networkReconnectionBlock!();
    }
    
    func switchToFifthScreen(){
        
        self.tweakSelection = (Bundle.main.loadNibNamed("TweakAndEatSelectionView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatSelectionView;
        tweakSelection.frame = self.view.frame;
        tweakSelection.delegate = self;
        tweakSelection.beginning();
        tweakSelection.setUpViews()
        self.view.addSubview(tweakSelection);
        tweakOptionView.removeFromSuperview();
        
    }
    
    func switchToSixthScreen(){
        
        self.switchToSeventhScreen1();
        
    }
    
    func switchToSeventhScreen(){
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        self.tweakFinalView = (Bundle.main.loadNibNamed("TweakAndEatFinalIntroScreen", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatFinalIntroScreen;
        tweakFinalView.frame = self.view.frame;
        tweakFinalView.delegate = self;
        tweakFinalView.beginning();
        self.view.addSubview(self.tweakFinalView);
        pieChartView.removeFromSuperview();
        
    }
    
    func switchToEighthScreen(){
        self.tweakTermsServiceView = (Bundle.main.loadNibNamed("TweakServiceAgreement", owner: self, options: nil)! as NSArray).firstObject as! TweakServiceAgreement;
        tweakTermsServiceView.frame = self.view.frame;
        tweakTermsServiceView.delegate = self;
        self.view.addSubview(self.tweakTermsServiceView);
        tweakSelection.removeFromSuperview();
        tweakTermsServiceView.agreedBtn.isHighlighted = true
        tweakTermsServiceView.agreedBtn.isUserInteractionEnabled = false
        tweakTermsServiceView.termsServiceTextView.layer.cornerRadius = 8
        tweakTermsServiceView.agreedBtn.layer.cornerRadius = 5
        
        let termsOfUseTextDic = self.introTextArray!.filter({ (element) -> Bool in
            if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.TERMS_OF_USE) {
                return true;
            } else {
                return false;
            }
        })
        
        var termsOfUse : String? = nil;
        
        if(termsOfUseTextDic.count > 0) {
            termsOfUse = (termsOfUseTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? String;
        }
        
        
        if(termsOfUse != nil) {
            self.changeFonts1((termsOfUse!.html2AttributedString.mutableCopy()) as! NSMutableAttributedString);
        }
        
        
    }
    
    
    func switchToSeventhScreen1() {
        
        appDelegateTAE.networkReconnectionBlock = {
            
            MBProgressHUD.showAdded(to: self.view, animated: true);
            
            let userInfo = NSMutableDictionary()
            userInfo.setValue(self.msisdn, forKey: "msisdn");
            
            let deviceToken : String? = UserDefaults.standard.value(forKey: "deviceToken") as? String;
            if(deviceToken != nil) {
                userInfo.setValue(deviceToken!, forKey: "deviceId");
            } else {
                userInfo.setValue("APA91bHPRgkF3JUikC4ENAHEeMrd41Zxv3hVZjC9KtT8OvPVGJ-hQMRKRrZuJAEcl7B338qju59zJMjw2DELjzEvxwYv7hH5Ynpc1ODQ0aT4U4OFEeco8ohsN5PjL1iC2dNtk2BAokeMCg2ZXKqpc8FXKmhX94kIxQ", forKey: "deviceId");
            }
            if self.tweakOptionView.delegate.selectedGender == "M" {
                userInfo.setValue("M", forKey: "gender");
            } else {
                userInfo.setValue("F", forKey: "gender");
            }
            if self.tweakOptionView.bodyshapenumber == nil {
                if self.tweakOptionView.maleLabel.text == "M" {
                    userInfo.setValue("1", forKey: "bodyShape");
                } else {
                    userInfo.setValue("6", forKey: "bodyShape");
                }
            } else {
                userInfo.setValue(self.tweakOptionView.bodyshapenumber, forKey: "bodyShape");
            }
            userInfo.setValue("", forKey: "gcmId")
            
            for _ in self.tweakSelection.selectedAllergies {
                let element = self.tweakSelection.selectedAllergies.joined(separator: ",")
                print(element)
                userInfo.setValue(element, forKey: "allergies")
            }
            if self.tweakSelection.selectedAllergies.count == 0{
                userInfo.setValue("", forKey: "allergies")
            }
            
            
            for _ in self.tweakSelection.selectedConditions {
                let element = self.tweakSelection.selectedConditions.joined(separator: ",")
                print(element)
                userInfo.setValue(element , forKey: "conditions")
            }
            if self.tweakSelection.selectedConditions.count == 0{
                userInfo.setValue("", forKey: "conditions")
            }
            
            
            userInfo.setValue(self.tweakOptionView.nickNameField.text, forKey: "nickName")
            if self.tweakSelection.foodhabit == "" {
                userInfo.setValue("1", forKeyPath: "foodhabit")
            } else {
                userInfo.setValue(self.tweakSelection.foodhabit, forKeyPath: "foodhabit")
            }
            userInfo.setValue("1", forKey: "ageGroup");
            userInfo.setValue(self.tweakOptionView.ageTextField.text, forKey: "age");
            userInfo.setValue(self.tweakOptionView.weightTextField.text, forKey: "weight");
            userInfo.setValue(self.tweakOptionView.heightTextField.text, forKey: "height");
            
            let newUser = NSDictionary(object: userInfo, forKey: "newUser" as NSCopying);
            APIWrapper.sharedInstance.registerNewUser(newUser, successBlock: { (responceDic : AnyObject!) -> (Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response  = responceDic as! [String : AnyObject];
                    // UserDefaults.standard.removeObject(forKey: "userSession")
                    UserDefaults.standard.setValue(response["userSession"] as Any, forKey: "userSession");
                    UserDefaults.standard.setValue(self.msisdn, forKey: "msisdn");
                    //  UserDefaults.standard.setValue(response["userPassword"], forKey: "userPassword")
                    let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
                    let firebaseUserName = response["fbUserName"] as! String
                    let firebasePassword = response["fbUserPass"] as! String
                    
                    let profile = MyProfileInfo()
                    profile.id = self.incrementID()
                    profile.name = self.tweakOptionView.nickNameField.text!
                    profile.age = self.tweakOptionView.ageTextField.text!
                    if self.tweakOptionView.delegate.selectedGender == "M" {
                        profile.gender = "M"
                    } else {
                        profile.gender = "F"
                    }
                    profile.msisdn = self.msisdn!
                    profile.weight = self.tweakOptionView.weightTextField.text!
                    profile.height = self.tweakOptionView.heightTextField.text!
                    if self.tweakSelection.food.count > 0 {
                        profile.foodHabits = self.tweakSelection.food.joined(separator: ",")
                    } else {
                        profile.foodHabits = ""
                    }
                    if self.tweakSelection.allergy.count > 0 {
                        profile.allergies = self.tweakSelection.allergy.joined(separator: ",")
                    } else {
                        profile.allergies = ""
                    }
                    if self.tweakSelection.conditions.count > 0 {
                        profile.conditions = self.tweakSelection.conditions.joined(separator: ",")
                    } else {
                        profile.conditions = ""
                    }
                    if self.tweakOptionView.bodyshapenumber == nil {
                        if profile.gender == "M" {
                            profile.bodyShape = "1"
                        } else {
                            profile.bodyShape = "6"
                        }
                    } else {
                        profile.bodyShape = self.tweakOptionView.bodyshapenumber
                    }
                    
                    saveToRealmOverwrite(objType: MyProfileInfo.self, objValues: profile)
                    
                    let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
                    // let pushToken = status.subscriptionStatus.pushToken
                    let userId = status.subscriptionStatus.userId;
                    if userId != nil {
                    UserDefaults.standard.setValue(userId! as String, forKey: "PLAYER_ID");
                    } else {
                        self.tabBarController?.tabBar.isHidden = true
                        let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Refresh", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    
                    
                    self.getTimeLines();
                    APIWrapper.sharedInstance.sendGCM(["gcmId":UserDefaults.standard.value(forKey: "PLAYER_ID") as Any], userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                        print("Sucess");
                        
                        APIWrapper.sharedInstance.getRequestWithHeader( sessionString: userSession,TweakAndEatURLConstants.INVITED_EXISTING_FRIEND, success: { response in
                            self.dbArray = ((response["friends"]) as AnyObject!) as! [AnyObject]
                            for contact in self.dbArray {
                                
                                let favoriteContact = NSEntityDescription.insertNewObject(forEntityName: "TBL_Contacts", into: context) as! TBL_Contacts;
                                let msisdn = contact["msisdn"] as AnyObject! as? String
                                favoriteContact.contact_name = contact["name"] as AnyObject! as? String
                                favoriteContact.contact_number = msisdn as AnyObject as? String;
                                favoriteContact.contact_profilePic = contact["imageData"] as AnyObject! as? NSData;
                                favoriteContact.contact_selectedDate = Date() as NSDate?;
                                DatabaseController.saveContext();
                            }
                            
                            TweakAndEatUtils.hideMBProgressHUD();
                            MBProgressHUD.hide(for: self.view, animated: true);
                            
                            Auth.auth().signIn(withEmail: firebaseUserName, password: firebasePassword) { (user, error) in
                                
                                if error == nil {
                                    
                                    //Print into the console if successfully logged in
                                    print("You have successfully logged in")
                                    
                                    self.getProfileData()
                                    
                                    //Go to the HomeViewController if the login is sucessful
                                    
                                } else {
                                    
                                    //Tells the user that there is an error and then gets firebase to tell them the error
                                    let alertController = UIAlertController(title: "Error", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                                    
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                            
                        }, failure: { error in
                            print("failure");
                            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                            TweakAndEatUtils.hideMBProgressHUD();
                        })
                        
                    }, failureBlock: {(error : NSError!) -> (Void) in
                        print("Failure");
                        let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        TweakAndEatUtils.hideMBProgressHUD();
                        
                    })
                    
                }
                
            }, failureBlock: { (error : NSError!) -> (Void) in
                //error
                print("error");
                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                MBProgressHUD.hide(for: self.view, animated: true);
            })
        }
        appDelegateTAE.networkReconnectionBlock!();
    }
    
    
    func getTimeLines(){
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getTimelines(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                let tweaks : [AnyObject]? = response[TweakAndEatConstants.TWEAKS] as? [AnyObject];
                if(tweaks != nil) {
                    for tweak in tweaks! {
                        DataManager.sharedInstance.saveTweak(tweak: tweak as! NSDictionary);
                        
                    }
                    self.addReminders();
                    
                }
                
            }
            
        }) { (error : NSError!) -> (Void) in
            print("failure");
            
            self.addReminders();
            TweakAndEatUtils.hideMBProgressHUD();
        }
        
    }
    
    func resignRegistrationScreen() {
        
        self.tweakFinalView.removeFromSuperview();
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.isNavigationBarHidden = false;
        UserDefaults.standard.setValue(false, forKey: "showRegistration");
    }
    
    func setAgeAndGenderView(_ ageGroups : [AnyObject]?) {
        
        self.tweakOptionView.setGenderOptions();
        self.tweakOptionView.setImageViewsOfGender();
        TweakAndEatUtils.hideMBProgressHUD();
    }
    
    func changeFonts(_ htmlString : NSMutableAttributedString) {
        htmlString.beginEditing();
        htmlString.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                let oldFont : UIFont = value as! UIFont;
                htmlString.removeAttribute(NSFontAttributeName, range: range);
                
                if(oldFont.fontName == "TimesNewRomanPS-BoldMT") {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Semibold", size: 20)!;
                    htmlString.addAttribute(NSFontAttributeName, value: newFont, range: range);
                } else {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Regular", size: 15)!;
                    htmlString.addAttribute(NSFontAttributeName, value: newFont, range: range);
                }
            }
        })
        
        htmlString.enumerateAttribute(NSForegroundColorAttributeName, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                htmlString.removeAttribute(NSForegroundColorAttributeName, range: range);
                htmlString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 147.0/255, green: 147.0/255, blue: 147.0/255, alpha: 1.0), range: range);
            }
        })
        
        htmlString.endEditing();
        tweakTextView.setIntroText(htmlString);
    }
    
    func changeFonts1(_ htmlString : NSMutableAttributedString) {
        htmlString.beginEditing();
        htmlString.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                let oldFont : UIFont = value as! UIFont;
                htmlString.removeAttribute(NSFontAttributeName, range: range);
                
                if(oldFont.fontName == "TimesNewRomanPS-BoldMT") {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Semibold", size: 15)!;
                    htmlString.addAttribute(NSFontAttributeName, value: newFont, range: range);
                } else {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Regular", size: 13)!;
                    htmlString.addAttribute(NSFontAttributeName, value: newFont, range: range);
                }
            }
        })
        
        htmlString.enumerateAttribute(NSForegroundColorAttributeName, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                htmlString.removeAttribute(NSForegroundColorAttributeName, range: range);
                htmlString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 147.0/255, green: 147.0/255, blue: 147.0/255, alpha: 1.0), range: range);
            }
        })
        
        htmlString.endEditing();
        tweakTermsServiceView.setTermsOfUse(htmlString);
    }
    
    @IBAction func onClickOfSettings(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let tabBarController : UITabBarController = storyBoard.instantiateViewController(withIdentifier: "settingsTabController") as! SettingsTabBarController;
        //tabBarController.selectedIndex = 2
        self.navigationController?.pushViewController(tabBarController, animated: true);
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOfCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            checkTweakable()
        } else {
            noCamera();
        }
        
    }
    
    @IBAction func onClickOfShadowImage(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            checkTweakable()
            
        } else {
            noCamera();
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert);
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction);
        present(alertVC, animated: true, completion: nil);
    }
    
    @IBAction func onClickOfNotification(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Tweak Notification", message: "Coming Soon..", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func onClickOfProfile(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Contacts", message: "Coming Soon..", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func onClickOfSlider(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let timelineViewController : TimelinesViewController = storyBoard.instantiateViewController(withIdentifier: "timelinesViewController") as! TimelinesViewController;
        self.navigationController?.pushViewController(timelineViewController, animated: true);
    }
    
    @IBAction func navigateToSettings(_ sender: AnyObject) {
        comingFromSettings = true;
        UIView.animate(withDuration: 1.0) {
            self.tabBarController?.tabBar.isHidden = true;
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let tabBarController : UITabBarController = storyBoard.instantiateViewController(withIdentifier: "settingsTabController") as! UITabBarController;
        self.navigationController?.pushViewController(tabBarController, animated: true);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
    }
    
    func faceDetection(detect: UIImage) {
        
        guard let personciImage = CIImage(image: detect) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        print(faces!.count)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        var message: String = "We detected a face!"
        if faces!.count > 5 {
            message = "We detected so many faces!"
        } else if faces!.count > 1 && faces!.count <= 2 {
            message = "We detected faces!"
        } else if faces!.count == 2 {
            message = "We detected 2 faces!"
        } else if faces!.count == 3 {
            message = "We detected 3 faces!"
        }  else if faces!.count == 4 {
            message = "We detected 4 faces!"
        }  else if faces!.count == 5 {
            message = "We detected 5 faces!"
        }
        message = message +  " If it is food item, then please zoom the image and tweak again!!"
        for face in faces as! [CIFaceFeature] {
            var faceViewBounds = face.bounds.applying(transform)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
        if faces!.count > 0 {
            let alert = UIAlertController(title: "Say Cheese!", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        let imageData: NSData = UIImageJPEGRepresentation(detect, 0.6)! as NSData
        let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let str = "data:image/jpeg;base64,";
        let imgBase64 = str + strBase64;
        
        let tweakImageParams : [String : String] = ["fromOs" : "IOS", "lat" : latitude, "lng" : longitude, "newImage" : imgBase64];
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakShareViewController") as! TweakShareViewController;
        clickViewController.tweakImage = detect  as UIImage;
        clickViewController.parameterDict1 = tweakImageParams as [String : String];
        
        self.navigationController?.pushViewController(clickViewController, animated: true);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            dismiss(animated:true, completion: nil);
            self.faceDetection(detect: image)
            
        }
        
    }
    
    func getProfileData(){
        if UserDefaults.standard.value(forKey: "userSession") as? String != nil {
            APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.PROFILEFACTS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                
                
                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                if responseDic.count == 2 {
                    let responseResult =  responseDic["profileData"] as! [String : Int]
                    //let values = responseResult["proteinPerc"]!
                    let chartValues = TweakPieChartValues()
                    chartValues.id = self.incrementID()
                    chartValues.carbsPerc = responseResult["carbsPerc"]!
                    chartValues.proteinPerc = responseResult["proteinPerc"]!
                    chartValues.fatPerc = responseResult["fatPerc"]!
                    chartValues.fiberPerc = responseResult["fiberPerc"]!
                    saveToRealmOverwrite(objType: TweakPieChartValues.self, objValues: chartValues)
                }
                
                self.pieChartView = (Bundle.main.loadNibNamed("TweakPieChartView", owner: self, options: nil)! as NSArray).firstObject as! TweakPieChartView;
                self.pieChartView.frame = self.view.frame;
                self.pieChartView.delegate = self;
                self.pieChartView.beginning();
                
                self.view.addSubview(self.pieChartView);
                self.tweakTermsServiceView.removeFromSuperview();
                
                
            }, failure : { error in
                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            })
        }
        
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.faceDetectionView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.settingsBarButton.isEnabled = true
    }
    
    @IBAction func tweakStreakCountButtonTapped(_ sender: Any) {
    }
    
    @IBAction func announcementsBtnTapped(_ sender: Any) {
    }
    
    @IBAction func myProfileButtonTapped(_ sender: Any) {
    }
    
    @IBAction func buzzButtonTapped(_ sender: Any) {
    }
    
    @IBAction func myWallButtonTapped(_ sender: Any) {
    }
    
    @IBAction func myEDRButtonTapped(_ sender: Any) {
    }
    
    
    
}
