//
//  AiDPViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 10/16/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AiDPViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    @IBOutlet weak var dietPopupView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!;
    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var collectionView: UICollectionView!;
    @IBOutlet weak var questionIconButton: UIButton!;
    @IBOutlet weak var chatIconButton: UIButton!;
    @IBOutlet weak var smallImageView: UIImageView!;
    @IBOutlet weak var optionsLabel: UILabel!;
    
    @objc var aidpContent = ""
    @objc var countryCode = ""
    @objc var ptpPackage = ""

    var isPublished = false
    @IBOutlet weak var okBtn: UIButton!
    
    @objc var AiDPPackagesRef : DatabaseReference!;
    var status = 100
    @IBOutlet weak var dietPlanCaseLbl: UILabel!
    @objc var dietPlanArray = NSMutableArray();
    @objc var itemsArray = NSMutableArray();
    @objc var smallImage : String = "";
    @objc var showColorForItem = 0;
    @objc var disableChat = false;
    var packageId = "-SquhLfL5nAsrhdq7GCY"
    var statusMessage = ""

    @IBAction func chatIconButtonTapped(_ sender: Any) {
        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                for dietPlan in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let dietPlanObj = dietPlan.value;
                    print(dietPlanObj!);
                    if dietPlanObj is Bool {
                        if dietPlan.key == "isChatOpen" {
                            if dietPlanObj as! Bool == true {
                                self.disableChat = false;
                                self.performSegue(withIdentifier: "chat", sender: self);
                            } else {
                                self.disableChat = true;
                                self.performSegue(withIdentifier: "chat", sender: self);
                            }
                        }
                    }
                }
            }
        })
    }
    
    func getAiDPContentforUSA(status: Int, message: String, stayHere: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIWrapper.sharedInstance.postRequestWithHeadersForUSAAiDPContent(self.aidpContent,status: "\(status)", userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["CallStatus"] as! String
            if  responseResult == "GOOD" {
                print("Sucess")
                self.sendNotifyToNutritionist(message: message, status: status, stayHere: stayHere)
                
            } else{
                
            }
        }, failure : { error in
            print(error?.description)
//            self.getQuestionsFromFB()
                        MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !! Please answer the questions again !!")
            
        })
    }
    
    func sendNotifyToNutritionist(message: String, status: Int, stayHere: Bool) {
       // MBProgressHUD.showAdded(to: self.view, animated: true)
        if UserDefaults.standard.value(forKey: "NutritionistFirebaseId") == nil {
            return
        }
        let paramsDictionary = ["fbid": UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String,
                                "msgType": message
        ]
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.SEND_NOTIFY_TO_NUTRITIONIST, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response!)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
                MBProgressHUD.hide(for: self.view, animated: true)
               // self.updateStatus(status: status,stayHere: stayHere)
            }
        }, failure : { error in
            MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
        })
        
    }
    
    func goToMyTweakAndEatScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let myTweakandEatViewController : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        self.navigationController?.pushViewController(myTweakandEatViewController, animated: true);

    }
    
    func updateStatus(status: Int, stayHere: Bool) {
        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).child("dietPlan").updateChildValues(["status": status], withCompletionBlock: { (error, _) in
            if error == nil {
                if stayHere == false {
                    self.goToMyTweakAndEatScreen()

                }
            } else {
                
            }
        })

    }
    @IBAction func okAction(_ sender: Any) {
        
        if self.status == 0 {
           // self.updateStatus(status: 1, stayHere: true )
            self.getAiDPContentforUSA(status: 1, message: "USR_NUTRI_AIDP_REQUEST", stayHere: true)
            

        } else if self.status == 1 {
            self.goToMyTweakAndEatScreen()

           // self.sendNotifyToNutritionist(message: "USR_NUTRI_AIDP_REQUEST", status: 2, stayHere: false)
            
        } else if self.status == 2 {
            self.getAiDPContentforUSA(status: 3, message: "USR_NUTRI_AIDP_ACCEPT", stayHere: true)

            
        } else if self.status == 3 {
            self.goToMyTweakAndEatScreen()
            
        } else {
            self.goToMyTweakAndEatScreen()
        }


        
    }
    @IBAction func questionIconButtonTapped(_ sender: Any) {
        Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).child("dietPlan").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            
            if snapshot.childrenCount > 0 {
               
                for dietPlan in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let dietPlanObj = dietPlan.value;
                    print(dietPlanObj!);
                    if dietPlanObj is Bool {
                        if dietPlan.key == "isPublished" {
                            if dietPlanObj as! Bool == true {
                                self.performSegue(withIdentifier: "profileView", sender: self);
                            
                            } else {
                                self.performSegue(withIdentifier: "questionairre", sender: self);
                
                            }
                        } 
                    }
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.addTopBorder(UIColor.black, height: 1.0);
        self.collectionView.addTopBorder(UIColor.black, height: 1.0);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        if countryCode == "1" {
            self.aidpContent = TweakAndEatURLConstants.USA_AiDP_CONTENT
        } else if countryCode == "60" {
            self.aidpContent = TweakAndEatURLConstants.MYS_AiDP_CONTENT
        }  else if countryCode == "65" {
            self.aidpContent = TweakAndEatURLConstants.SGN_AiDP_CONTENT
        }
        else if countryCode == "62" {
            self.aidpContent = TweakAndEatURLConstants.IDN_AiDP_CONTENT
        } else if countryCode == "91" {
            self.aidpContent = TweakAndEatURLConstants.IND_AiDP_CONTENT
        }
        if self.countryCode == "91" {
            self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
        } else if self.countryCode == "1" {
            self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
        } else if self.countryCode == "65" {
            self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
        } else if self.countryCode == "62" {
            self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
        } else if self.countryCode == "60" {
            self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
        } else if self.countryCode == "63" {
            self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
        }

        self.tableView.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0);
        AiDPPackagesRef = Database.database().reference().child("UserPremiumPackages").child((Auth.auth().currentUser?.uid)!).child(self.packageId).child("dietPlan");
        self.optionsLabel.isHidden = false;
        self.questionIconButton.isHidden = false;
        self.chatIconButton.isHidden = false;
       
        if packageId == "-SquhLfL5nAsrhdq7GCY" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == self.ptpPackage {
            self.statusView.isHidden = true
        } else {
            self.chatIconButton.isHidden = true
            self.questionIconButton.isHidden = true
        }

        self.optionsLabel.text = "On WakeUp Options";
        self.title = "AiDP";
        self.getFirebaseData();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AiDPTableViewCell
        let cellDict = self.itemsArray[indexPath.row] as AnyObject as! NSDictionary;
        cell.lbl.text =  "\n" + (cellDict["name"] as? String)! + "\n" + (cellDict["qty"] as? String)! + "\n" + "\n" + "--------------------OR--------------------";
        if indexPath.row == self.itemsArray.count - 1 {
            cell.lbl.text =  "\n" + (cellDict["name"] as? String)! + "\n" + (cellDict["qty"] as? String)! + "\n";
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showColorForItem = indexPath.item;
        self.itemsArray = NSMutableArray();
        let items = self.dietPlanArray[indexPath.item];
        let dict = items as! Dictionary<String, AnyObject>;
        for (key, val) in dict  {
            if key == "items" {
                let itemDict = val as! NSMutableArray;
                self.itemsArray = itemDict;
            }
        }
        let selectedLabels = self.dietPlanArray[indexPath.row] as AnyObject;
        self.optionsLabel.text = (selectedLabels["name"] as? String)! + " " + "Options";
        self.collectionView.reloadData();
        self.tableView.reloadData();
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dietPlanArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRow", for: indexPath) as! AiDPCollectionViewCell;
        let cellDict = self.dietPlanArray[indexPath.item] as AnyObject as! NSDictionary;
        cell.lbl.text = cellDict["name"] as? String;
        
            if indexPath.item == self.showColorForItem {
                cell.greenLbl.isHidden = true;
                cell.redLbl.isHidden = false;
                cell.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0);
            }
         else {
                cell.redLbl.isHidden = true;
                cell.greenLbl.isHidden = false;
                cell.backgroundColor = UIColor.white;
        }
        return cell
    }
    
