//
//  ViewController.swift
//  SIA
//
//  Created by Mehera on 10/01/21.
//

import UIKit
import Firebase

private let siaChatUrl = "https://www.tweakandeat.com:5009/api/content/siappkgcontent/0"
class AskSiaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SIAButtonDelegate {
    var countryCode = ""
    var premiumPackagesArray = NSMutableArray()
    func cellTappedOnImageButton(_ cell: ImageReceiverCell) {
        let jsonDict = self.botMessages[cell.cellIndexPath.row]
        self.goToDesiredVC(link: jsonDict.siac_link)
    }
    
    func goToHomePage() {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
           let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        self.navigationController?.pushViewController(clickViewController!, animated: true)
          
       }
    func moveToAnotherView(link: String) {
        var packageObj = [String : AnyObject]();
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {

                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == link {
                        packageObj = premiumPackages.value as! [String : AnyObject]

                    }

                }

                dispatch_group.leave();

                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if packageObj.count == 0 {
                        self.goToHomePage()
                        return
                    }
                    self.showAvailablePremiumPackageVC(obj: packageObj)
                    //self.performSegue(withIdentifier: "fromAdsToMore", sender: packageObj)
                }
            }
        })
    }
    
    func showAvailablePremiumPackageVC(obj: [String : AnyObject]) {
        //AvailablePremiumPackagesViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                      let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
       let cellDict = obj as AnyObject as! [String: AnyObject]
       vc.packageID = (cellDict["packageId"] as AnyObject as? String)!
        vc.fromHomePopups = true
                      let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                      navController?.pushViewController(vc, animated: true);
    }
    func goToTAEClubMemPage() {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
          let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
       self.navigationController?.pushViewController(clickViewController!, animated: true)
         
      }
    func goToPurchaseTAEClubScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
        clickViewController?.fromPopUpScreen = true
        self.navigationController?.pushViewController(clickViewController!, animated: true)

    }
    func goToBuyScreen(packageID: String, identifier: String) {
            UserDefaults.standard.set(identifier, forKey: "POP_UP_IDENTIFIERS")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                                  }
                                  self.moveToAnotherView(link: packageID)

    
        }
    func showNutritionLabels(promoLink: String) {
        //NutritionLabelViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                       let vc : NutritionLabelViewController = storyBoard.instantiateViewController(withIdentifier: "NutritionLabelViewController") as! NutritionLabelViewController;
               vc.packageID = promoLink
                       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                       navController?.pushViewController(vc, animated: true);
    }
    func goToNutritonConsultantScreen(packageID: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
        clickViewController?.packageID = packageID
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    func showMyTweakAndEatVC(promoLink: String) {
        //MyTweakAndEatVCViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        vc.packageID = promoLink
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    
    
    
    func goToDesiredVC(link: String) {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        
        
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if link == "HOME" || link == "" {
            self.goToHomePage()
            //NCP_PUR_IND_OP
        } else if link == "NCP_PUR_IND_OP" {
            if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil {
             self.showMyTweakAndEatVC(promoLink: "-NcInd5BosUcUeeQ9Q32")
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
        self.goToBuyScreen(packageID: "-NcInd5BosUcUeeQ9Q32", identifier: link)
            }
        } else if link == "MYAIDP_PUR_IND_OP_3M" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
             self.showMyTweakAndEatVC(promoLink: "-AiDPwdvop1HU7fj8vfL")
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
        self.goToBuyScreen(packageID: "-AiDPwdvop1HU7fj8vfL", identifier: link)
            }
        } else if link == "MYTAE_PUR_IND_OP_3M" || link == "WLIF_PUR_IND_OP_3M" {
            if link == "MYTAE_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.showMyTweakAndEatVC(promoLink: "-IndIWj1mSzQ1GDlBpUt")
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: link)
                }
            } else if link == "WLIF_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.showMyTweakAndEatVC(promoLink: "-IndWLIntusoe3uelxER")
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: link)
                }
            }
        } else if link == "CLUB_PURCHASE" || link == "CLUB_PUR_IND_OP_1M" {
            
            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
              self.goToTAEClubMemPage()
            } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
        } else if link == "CLUB_SUBSCRIPTION" || link == clubPackageSubscribed {
            //MYTAE_PUR_IND_OP_3M
                      if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                         self.goToTAEClubMemPage()
                       } else {
                        DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self.view, animated: true);
                        }
                        self.moveToAnotherView(link: clubPackageSubscribed)                       }
        } else if link == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: link) != nil {
                self.goToNutritonConsultantScreen(packageID: link)
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(link: link)

                
                
            }
            
        } else if link == "PP_PACKAGES" {
          //  self.performSegue(withIdentifier: "buyPackages", sender: self);
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                                 let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
                  
                  // vc.fromHomePopups = true
                                 let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                                 navController?.pushViewController(vc, animated: true);
        } else if link == "PP_LABELS" || link == "-Qis3atRaproTlpr4zIs" {
           // self.performSegue(withIdentifier: "nutritionPack", sender: self)
            self.showNutritionLabels(promoLink: link)
        }else if link == "CHECK_THIS_OUT" {
           // self.performSegue(withIdentifier: "checkThisOut", sender: self)
        } else if link == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: link) != nil {
                self.goToNutritonConsultantScreen(packageID: link)
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(link: link)

                
                
            }
            
        } else  {
                   
                   
                   if UserDefaults.standard.value(forKey: link) != nil {
                    self.showMyTweakAndEatVC(promoLink: link)
                       //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
                   } else {
                       DispatchQueue.main.async {
                       MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(link: link)

                       
                       
                   }
                   
               }
        
      
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func cellTappedOnButton(_ cell: ButtonReceiverCell) {
        if self.botMessages[cell.cellIndexPath.row].userInteraction == false {
            return
        }
        print(self.botMessages[cell.cellIndexPath.row])
        let jsonDict = self.botMessages[cell.cellIndexPath.row]
       
        self.botMessages.append(BOTMessages(siac_id: jsonDict.siac_id, siac_code: jsonDict.siac_code, siac_lang: jsonDict.siac_lang, siac_text: jsonDict.siac_text, siac_pid: jsonDict.siac_pid, siac_order: jsonDict.siac_order, siac_type: jsonDict.siac_type, siac_img_url: jsonDict.siac_img_url, siac_link: jsonDict.siac_link, cellType: "SENDER"))
        self.botMessages = botMessages.map { (dict) -> BOTMessages in
            // dict is immutable, so you need a mutable shadow copy:
            var dict = dict

            dict.userInteraction = false
            return dict
        }
       // print(self.botMessages)
        self.getMessages(siaId: jsonDict.siac_id)
//        OperationQueue.main.addOperation({
//            self.botTable.reloadData()
//        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.botMessages.count > 0 {
           return self.botMessages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTRECEIVER") as! TextReceiverCell
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTSENDER") as! TextSenderCell
        //BUTTONRECEIVER
        let cellType = self.botMessages[indexPath.row].cellType
        let siac_type = self.botMessages[indexPath.row].siac_type

        if cellType == "RECEIVER" {
            if siac_type == "TEXT" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTRECEIVER") as! TextReceiverCell
                if self.botMessages[indexPath.row].siac_text.count < 60 {
                    cell.messageTextView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 5, right: 5)

                }
                cell.messageTextView.text = self.botMessages[indexPath.row].siac_text
                return cell
            } else if siac_type == "BUTTON" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BUTTONRECEIVER") as! ButtonReceiverCell
                cell.btnReceiverDelegate = self
                cell.cellIndexPath = indexPath
                if indexPath.row > self.botMessages.count {
                    cell.cellButton.isUserInteractionEnabled = false
                } else {
                    cell.cellButton.isUserInteractionEnabled = true

                }
                cell.messageTextView.text = self.botMessages[indexPath.row].siac_text

                return cell
            } else if siac_type == "IMGLINK" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IMAGERECEIVER") as! ImageReceiverCell
                cell.btnReceiverDelegate = self
                cell.cellIndexPath = indexPath
                cell.messageTextView.text = self.botMessages[indexPath.row].siac_text
                let urlString = self.botMessages[indexPath.row].siac_img_url
                cell.cellImageView.sd_setImage(with: URL(string: urlString)) { (image, error, cache, url) in
                                                                   // Your code inside completion block
                  let ratio = image!.size.width / image!.size.height
                  let newHeight = cell.cellImageView.frame.width / ratio
                 
                      UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                            animations: {
                                                cell.imageHeightConstraint.constant = newHeight
                                            
                                              cell.layoutIfNeeded()
                             }, completion: nil)


                  }
                
              
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TEXTSENDER") as! TextSenderCell
            cell.messageTextView.text = self.botMessages[indexPath.row].siac_text
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.botMessages[indexPath.row].siac_type == "BUTTON"  {
            return UITableView.automaticDimension

        }
        if self.botMessages[indexPath.row].siac_type == "IMGLINK" {
            return UITableView.automaticDimension

        }
        return self.botMessages[indexPath.row].siac_text.count < 60 ? 75 : UITableView.automaticDimension
    }
    
    @IBOutlet weak var botTable: UITableView!
    private var botMessages = [BOTMessages]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.botTable.dataSource = self
        self.botTable.delegate = self
        self.botTable.separatorStyle = .none
        self.botTable.estimatedRowHeight = 75
        self.botTable.rowHeight = UITableView.automaticDimension
        getLatestLoans()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    func getMessages(siaId: Int) {
        guard let loanUrl = URL(string: "https://www.tweakandeat.com:5009/api/content/siappkgcontent/\(siaId)") else {
            return
        }
     
        var request = URLRequest(url: loanUrl)
           request.httpMethod = "POST"

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.value(forKey: "userSession") as! String, forHTTPHeaderField: "Authorization")

       
           
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
     
            if let error = error {
                print(error)
                return
            }
     
            // Parse JSON data
            if let data = data {
                let botMessage: [BOTMessages] = self.parseJsonData(data: data)
                self.botMessages += botMessage
                print(self.botMessages)
                // Reload table view
                OperationQueue.main.addOperation({
                    self.botTable.reloadData()
                    self.botTable.scrollToRow(at: IndexPath.init(row: self.botMessages.count - 1, section: 0), at: .bottom, animated: false)
                })
            }
        })
     
        task.resume()
    }
    func getLatestLoans() {
        guard let loanUrl = URL(string: siaChatUrl) else {
            return
        }
     
        var request = URLRequest(url: loanUrl)
           request.httpMethod = "POST"

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UserDefaults.standard.value(forKey: "userSession") as! String, forHTTPHeaderField: "Authorization")

       
           
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
     
            if let error = error {
                print(error)
                return
            }
     
            // Parse JSON data
            if let data = data {
                self.botMessages = self.parseJsonData(data: data)
                print(self.botMessages)
                // Reload table view
                OperationQueue.main.addOperation({
                    self.botTable.reloadData()
                    
                })
            }
        })
     
        task.resume()
    }
     
    func parseJsonData(data: Data) -> [BOTMessages] {

        var messages = [BOTMessages]()

        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

            // Parse JSON data
            if jsonResult!["callStatus"] as! String == "GOOD" {
            let data = jsonResult?["data"] as! [AnyObject]
            for jsonDict in data {
                let botMessage = BOTMessages(siac_id: jsonDict["siac_id"] as! Int, siac_code: jsonDict["siac_code"] as! String, siac_lang: jsonDict["siac_lang"] as! String, siac_text: (jsonDict["siac_text"] as! String).html2String, siac_pid: jsonDict["siac_pid"] as! Int, siac_order: jsonDict["siac_order"] as! Int, siac_type: jsonDict["siac_type"] as! String, siac_img_url: jsonDict["siac_img_url"] as! String, siac_link: jsonDict["siac_link"] as! String)
                
                messages.append(botMessage)
            }
            }

        } catch {
            print(error)
        }

        return messages
    }

}



