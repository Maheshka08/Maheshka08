//
//  TimelinesDetailsViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 03/10/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import Firebase
import FirebaseDatabase

class TimelinesDetailsViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait);
        adBannerView.adUnitID = "ca-app-pub-6742453784279360/1026109358";
        adBannerView.delegate = self;
        adBannerView.rootViewController = self;
        
        return adBannerView;
    }()

    let screenHeight: CGFloat = UIScreen.main.bounds.height;
    
    @IBOutlet var shareBtn: UIButton!
    @IBOutlet var admobView: UIView!;
    @IBOutlet var timelineImageView: UIImageView!;
    @IBOutlet var okForRating: UIButton!;
    @IBOutlet var gotItButton: UIButton!;
    @IBOutlet var ratingView: HCSStarRatingView!;
    @IBOutlet var ratingNumberLabel: UILabel!;
    var modifiedImgUrl : String!;
    var timelineViewCell : TimelineTableViewCell! = nil;
    
    var player = AVPlayer();
    
    public var timelineDetails : TBL_Tweaks! = nil;
    
    var ratingChanged : Bool!;
    var ratings : CGFloat!;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner);
        adBannerView.adUnitID = "ca-app-pub-6742453784279360/1026109358";
        adBannerView.rootViewController = self;
        adBannerView.load(GADRequest());
        ratingChanged = false;
        
        if timelineDetails.tweakModifiedImageURL == ""{
            timelineImageView.sd_setImage(with: URL(string: timelineDetails.tweakOriginalImageURL ?? ""));
        }
        else{
            timelineImageView.sd_setImage(with: URL(string: timelineDetails.tweakModifiedImageURL ?? ""));
        }
        ratingNumberLabel.text = "\(timelineDetails.tweakRating)";
        ratingView.value = CGFloat(timelineDetails.tweakRating);
        okForRating.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0);
        if timelineDetails.tweakModifiedImageURL == ""{
            
            let ref = Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "imageUrl").queryEqual(toValue : timelineDetails.tweakOriginalImageURL)
            
            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key)

                    self.shareBtn?.setImage(UIImage(named: "SharedBtn.png"), for: .normal)
                    
                }
            })

        }
        else{
            timelineImageView.sd_setImage(with: URL(string: timelineDetails.tweakModifiedImageURL ?? ""));
            
            let ref = Database.database().reference().child("TweakFeeds").queryOrdered(byChild: "imageUrl").queryEqual(toValue : timelineDetails.tweakModifiedImageURL)
            
            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key)
                   // TweakAndEatUtils.AlertView.showAlert(view: self, message: "This image has been already shared to tweak wall!")
                    self.shareBtn?.setImage(UIImage(named: "SharedBtn.png"), for: .normal)
                    
                }
            })

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cornerRadius = (screenHeight * 0.105) / 2;
        shareBtn.layer.cornerRadius = 20;
        okForRating.layer.cornerRadius = 20;
        admobView.addSubview(adBannerView);
        if timelineDetails.tweakStatus == 4{
            self.shareBtn.isHidden = false
        }else{
            self.shareBtn.isHidden = true
        }
    }
    
    @IBAction func fullSizeImage(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let fullImageView : FullImageViewController = storyBoard.instantiateViewController(withIdentifier: "fullImageView") as! FullImageViewController;
        fullImageView.shareAction = true
        if timelineDetails.tweakModifiedImageURL == "" {
            fullImageView.imageUrl =  timelineDetails.tweakOriginalImageURL! as String;
        }
        else{
            fullImageView.imageUrl =  timelineDetails.tweakModifiedImageURL! as String;
        }
       
        self.navigationController?.present(fullImageView, animated: true, completion: nil);
    }
    
    
    
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        
        if (self.shareBtn.currentImage?.isEqual(UIImage(named: "SharedBtn.png")))!{
            //do something here
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "This tweak has already been shared to tweak wall!")
        }else{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let fullImageView : FullImageViewController = storyBoard.instantiateViewController(withIdentifier: "fullImageView") as! FullImageViewController;
        fullImageView.shareAction = false
        
        
        if timelineDetails.tweakModifiedImageURL == "" {
            fullImageView.imageUrl =  timelineDetails.tweakOriginalImageURL! as String;
        }
        else{
            fullImageView.imageUrl =  timelineDetails.tweakModifiedImageURL! as String;
        }
        
        self.navigationController?.present(fullImageView, animated: true, completion: nil);
        
       }
    }
    
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOfChatMessage(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message: "Chatting with  Nutritionist is coming soon", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
        
    }
    
    @IBAction func onClickOfDone(_ sender: AnyObject) {
      
        if("\(timelineDetails.tweakRating)" != "\(ratingView.value)") {
            let ratingParams : [String : String] = ["tid" : "\(timelineDetails.tweakId)", "rate" : "\(ratingView.value)"];
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            
            APIWrapper.sharedInstance.updateRatingForTweak(ratingParams as NSDictionary,userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEWREMINDER"), object: nil)
                self.ratingNumberLabel!.updateConstraints();
                
                //Update the floating value to Label
                self.ratingNumberLabel.text = "\(self.ratingView.value)";
                
                let alert = UIAlertController(title: "", message: "Your rating for the tweak has been submitted", preferredStyle: UIAlertControllerStyle.alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
                self.present(alert, animated: true, completion: nil);
                self.timelineDetails.tweakRating = Float(self.ratingView.value);
                self.okForRating.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1.0);
                self.ratingChanged = false;
                
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
            })

        }
        
    }

    
    @IBAction func onChangeOfRatingViewValue(_ sender: AnyObject) {
        if(ratingChanged == false) {
            ratingChanged = true;
            okForRating.backgroundColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
            
        }
        let ratingNumber = sender as! HCSStarRatingView;
        ratingNumberLabel.text = "\(ratingNumber.value)";
    }
    
}
