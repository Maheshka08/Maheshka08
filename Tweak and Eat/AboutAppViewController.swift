//
//  AboutAppViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    @IBOutlet var communityGuidelinesBtn: UIButton!

    @IBOutlet var privacyPolicyBtn: UIButton!
    @IBOutlet var termsAndPolicyBtn: UIButton!
    
    let termsOfUseURL: String = "http://tweakandeat.com/terms.html"
    let privacyPolicyURL: String = "http://tweakandeat.com/privacy.html"
    let communityGuidelinesURL: String = "http://tweakandeat.com/community-guidelines.html"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.termsAndPolicyBtn.layer.cornerRadius = 10.0
        self.privacyPolicyBtn.layer.cornerRadius = 10.0
        self.communityGuidelinesBtn.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func communityGuidelinesBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showWebView", sender: "communityGuidelines")
    }
    @IBAction func privacyPolicyBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showWebView", sender: "privacyPolicy")
    }
    @IBAction func termsAndPolicyBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showWebView", sender: "termsOfUse")
    }
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderString = sender as! String
        let destinationVC = segue.destination as! WebViewController
        if senderString == "communityGuidelines" {
            destinationVC.navigationTitle = "Community Guidelines"
            destinationVC.urlString = communityGuidelinesURL
            
        } else if senderString == "privacyPolicy" {
            destinationVC.navigationTitle = "Privacy Policy"
            destinationVC.urlString = privacyPolicyURL
            
        } else if senderString == "termsOfUse" {
            destinationVC.navigationTitle = "Terms of Use"
            destinationVC.urlString = termsOfUseURL
            
        }
        
    }
}
