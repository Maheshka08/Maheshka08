//
//  AvailablepremiumPackageObjViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 4/5/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase

class AvailablePremiumPackagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableViewDelegate {
    
    func cellTappedOnExpandableView(_ cell: AvailablePremiumPackagesTableViewCell, sender: UITapGestureRecognizer) {
        
    }
    
    var premiumPackagesRef : DatabaseReference!
    var premiumPackageResults : Results<PremiumPackageDetails>?
    let realm :Realm = try! Realm()
    var expandedRows = Set<Int>()

    var selectedRowIndex = -1
    @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var cartView: UIView!
    
    
    @IBOutlet weak var paymentOverlayView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // self.tableView.rowHeight = UITableViewAutomaticDimension
        
        premiumPackagesRef = Database.database().reference().child("PremiumPackages")


      self.title = "Available Packages"
        self.paymentOverlayView.isHidden = true
        self.cartView.isHidden = false
        
    self.premiumPackageResults = self.realm.objects(PremiumPackageDetails.self);
     self.getFirebaseData()
            // Do any additional setup after loading the view.
    }
    
    
    
    func getFirebaseData() {
        
            
            premiumPackagesRef.observe(DataEventType.value, with: { (snapshot) in
                // this runs on the background queue
                // here the query starts to add new 10 rows of data to arrays
                if snapshot.childrenCount > 0 {
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    
                    for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let packageObj = premiumPackages.value as? [String : AnyObject];
                        
                        let premiumPackageObj = PremiumPackageDetails()
                        premiumPackageObj.packageName = (packageObj?["packageTitle"] as AnyObject) as! String;
                        
                        premiumPackageObj.packageImage = (packageObj?["packageImage"] as AnyObject) as! String;
                        
                        premiumPackageObj.packageDescription = (packageObj?["packageDesc"] as AnyObject) as! String;
                        
                        premiumPackageObj.packageRating = (packageObj?["packageAvgRating"] as AnyObject) as! Double;
                        
                        let milisecond = packageObj?["createdOn"] as AnyObject as! NSNumber;
                        let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 );
                        let dateFormatter = DateFormatter();
                        dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                        let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject;
                        
                        premiumPackageObj.createdOn = dateArrayElement as! String;
                        
                        premiumPackageObj.packageId = (packageObj?["packageId"] as AnyObject) as! String;
                        
                         let packagePrices = packageObj?["packagePrice"]  as! NSMutableArray
                        
                        
                        if packagePrices.count > 0 {

                        for prcValue in packagePrices {
                            var priceValue = [String: AnyObject]()
                            priceValue = prcValue as! [String : AnyObject]
                            let packageCost = PackagePrice()
                            packageCost.price = priceValue["price"]! as AnyObject as! Double
                            packageCost.countryCode = priceValue["countryCode"]! as AnyObject as! String
                            packageCost.currency = priceValue["currency"]! as AnyObject as! String
                            premiumPackageObj.packageDefaultCost.append(packageCost)

                            }
                        }
                       
                        premiumPackageObj.snapShot = premiumPackages.key
                        saveToRealmOverwrite(objType: PremiumPackageDetails.self, objValues: premiumPackageObj)
                        
                    }
                    dispatch_group.leave()
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        let sortProperties = [SortDescriptor(keyPath: "createdOn", ascending: false)]
                        
                        self.premiumPackageResults = self.premiumPackageResults!.sorted(by: sortProperties)
                        self.tableView.reloadData()
                        
                    }
                }
            })
        }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.premiumPackageResults?.count)!
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AvailablePremiumPackagesTableViewCell;
        cell.expandableViewDelegate = self
        //cell.isExpanded = self.expandedRows.contains(indexPath.row)
//        if indexPath.row == 0 {
//            cell.packageImageView.image = UIImage.init(named: "packageImage")
//            cell.packageName.text = "Tweak and Eat Weight loss"
//        } else {
//            cell.packageImageView.image = UIImage.init(named: "bridalImage")
//            cell.packageName.text = "Bridal Package"
//        }
        let cellDictionary = self.premiumPackageResults?[indexPath.row]
        
         cell.packageName.text = cellDictionary?["packageName"] as AnyObject as? String
        let imageUrl = cellDictionary?["packageImage"] as AnyObject as? String
        cell.packageImageView.sd_setImage(with: URL(string: imageUrl!));
        
         cell.packageDescription.text = cellDictionary?["packageDescription"] as AnyObject as? String
        
         cell.packageRatingLabel.text = "\(cellDictionary?["packageRating"] as AnyObject as! Double)";
        
            //cellDictionary?["packageRating"] as AnyObject as? String
        
        let packagePrice = cellDictionary?["packageDefaultCost"] as! List<PackagePrice>;
        for pkgPrice in packagePrice {
            if pkgPrice.countryCode == "91" {
                cell.packageDefaultCost.text =
                    //cost.price
                "₹ " + "\(pkgPrice.price as AnyObject as! Double)";

            }
        }
       
          return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 133.0
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            return 284
        }
        
        return 128
    }
    
    
    @IBAction func paymentBtnTapped(_ sender: Any) {
        self.paymentOverlayView.isHidden = false

    }
    
    
    @IBAction func paymentCancelTapped(_ sender: Any) {
        self.paymentOverlayView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) as? AvailablePremiumPackagesTableViewCell
            else { return }
    
//
//        switch cell.isExpanded
//        {
//        case true:
//            self.expandedRows.remove(indexPath.row)
//        case false:
//            self.expandedRows.insert(indexPath.row)
//        }
//
//
//        cell.isExpanded = !cell.isExpanded
//
//        self.tableView.beginUpdates()
//        self.tableView.endUpdates()
        
        if selectedRowIndex == indexPath.row {
            selectedRowIndex = -1
            cell.expandableView.isUserInteractionEnabled = true
        } else {
            selectedRowIndex = indexPath.row
            cell.expandableView.isUserInteractionEnabled = false
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
      func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
        
    
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? AvailablePremiumPackagesTableViewCell
//            else { return }
//
//        self.expandedRows.remove(indexPath.row)
//
//        cell.isExpanded = false
//
//        self.tableView.beginUpdates()
//        self.tableView.endUpdates()
//
//    }
//
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
