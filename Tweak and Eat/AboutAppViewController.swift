//
//  AboutAppViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    
    @IBOutlet var communityGuidelinesBtn: UIButton!

    @IBOutlet var buildNumberLabel: UILabel!
    @IBOutlet var versionNumberLabel: UILabel!
    @IBOutlet var privacyPolicyBtn: UIButton!
    @IBOutlet var termsAndPolicyBtn: UIButton!
     @objc var countryCode = ""
    
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var purpletealLbl: UILabel!
    
    @objc let termsOfUseURL: String = "http://tweakandeat.com/terms.html"
    @objc let privacyPolicyURL: String = "http://tweakandeat.com/privacy.html"
    @objc let communityGuidelinesURL: String = "http://tweakandeat.com/community-guidelines.html"
    @objc let versionLbl: String = "VERSION: "
    @objc let buildLbl: String = "BUILD: "
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

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
         self.byLabel.text  = bundle.localizedString(forKey: "by", value: nil, table: nil)
         self.purpletealLbl.text  = bundle.localizedString(forKey: "purpleteal_inc", value: nil, table: nil)
        
        self.termsAndPolicyBtn.setTitle(bundle.localizedString(forKey: "terms_of_use", value: nil, table: nil), for: .normal)
         self.privacyPolicyBtn.setTitle(bundle.localizedString(forKey: "privacy_policy", value: nil, table: nil), for: .normal)
         self.communityGuidelinesBtn.setTitle(bundle.localizedString(forKey: "community_guidelines", value: nil, table: nil), for: .normal)
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0)]);

        // Do any additional setup after loading the view.
        self.termsAndPolicyBtn.layer.cornerRadius = 10.0
        self.privacyPolicyBtn.layer.cornerRadius = 10.0
        self.communityGuidelinesBtn.layer.cornerRadius = 10.0
        self.versionAndBuildNumbers()
        //self.title = "About App"
    }
    
    @objc func versionAndBuildNumbers() {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        self.versionNumberLabel.text = bundle.localizedString(forKey: "version", value: nil, table: nil) + version
        self.buildNumberLabel.text =  bundle.localizedString(forKey: "build", value: nil, table: nil) + build
    }

    @IBAction func communityGuidelinesBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "privacy", sender: "communityGuidelines")
    }
    @IBAction func privacyPolicyBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "privacy", sender: "privacyPolicy")
    }
    @IBAction func termsAndPolicyBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "privacy", sender: "termsOfUse")
    }
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderString = sender as! String
        let destinationVC = segue.destination as! PrivacyPoliciesViewController
        if senderString == "communityGuidelines" {
            destinationVC.title = bundle.localizedString(forKey: "community_guidelines", value: nil, table: nil)
            destinationVC.staticName = TweakAndEatConstants.GUIDE_LINES
            
        } else if senderString == "privacyPolicy" {
            destinationVC.title = bundle.localizedString(forKey: "privacy_policy", value: nil, table: nil)
            destinationVC.staticName = TweakAndEatConstants.PRIVACY
            
        } else if senderString == "termsOfUse" {
             destinationVC.title = bundle.localizedString(forKey: "terms_of_use", value: nil, table: nil)
            destinationVC.staticName = TweakAndEatConstants.TERMS_OF_USE
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