//    func showNoDietPlanView() {
//        let noDietPlanView = UIView(frame: CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
//    }
    
    @objc func getFirebaseData() {
        MBProgressHUD.showAdded(to: self.view, animated: true);

        AiDPPackagesRef.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                self.optionsLabel.isHidden = false;
                if (snapshot.key == self.packageId) {
                    self.chatIconButton.isHidden = true
                    self.questionIconButton.isHidden = true
                } else {
                self.questionIconButton.isHidden = false;
                self.chatIconButton.isHidden = false;
                }
                self.optionsLabel.text = "On WakeUp Options";
                for dietPlan in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let dietPlanObj = dietPlan.value;
                    print(dietPlanObj!);
                    print(String(describing: type(of: dietPlanObj!)));
                    if dietPlanObj is NSMutableArray {
                
                        self.dietPlanArray = dietPlanObj as! NSMutableArray;

                        let items = self.dietPlanArray[0];
                        print(String(describing: type(of: items)));

                        let dict = items as! Dictionary<String, AnyObject>;
                        
                        for (key, val) in dict  {
                            print(val)
                            if key == "items" {
                                let itemDict = val as! NSMutableArray;
                                self.itemsArray = itemDict;
            
                            }
                        }
                    } else if dietPlanObj is Bool {
                        if dietPlan.key == "isPublished" {
                            
                            if dietPlanObj as! Bool == true {
                                if (self.packageId == "-MzqlVh6nXsZ2TCdAbOp" || self.packageId == "-MalAXk7gLyR3BNMusfi"  || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == self.ptpPackage || self.packageId == "-SgnMyAiDPuD8WVCipga"  || self.packageId == "-IdnMyAiDPoP9DFGkbas") {
                                 self.isPublished = true
                                }
                            } else {
                                self.itemsArray = NSMutableArray();
                                self.dietPlanArray = NSMutableArray();
                                if self.packageId == "-SquhLfL5nAsrhdq7GCY" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == self.ptpPackage {
                                    self.dietPopupView.isHidden = false
//                                    let refreshAlert = UIAlertController(title: "", message: "Your diet plan is getting ready... Please visit later..." , preferredStyle: UIAlertController.Style.alert);
//
//                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                                        print("Handle Ok logic here");
//                                        self.navigationController?.popViewController(animated: true);
//                                    }))
//                                    self.present(refreshAlert, animated: true, completion: nil);
                                } else {
                                    self.isPublished = false
                                }
                                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
                                if (self.packageId == "-MzqlVh6nXsZ2TCdAbOp" || self.packageId == "-MalAXk7gLyR3BNMusfi"  || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == self.ptpPackage || self.packageId == "-SgnMyAiDPuD8WVCipga"  || self.packageId == "-IdnMyAiDPoP9DFGkbas") {
                                    self.chatIconButton.isHidden = true
                                    self.questionIconButton.isHidden = true
                                } else {
                                self.questionIconButton.isHidden = true;
                                self.chatIconButton.isHidden = true;
                                self.optionsLabel.isHidden = true;
                                }
                            }
                        } else if dietPlan.key == "isAccepted"{
                            if dietPlanObj as! Bool == true {
                               
                            } else {
                            }
                        } else if dietPlan.key == "status" {
                            if dietPlanObj as! Int == 0 {
                                self.status = 0
                            } else if dietPlanObj as! Int == 1 {
                                self.status = 1
                            } else if dietPlanObj as! Int == 2 {
                                self.status = 2
                            } else if dietPlanObj as! Int == 3 {
                                self.status = 3
                            } else {
                                                        //self.statusView.isHidden = true
                            }
                        }

                    } else if dietPlanObj is NSNumber {
                         if dietPlan.key == "status" {
                            if dietPlanObj as! Int == 0 {
                                self.status = 0
                            } else if dietPlanObj as! Int == 1 {
                                self.status = 1
                            } else if dietPlanObj as! Int == 2 {
                                self.status = 2
                            } else if dietPlanObj as! Int == 3 {
                                self.status = 3
                            } else {
                              //  self.statusView.isHidden = true
                            }
                        }
                    }
                }
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if (self.packageId == "-MzqlVh6nXsZ2TCdAbOp" || self.packageId == "-MalAXk7gLyR3BNMusfi" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == self.ptpPackage || self.packageId == "-SgnMyAiDPuD8WVCipga"  || self.packageId == "-IdnMyAiDPoP9DFGkbas") {
                    if self.status == 0 {
                        let htmlStatus = "AiDP - tweakyfai (our own Ai platform) generates a Personalised diet plan.\n\nAs a \"My Tweak & Eat\" subscriber you can ask for your AiDP plan at any time.\n\nPlease click below to start the process.";
                        self.dietPlanCaseLbl.text = htmlStatus;
                        self.okBtn.setTitle("CLICK HERE", for: .normal)
                    } else if self.status == 1 {
                        self.dietPlanCaseLbl.text = "Your request has been sent to your assigned Nutritionist.\n\nYou will be notified as soon as the diet plan is ready.";
                        self.okBtn.setTitle("OK", for: .normal)
                    } else if self.status == 2 {
                        let htmlStatus = "Your assigned Nutritionist recommends an AiDP Diet Plan for you.\n\nWould you like to take a look at your AiDP Diet Plan? If so please click ‘Accept’ below and your diet plan will be prepared and published.\n\nYou will be notified as soon as the plan is published."
                        self.dietPlanCaseLbl.text = htmlStatus;
                        self.okBtn.setTitle("ACCEPT", for: .normal)
                    } else if self.status == 3 {
                        if self.isPublished == true {
                            self.statusView.isHidden = true

                        } else {
                        self.dietPlanCaseLbl.text = "You will get a notification as soon as your AiDP Diet Plan is published. Thank you.";
                        self.okBtn.setTitle("OK", for: .normal)
                        }
                    } else {
                        self.statusView.isHidden = true
                    }
                    }
                    self.collectionView.reloadData();
                    self.tableView.reloadData();
                }
                
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
                self.dietPopupView.isHidden = false
