//
//  FullImageViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 08/10/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift


class FullImageViewController: UIViewController, UITextViewDelegate {
    @objc var tweakUserComments = ""
    @IBOutlet weak var cancelBtn: UIButton!;
    @IBOutlet var imageView: UIImageView!;
    @objc var imageUrl : String!;
    @objc var fullImage: UIImage!;
    var shareAction : Bool?;
    @objc var tweakFeedsRef : DatabaseReference!;
    @objc var TimelineTableViewCell : TimelineTableViewCell? = nil;
    @objc var timelineDetails : TimelinesDetailsViewController? = nil;
    let realm :Realm = try! Realm();
    var myProfileInfo : Results<MyProfileInfo>?;
    @IBOutlet var shareBtn: UIButton!;
    @IBOutlet weak var placeHolderLabel: UILabel!;
    @IBOutlet weak var commentsView: UIView!;
    @IBOutlet weak var tweakFeedComments: UITextView!;
    @objc var nicKName : String = "";
    @objc var sex : String = "";
    @objc var userMsisdn : String = "";
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @IBOutlet var titleLabel: UILabel!;
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardFrame.height
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tweakFeedComments.text = self.tweakUserComments
        if self.tweakFeedComments.text.count > 0 {
            self.placeHolderLabel.isHidden = true;
        }
        self.tweakFeedComments.font = UIFont.systemFont(ofSize: 17)
        NotificationCenter.default.addObserver(self, selector: #selector(FullImageViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(FullImageViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }
        
        self.titleLabel.text = self.bundle.localizedString(forKey: "post_tweakwall", value: nil, table: nil)
        self.placeHolderLabel.text = self.bundle.localizedString(forKey: "refill_comment", value: nil, table: nil)
        
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        tweakFeedsRef = Database.database().reference();
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self);
        for myProfObj in self.myProfileInfo! {
            nicKName = myProfObj.name;
            sex = myProfObj.gender;
            
        }
        tweakFeedComments.delegate = self;
        tweakFeedComments.autocorrectionType = .yes;
        tweakFeedComments.layer.cornerRadius = 10;
        tweakFeedComments.layer.borderWidth = 1;
        tweakFeedComments.layer.borderColor = UIColor.black.cgColor;
        shareBtn.layer.cornerRadius = shareBtn.frame.size.width / 2;
        
       // imageView.sd_setImage(with: URL(string: imageUrl));
        imageView.image = fullImage;
        if shareAction == true{
            self.navigationController?.navigationBar.isHidden = true;
            self.commentsView.isHidden = true;
            self.titleLabel.isHidden = true;
            self.cancelBtn.isHidden = true;
        }
        else{
            
            let ref = Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "imageUrl").queryEqual(toValue : imageUrl)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key);
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "share_alert", value: nil, table: nil));
                    self.shareBtn.isUserInteractionEnabled = false;
                    self.tweakFeedComments.isUserInteractionEnabled = false;
                    
                }
            })
            self.navigationController?.navigationBar.isHidden = false;
            self.commentsView.isHidden = false;
            self.titleLabel.isHidden = false;
            self.cancelBtn.isHidden = false;
        }
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
         self.dismiss(animated: false, completion: nil)
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        self.view.frame = CGRect(x:0, y:-220, width: self.view.frame.size.width, height: self.view.frame.size.height);
//    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderLabel?.isHidden = false;
            
        }
        else {
            placeHolderLabel?.isHidden = true;
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            placeHolderLabel?.isHidden = false;
            
        }
        else {
            placeHolderLabel?.isHidden = true;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
//        self.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height);
        
        super.touchesBegan(touches, with: event);
    }
    
    @IBAction func onClickOfFullImage(_ sender: Any) {
        //self.dismiss(animated:true, completion: nil);
        view.endEditing(true);

        if shareAction == true{
        }else{
            
        }
    }
    
    @IBAction func dismissImageView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000);
        let strTimeStamp: String = "\(milliseconds)";
        return strTimeStamp;
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // convert Date to TimeInterval (typealias for Double)
        let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate);
        let currentTime = Int64(currentTimeStamp);
        
        // convert to Integer
       // DispatchQueue.global(qos: .background).async {
            if UserDefaults.standard.value(forKey: "COUNTRY_ISO") != nil {
                let eventName = TweakAndEatUtils.getEventNames(countryISO: UserDefaults.standard.value(forKey: "COUNTRY_ISO") as AnyObject as! String, eventName: "sharing_on_tweak_wall")
                print(eventName)
                Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "Sharing on tweak wall"])
            }
            var autoChildId = ""

            
           
          //  if self.tweakUserComments != "" {
                self.tweakFeedsRef.child("TweakFeeds").childByAutoId().setValue(["feedContent": self.tweakFeedComments.text! as AnyObject, "imageUrl": self.imageUrl!, "gender": self.sex, "postedOn" : currentTime! , "tweakOwner": self.nicKName, "msisdn" : self.userMsisdn, "awesomeCount" : 0, "commentsCount" : 0] as [String : AnyObject], withCompletionBlock: { (error, _) in
                if error == nil {
                    //api
                    self.showAlertSuccess()

                } else {
                }
                    })
           // }
//            else {
//                autoChildId = self.tweakFeedsRef.child("TweakFeeds").childByAutoId().key
//            self.tweakFeedsRef.child("TweakFeeds").child(autoChildId).setValue(["feedContent": self.tweakFeedComments.text! as AnyObject, "imageUrl": self.imageUrl!, "gender": self.sex, "postedOn" : currentTime! , "tweakOwner": self.nicKName, "msisdn" : self.userMsisdn, "awesomeCount" : 0, "commentsCount" : 0] as [String : AnyObject], withCompletionBlock: { (error, _) in
//
//            if error == nil {
//                //api
//                self.tweakFeedsRef.child("TweakFeeds").child(autoChildId).child("comments").childByAutoId().setValue(["msisdn" : "","postedOn" : currentTime as AnyObject,"commentText": "Hi\nTake a photo of your plate from the app. Then there is a comments box below the photo - just name your food in the box before you tweak (send) it." as AnyObject,"nickName": "Tweak & Eat Team" as AnyObject], withCompletionBlock: { (error, _) in
//                if error == nil {
//                    //api
//
//                    self.tweakFeedsRef.child("TweakFeeds").child(autoChildId).updateChildValues(["commentsCount" : 1 as AnyObject], withCompletionBlock: { (error, _) in
//                    if error == nil {
//                        //api
//
//
//                        self.showAlertSuccess()
//
//                    } else {
//                    }
//                        })
//
//                } else {
//                }
//                    })
//
//
//            } else {
//            }
//                })
//
//
//        }
        //}
    }
    
    func showAlertSuccess() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true);
            self.tweakFeedComments.text = "";
            self.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height);
            self.view.endEditing(true);
            let alert = UIAlertController(title: "", message: self.bundle.localizedString(forKey: "shared_tweak_alert", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
          
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_SHARED"), object: nil);
                                            self.dismiss(animated: true, completion: nil);
            }))
            self.present(alert, animated: true, completion: nil)
           // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "shared_tweak_alert", value: nil, table: nil))

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
