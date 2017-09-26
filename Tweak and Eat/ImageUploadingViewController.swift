//
//  ImgUploadingViewController.swift
//  Tweak and Eat
//
//  Created by admin on 5/7/17.
//  Copyright © 2017 Viswa Gopisetty. All rights reserved.
//

import UIKit

class ImageUploadingViewController: UIViewController {
    
    @IBOutlet var gotIt: UIButton!;
    @IBOutlet var tweakImage: UIImageView!;
    var uploadedImage: UIImage!;
    var mainViewController : WelcomeViewController? = nil;
    
    @IBOutlet var didYouKnowText: UILabel!;
    var parameterDict : [String : String]!;
    var refillComments : String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
    
        self.navigationItem.hidesBackButton = true;
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ImageUploadingViewController.back(sender:)));
        self.navigationItem.leftBarButtonItem = newBackButton;
        tweakImage.image = uploadedImage;
        didYouKnowStaticText();
        self.tabBarController?.tabBar.isHidden = true
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.tweakImage(parameterDict as NSDictionary, userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            MBProgressHUD.hide(for: self.view, animated: true);
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
        })
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true);
    }

    func didYouKnowStaticText(){
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getRequest(TweakAndEatURLConstants.DAILYTIPS, sessionString: userSession, success:
            { (responseDic : AnyObject!) -> (Void) in
                
                if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responseDic as! [String:AnyObject];
                    let reminders : [String:AnyObject]? = response["tweaks"]  as? [String:AnyObject];
                    print(reminders!);
                    self.didYouKnowText.text = reminders?["pkg_evt_message"] as? String;
                }
        }) { (error : NSError!) -> (Void) in
            print("Error in reminders");
        }
    }

    
    @IBAction func gotItAction(_ sender: Any) {
        self.gotIt.isHidden = true;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAKID"), object: nil)
        self.tabBarController?.selectedIndex = 3;
        self.navigationController?.popToRootViewController(animated: true);
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

