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
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var imageView: UIImageView!;
    var imageUrl : String!;
    var shareAction : Bool?
    var tweakFeedsRef : DatabaseReference!;
    var TimelineTableViewCell : TimelineTableViewCell? = nil;
    var timelineDetails : TimelinesDetailsViewController? = nil;
    let realm :Realm = try! Realm();
    var myProfileInfo : Results<MyProfileInfo>?;
    @IBOutlet var shareBtn: UIButton!;
    @IBOutlet weak var placeHolderLabel: UILabel!;
    @IBOutlet weak var commentsView: UIView!;
    @IBOutlet weak var tweakFeedComments: UITextView!;
    var nicKName : String = "";
    var sex : String = "";
    var userMsisdn : String = "";
   
    
    @IBOutlet var titleLabel: UILabel!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        tweakFeedsRef = Database.database().reference();
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self);
        for myProfObj in self.myProfileInfo! {
            nicKName = myProfObj.name;
            sex = myProfObj.gender;
            
        }
        tweakFeedComments.delegate = self;
        tweakFeedComments.autocorrectionType = .no;
        tweakFeedComments.layer.cornerRadius = 10;
        tweakFeedComments.layer.borderWidth = 1;
        tweakFeedComments.layer.borderColor = UIColor.black.cgColor;
        shareBtn.layer.cornerRadius = shareBtn.frame.size.width / 2;
        
        imageView.sd_setImage(with: URL(string: imageUrl));
        if shareAction == true{
            self.navigationController?.navigationBar.isHidden = true;
            self.commentsView.isHidden = true;
            self.titleLabel.isHidden = true;
            self.cancelBtn.isHidden = true;
        }
        else{
            let ref = Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "imageUrl").queryEqual(toValue : imageUrl)
            
            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key)
                    TweakAndEatUtils.AlertView.showAlert(view: self, message: "This tweak has already been shared to tweak wall!")
                    self.shareBtn.isUserInteractionEnabled = false
                    self.tweakFeedComments.isUserInteractionEnabled = false
                    //                self.shareBtn?.setImage(UIImage(named: "SharedBtn.png"), for: .normal)
                    
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
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        self.view.frame = CGRect(x:0, y:-220, width: self.view.frame.size.width, height: self.view.frame.size.height);
        
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        placeHolderLabel?.isHidden = true;
//
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
       // placeHolderLabel?.isHidden = false;
        self.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height);
        
        super.touchesBegan(touches, with: event);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOfFullImage(_ sender: Any) {
        self.dismiss(animated:true, completion: nil);
        if shareAction == true{
            //self.dismiss(animated:true, completion: nil);
        }else{
            
        }
    }
    
    @IBAction func dismissImageView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil);
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000);
        let strTimeStamp: String = "\(milliseconds)";
        return strTimeStamp;
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        // convert Date to TimeInterval (typealias for Double)
        let currentTimeStamp = getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate);
        let currentTime = Int64(currentTimeStamp);
        
        // convert to Integer
        self.tweakFeedsRef.child("TweakFeeds").childByAutoId().setValue(["feedContent": tweakFeedComments.text! as AnyObject, "imageUrl": imageUrl!, "gender": self.sex, "postedOn" : currentTime! , "tweakOwner": self.nicKName, "msisdn" : self.userMsisdn, "awesomeCount" : 0, "commentsCount" : 0] as [String : AnyObject]);
       
        let alert = UIAlertController(title: "Alert", message: "Your Tweak has been Shared to Tweak Wall Sucessfully!", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil);
            self.tabBarController?.selectedIndex = 4

        }))
        
        self.present(alert, animated: true, completion: nil);

        self.tweakFeedComments.text = "";
        self.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height);
        self.view.endEditing(true);
        }
}
