//
//  GamifyViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 05/05/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit
import Firebase

class GamifyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GamifyBtnCell {
    func cellBtnTapped(_ cell: GamifyTableCell) {
        let cellDict = self.sectionsArray[cell.cellIndexPath] ;
        let btnLink = cellDict["btn_link"] as? String
        self.goToDesiredVC(promoAppLink: btnLink!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! GamifyTableCell
        let cellDict = self.sectionsArray[indexPath.row] ;
        cell.titleLbl.text = "  " + "\(cellDict["title"] as AnyObject)"
        cell.descLbl.text = (cellDict["text"] as? String)?.html2String
        cell.titleLbl.backgroundColor = UIColor.orange
        cell.buttonDelegate = self
        cell.cellIndexPath = indexPath.row
        
        if cellDict["btn_link"] as? String != "PP_LABELS" {
            cell.titleLbl.backgroundColor = UIColor.purple
        cell.btnWidthConstraint.constant = 200
        }
        let imageUrl = (cellDict["btn"] as? String)!
        
            let url = URL(string: imageUrl)
        DispatchQueue.global(qos: .background).async {
            // Call your background task
            let data = try? Data(contentsOf: url!)
            // UI Updates here for task complete.
         //   UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");

            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    
                    cell.buttonCell.setBackgroundImage(image, for: .normal)
                    
                }
        }
        

            
        }
        return cell;
        
    }
    
    @objc var uploadedImage : UIImage!;
    var fromWhichController = ""
    @objc var parameterDict : [String : AnyObject]!;
    @IBOutlet weak var continueBtn: UIButton!
    func goToHomePage() {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
          let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
       self.navigationController?.pushViewController(clickViewController!, animated: true)
         
      }
    
    @IBAction func continueTapped(_ sender: Any) {
        if self.fromWhichController == "" {
        let cellDict = self.lastIndexSection
        if cellDict["btn_link"] as? String == "START_TWEAKING" {
             
        self.navigationController?.popViewController(animated: true)
        } else {
             
            self.navigationController?.popViewController(animated: true)
            //self.goToHomePage()
        }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CONTINUE_TAKING_PHOTO"), object: nil);
       
        } else if self.fromWhichController == "TweakShareViewController"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                             let clickViewController = storyBoard.instantiateViewController(withIdentifier: "ImageUploadingViewController") as! ImageUploadingViewController;
                             clickViewController.uploadedImage = uploadedImage  as UIImage;
                             
                         
                             clickViewController.parameterDict = parameterDict
                             
                             self.navigationController?.pushViewController(clickViewController, animated: true);
        }
    }
    var countryCode = ""
    @IBOutlet weak var tableView: UITableView!
    var sectionsArray = [[String: AnyObject]]()
    var lastIndexSection = [String: AnyObject]()
    var ptpPackage = ""
    func moveToAnotherView(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == promoAppLink {
                        packageObj = premiumPackages.value as! [String : AnyObject]
                        
                    }
                    
                }
                
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if packageObj.count == 0 {
                        return
                    }
                    self.performSegue(withIdentifier: "moreInfo", sender: packageObj)
                }
            }
        })
    }
    
    func goToDesiredVC(promoAppLink: String) {
        //IndWLIntusoe3uelxER
        if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-IndWLIntusoe3uelxER" {
            
            
            if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-Qis3atRaproTlpr4zIs" || promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionLabels", sender: promoAppLink)

        } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
              self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-ClubInd3gu7tfwko6Zx" {
                   if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                      goToTAEClub()
                       
                   }
               } else if promoAppLink == "-MysRamadanwgtLoss99" {
                   if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)
                       
                   }
               } else if promoAppLink == self.ptpPackage {
            if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
            
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                

            }
        }
    }
    
    func goToTAEClub() {
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                     let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                     let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                     navController?.pushViewController(vc, animated: true);
         }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "nutritionLabels" {
                   let pkgID = sender as! String
                   let popOverVC = segue.destination as! NutritionLabelViewController;
                   popOverVC.packageID = pkgID
            popOverVC.fromWhichVC = "GamifyViewCOntroller"
               
               } else if segue.identifier == "moreInfo" {
                          let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
                          
                          let cellDict = sender as AnyObject as! [String: AnyObject]
                          popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!
                          popOverVC.fromHomePopups = true
        } else if segue.identifier == "myTweakAndEat" {
                   let destination = segue.destination as! MyTweakAndEatVCViewController
                  // if self.countryCode == "91" {
                       let pkgID = sender as! String
                       destination.packageID = pkgID

                  // }
               }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
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
        self.navigationItem.hidesBackButton = true
        let cellDict = self.lastIndexSection
        let imageUrl = (cellDict["btn"] as? String)!
               
                   let url = URL(string: imageUrl)
               DispatchQueue.global(qos: .background).async {
                   // Call your background task
                   let data = try? Data(contentsOf: url!)
                   // UI Updates here for task complete.
                //   UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");

                   if let imageData = data {
                       let image = UIImage(data: imageData)
                       DispatchQueue.main.async {
                           
                        self.continueBtn.setBackgroundImage(image, for: .normal)
                           
                       }
                }
        }
        self.view.backgroundColor = .groupTableViewBackground
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 137
        self.tableView.reloadData()
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
