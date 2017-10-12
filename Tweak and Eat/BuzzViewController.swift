//
//  BuzzViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 05/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.

import AudioToolbox
import GoogleMobileAds
import UIKit
import CoreData


class BuzzViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  GADBannerViewDelegate, GADInterstitialDelegate {
    
    @IBOutlet var admobView: UIView!;
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait);
        adBannerView.adUnitID = "ca-app-pub-6742453784279360/1026109358";
        adBannerView.delegate = self;
        adBannerView.rootViewController = self;
        
        return adBannerView;
    }()
    
    var interstitial: GADInterstitial?;
    @IBOutlet weak var displayableContacts: UITableView!;
  
    var buzzBirdieImageView : UIImageView?;
    var buzzImageView : UIImageView?;
    var buzzButton : UIButton?;
    var dbArray : [TBL_Contacts]?;
    
    @IBOutlet weak var onClickSeg: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad();
        if UIScreen.main.bounds.size.height == 480 {
            self.admobView.isHidden = true
        }
         onClickSeg.tintColor = UIColor.white
        // Request a Google Ad
       // adBannerView = GADBannerView(adSize: kGADAdSizeBanner);
        adBannerView.adUnitID = "ca-app-pub-6742453784279360/1026109358";
        adBannerView.rootViewController = self;
        adBannerView.load(GADRequest());

        selectedBuzzMembers();
        self.view.backgroundColor = UIColor.white;
        displayableContacts.register(ContactTableViewCell.nib(), forCellReuseIdentifier: "Cell");
        self.onClickSeg.layer.cornerRadius = 5;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        admobView.addSubview(adBannerView);
        buzzBirdieImageView?.image = UIImage(named:"birdie_before_buzz");
        self.buzzButton?.setTitle("BUZZ", for: UIControlState.normal);

        if onClickSeg.selectedSegmentIndex == 0
        {
            
            displayableContacts.isHidden = true;
            
        }
        else if (onClickSeg.selectedSegmentIndex == 1) {
            
            displayableContacts.isHidden = false;
            buzzButton?.removeFromSuperview();
            buzzImageView?.removeFromSuperview();
            buzzBirdieImageView?.removeFromSuperview();
        
        }
        
        dbArray = Contacts.getDataBase();
        displayableContacts.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dbArray?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContactTableViewCell;
        let contact = dbArray?[indexPath.row];
        cell.fullNameContact.text = contact?.contact_name;
        cell.phoneNumberContact.text = contact?.contact_number;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let contact = dbArray?[indexPath.row];
            var tempDict = [String :AnyObject]();
            let name = contact?.contact_name as AnyObject;
            let number = contact?.contact_number as AnyObject;
            tempDict = ["name" : name,"msisdn" : number];
            
            MBProgressHUD.showAdded(to: self.view, animated: true);
            APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.REMOVE_EXISTING_FRIEND, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: tempDict, success: { response in
                
                self.deleteManagedObjectFromDB(favorite: self.dbArray?[indexPath.row], index: indexPath);
                self.displayableContacts.reloadData();
                MBProgressHUD.hide(for: self.view, animated: true);
                
            }, failure : { error in

                let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)

            })
        } else {
            
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Select Contact")
        }
    }
    
    
    @IBAction func addContactsAct(_ sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let inviteView : InviteViewController = storyBoard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController;
        self.navigationController?.pushViewController(inviteView, animated: true);
    }

    
    @IBAction func onClickOfSegmentBar(_ sender: UISegmentedControl) {
        buzzBirdieImageView?.image = UIImage(named:"birdie_before_buzz");
        self.buzzButton?.setTitle("BUZZ", for: UIControlState.normal);
        if (sender.selectedSegmentIndex == 0) {
            displayableContacts.isHidden = true;
            if UIScreen.main.bounds.size.height == 480 {
                self.admobView.isHidden = true
            }
            
            selectedBuzzMembers();
        } else if (sender.selectedSegmentIndex == 1) {
            displayableContacts.isHidden = false;
            if UIScreen.main.bounds.size.height == 480 {
                self.admobView.isHidden = false
            }
            buzzButton?.removeFromSuperview();
            buzzImageView?.removeFromSuperview();
            buzzBirdieImageView?.removeFromSuperview();
            
        }

    }
    
    func selectedBuzzMembers () {
        
        buzzBirdieImageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 250, height: 300));
        buzzBirdieImageView?.center = CGPoint(x:self.view.bounds.width/2, y:180)
        buzzBirdieImageView?.image = UIImage(named:"birdie_before_buzz");
        buzzBirdieImageView?.contentMode = .scaleAspectFit
        self.view.addSubview(buzzBirdieImageView!);
        buzzButton = UIButton(type: .system);
        buzzButton?.frame = CGRect(x: 40, y: (buzzBirdieImageView?.frame)!.maxY, width: self.view.bounds.width - 80, height: 40);
        buzzButton?.backgroundColor = TweakAndEatColorConstants.AppDefaultColor;
        buzzButton?.setTitle("BUZZ", for: UIControlState.normal);
        buzzButton?.tintColor = UIColor.white;
        buzzButton?.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 27);
        buzzButton?.addTarget(self, action: #selector(BuzzViewController.onClickOfBuzzButton), for: UIControlEvents.touchUpInside);
        self.view.addSubview(buzzButton!);
    }
    
    func onClickOfBuzzButton () {
        if dbArray?.count == 0 {
            showAlerController(message: "There are no invitees in your list !!");
            return;
        }
        var friends = [[String : AnyObject]]();
        for contact in dbArray! {
        
            var dictionary = [String : Any]();
            dictionary["name"] = contact.contact_name as AnyObject;
            dictionary["msisdn"] = contact.contact_number as AnyObject;
            friends.append(dictionary as [String : AnyObject]);
        }
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.buzzFriends(userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Success");
            self.buzzBirdieImageView?.image = UIImage(named:"birdie_buzz_large");
            self.buzzButton?.setTitle("BUZZED", for: UIControlState.normal);
            self.displayableContacts.reloadData();
            MBProgressHUD.hide(for: self.view, animated: true);
            
        }, failureBlock: { error in
            print("Failure");
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func showAlerController(message : String) {
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil));
        self.present(alertController, animated: true, completion: nil);
    }
    
    func deleteManagedObjectFromDB(favorite : TBL_Contacts?, index : IndexPath){
        let fetchRequest = NSFetchRequest<TBL_Contacts>(entityName: "TBL_Contacts");
        let resultPredicate2 = NSPredicate(format: "contact_number ENDSWITH %@ || contact_number BEGINSWITH %@", (favorite?.contact_number)!, (favorite?.contact_number)!);
        fetchRequest.predicate = resultPredicate2;
        let results = try! context.fetch(fetchRequest);
        for deleteObj in results as [TBL_Contacts] {
            context.delete(deleteObj);
            DatabaseController.saveContext();
        }
        dbArray?.remove(at: index.row);
        DispatchQueue.global(qos: .background).async {
            Contacts.sharedContacts().getContactsAuthenticationForAddressBook();
        }
        displayableContacts.reloadData();
    }
    // MARK: - GADBannerViewDelegate methods
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully");
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height);
        bannerView.transform = translateTransform;
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity;
        }
        func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
            print("Fail to receive ads");
            print(error);
            
        }
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully");
        ad.present(fromRootViewController: self);
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial");
    }
    
}
