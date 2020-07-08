//
//  PackagesInfoPopUpViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 6/21/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase

class PackagesInfoPopUpViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var packageInfoView: UIView!;
    @IBOutlet weak var doneButton: UIButton!;
    @IBOutlet weak var packageInfoTextView: UITextView!;
    
    @objc var premiumPackagesRef : DatabaseReference!;
    @objc var packageId : String = "";
  
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true);

        self.packageInfoTextView.delegate = self;
        self.packageInfoView.layer.cornerRadius = 6;
        self.packageInfoView.layer.shadowColor = UIColor.black.cgColor;
        self.packageInfoView.layer.shadowOpacity = 1;
        self.packageInfoView.layer.shadowOffset = CGSize.zero;
        self.packageInfoView.layer.shadowRadius = 10;
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.1);
     
        premiumPackagesRef = Database.database().reference().child("PremiumPackageDetailsiOS").child(self.packageId).child("packageFullDesc");

         self.showAnimate();
        premiumPackagesRef.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            let dispatch_group = DispatchGroup()
            dispatch_group.enter()
            let htmlStr = snapshot.value as AnyObject  as! String

            dispatch_group.leave()
            dispatch_group.notify(queue: DispatchQueue.main) {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.packageInfoTextView.text = htmlStr.html2String
            }
            
         })
    }
    
    @IBAction func doneAction(_ sender: Any) {
        removeAnimate()
    }

    @objc func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @objc func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview();
                
            }
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