//                let refreshAlert = UIAlertController(title: "", message: "Your diet plan is getting ready... Please visit later..." , preferredStyle: UIAlertController.Style.alert);
//
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                    print("Handle Ok logic here");
//                    self.navigationController?.popViewController(animated: true);
//                }))
//
//                self.present(refreshAlert, animated: true, completion: nil);
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
                if (self.packageId == "-MzqlVh6nXsZ2TCdAbOp" || self.packageId == "-MalAXk7gLyR3BNMusfi" || self.packageId == "-AiDPwdvop1HU7fj8vfL" || self.packageId == self.ptpPackage || self.packageId == "-SgnMyAiDPuD8WVCipga"  || self.packageId == "-IdnMyAiDPoP9DFGkbas") {
                    self.chatIconButton.isHidden = true
                    self.questionIconButton.isHidden = true
                } else {
                self.questionIconButton.isHidden = true;
                self.chatIconButton.isHidden = true;
                self.optionsLabel.isHidden = true;
                }
              
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
if segue.identifier == "chat" {
            let destination = segue.destination as! ChatVC;
            destination.fromPackages = true;
            destination.donotChat = self.disableChat;
            destination.chatID = self.packageId;
        } else if segue.identifier == "profileView" {
            let destination = segue.destination as! ProfileInfoTableViewController;
            destination.packageID = self.packageId;
        }
    }
}
