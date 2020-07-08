//
//  PurchasedPackagesViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 5/16/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import Realm
import RealmSwift

class PurchasedPackagesViewController: UIViewController, PurchasePackageButtonCellDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var purchasePackageTableView: UITableView!;
    
    
    @IBOutlet weak var callPopUpView: UIView!
    @IBOutlet weak var callMsgLabel: UILabel!
    
    @objc var packageID = "";
    @objc var myIndex : Int = 0;
    @objc var myIndexPath : IndexPath = [];
    @objc var packageIDArray = NSMutableArray();
    @objc var savedPremiumPackagesArray = NSMutableArray();
    @objc var destination = "918686451872";
    
    let realm :Realm = try! Realm();
    var myWeightInfo : Results<WeightInfo>?;
    @objc var weightHeightConstraint = 0;
    @objc var smallImage : String = "";
   
    override func viewDidLoad() {
        super.viewDidLoad();
      
        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
            self.title = "My Premium Packages";
            
        } else {
            self.title = "Packages";
        }
    Database.database().reference().child("PremiumPackages").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                        if premiumPackages.key == "-KyotHu4rPoL3YOsVxUu" {
                            var packageObj = premiumPackages.value as? [String : AnyObject];
                            packageObj!["snapShot"] = premiumPackages.key as AnyObject;
                            self.savedPremiumPackagesArray.add(packageObj!);
                        }
                }
               
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.purchasePackageTableView.reloadData();
                }
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        self.myWeightInfo = self.realm.objects(WeightInfo.self);
        
        if (self.myWeightInfo?.count)! > 0 {
            self.weightHeightConstraint = 238;
            
        } else {
            self.weightHeightConstraint = 50;
            
        }
        self.purchasePackageTableView.reloadData();
    }
    
    @objc func cellTappedOnQuestions(_ cell: PurchasePackagesTableViewCell) {
        self.myIndex = cell.cellIndexPath;
        self.myIndexPath = cell.myIndexPath;
        
        self.performSegue(withIdentifier: "questionairre", sender: cell);
    }
    
    @objc func cellTappedWeightReadings(_ cell: PurchasePackagesTableViewCell) {
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedPremiumPackagesArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! PurchasePackagesTableViewCell;
        if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
            cell.twetoxIconsView.isHidden = false
            cell.weightTrendsLabel.isHidden = true
            cell.graphButton.isHidden = true
        } else  {
            cell.twetoxIconsView.isHidden = true
            cell.weightTrendsLabel.isHidden = false
            cell.graphButton.isHidden = false
        }
        if cell.packageButtonDelegate == nil {
            cell.packageButtonDelegate = self;
        }
        cell.cellIndexPath = indexPath.row;
        cell.myIndexPath = indexPath;
        let cellDict = self.savedPremiumPackagesArray[indexPath.row] as! [String: AnyObject];
        
        cell.packageImageView.sd_setImage(with: URL(string: self.smallImage));
        if (self.myWeightInfo?.count)! > 0 {
             if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
                cell.weightTrendsLabel.isHidden = true;
             } else {
            cell.graphButton.setImage(UIImage.init(named: "premiumweighttrends.png"), for: .normal);
            cell.weightTrendsLabel.isHidden = false;
            cell.graphButton.setTitle(nil, for: .normal);
            cell.graphHeightConstraint.constant = 238;
            self.weightHeightConstraint = 238;
            }
        } else {
            cell.graphButton.setImage(nil, for: .normal);
            cell.graphButton.setTitleColor(UIColor(red : 89/255, green: 0/255, blue: 120/255, alpha: 1.0), for: .normal);
            cell.graphButton.setTitle(" To start track your weight trend click here>", for: .normal);
            cell.weightTrendsLabel.isHidden = true;
            cell.graphHeightConstraint.constant = 50;
            self.weightHeightConstraint = 50;
        }
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.weightHeightConstraint == 238 {
            return 553;
        } else  if self.weightHeightConstraint == 50 {
            return 370;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.weightHeightConstraint == 238)  {
             if self.packageID == "-TacvBsX4yDrtgbl6YOQ" {
             } else {
            let view = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: 54));
            let titleLbl = UILabel(frame: CGRect(x: 0 , y: 0, width: tableView.frame.size.width, height: 54));
            
            titleLbl.numberOfLines = 0;
            titleLbl.text = "  Please tap on the graph to zoom to view weight trends";
            titleLbl.font = UIFont(name: "Trebuchet MS", size: 14.0);
            titleLbl.textColor = UIColor.darkGray;
            view.backgroundColor = UIColor.white;
            view.addSubview(titleLbl);
            return view;
            }
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.weightHeightConstraint == 238)  {
            return 54
        } else {
            return 0
        }
    }
    
    @objc func buttonClicked() {
        print("Button Clicked")
    }
    
    
    @objc func cellTappedCall(_ cell: PurchasePackagesTableViewCell) {
//        self.myIndex = cell.cellIndexPath
//        self.myIndexPath = cell.myIndexPath
//       
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": "uday"]);
//        }
//        //        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { // change 2 to desired number of seconds
//        self.performSegue(withIdentifier: "mainView", sender: nil);
//        //    }
    }
    
    
    @objc func cellTappedChat(_ cell: PurchasePackagesTableViewCell) {
        self.myIndex = cell.cellIndexPath;
        self.myIndexPath = cell.myIndexPath;
        self.performSegue(withIdentifier: "chat", sender: self);
        
    }
    
    @objc func cellTappedDietPlan(_ cell: PurchasePackagesTableViewCell) {
        self.myIndex = cell.cellIndexPath;
        self.myIndexPath = cell.myIndexPath;
        self.performSegue(withIdentifier: "dietplan", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
            let cellDict = self.savedPremiumPackagesArray[self.myIndexPath.row] as! [String: AnyObject];
            
            let destination = segue.destination as! ChatVC;
            destination.fromPackages = true;
            destination.chatID = self.packageID;
            
        } else if segue.identifier == "dietplan" {
            let cellDict = self.savedPremiumPackagesArray[self.myIndexPath.row] as! [String: AnyObject];
            
            let destination = segue.destination as! DietPlanViewController;
            destination.snapShot = self.packageID
            
        } else if segue.identifier == "mainView" {
            let mainViewController = segue.destination as! MainViewController;
            mainViewController.userID = (Auth.auth().currentUser?.uid)!;
        } else if segue.identifier == "questionairre" {
            let cellDict = self.savedPremiumPackagesArray[self.myIndexPath.row] as! [String: AnyObject];
            print(cellDict)
            let destination = segue.destination as! QuestionsViewController;
            
            destination.packageID = self.packageID
        } else if segue.identifier == "weightTrends" {
            let destination = segue.destination as! ProfileViewController;
            destination.performSegue = "PurchasedPackages";
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
