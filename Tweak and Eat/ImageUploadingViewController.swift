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
            let alertController = UIAlertController(title: "No Internet Connection", message: "Your internet connection appears to be offline !!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "timelinesViewController") as! TimelinesViewController;
        self.navigationController?.pushViewController(clickViewController, animated: true);
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

