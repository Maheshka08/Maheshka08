//
//  NutritionLabelsPaymentHistoryViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 11/29/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit

class NutritionLabelsPaymentHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!;
    @objc var nutritionLabelPaymentHistoryArray = NSMutableArray();
    @objc var dateFormatter = DateFormatter();
    
    @IBOutlet weak var purchasedOnLbl: UILabel!;
    @IBOutlet weak var amountLbl: UILabel!;
    @IBOutlet weak var labels: UILabel!;
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    @objc var countryCode = "";

    override func viewDidLoad() {
        super.viewDidLoad();
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)";
        }
        bundle = Bundle.init(path: path!)! as Bundle;
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
        
        self.purchasedOnLbl.text = self.bundle.localizedString(forKey: "purchased_on", value: nil, table: nil);
        self.labels.text = self.bundle.localizedString(forKey: "Lables", value: nil, table: nil);
        self.amountLbl.text = self.bundle.localizedString(forKey: "amount", value: nil, table: nil);
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX");
        MBProgressHUD.showAdded(to: self.view, animated: true);
        self.getLabelTransactionDetails();
        self.title = self.bundle.localizedString(forKey: "Lables_purchased", value: nil, table: nil);
    }
    
    @objc func getLabelTransactionDetails() {
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.labelTransactions(sessionString: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            print(responseDic);
            if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.nutritionLabelPaymentHistoryArray =  NSMutableArray(array : (responseDic["transactions"] as AnyObject) as! NSArray);
                print(self.nutritionLabelPaymentHistoryArray);
                self.tableView.reloadData();
            }
            
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
            MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutritionLabelPaymentHistoryArray.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! NutritionLabelsPaymentHistoryTableViewCell;

        let cellDict = self.nutritionLabelPaymentHistoryArray[indexPath.row] as! [String : AnyObject];
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        let date = dateFormatter.date(from: (cellDict["ul_crt_dttm"] as? String)!);
        dateFormatter.dateFormat = "d MMM, EEE, yyyy hh:mm a";
        let dateString = dateFormatter.string(from: date!);
        cell.dateLabel.text = dateString;
        cell.labelsCount.text = "\(cellDict["ul_labels_count"] as! Int)";
        let currency =  cellDict["ul_amt_currency"] as! String;
        cell.amountLabel.text =  "\(cellDict["ul_amt"] as! Int)" + " " + currency;
      
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
