//
//  TAEClub2VCViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 07/08/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

class TAEClub2VCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.nutritionistsInfoArray.count > 0 {
            return self.nutritionistsInfoArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDict = self.nutritionistsInfoArray[indexPath.row]
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as! TAEClub2TableViewCellLeft
            cell.nameLbl.text = (cellDict["cn_name"] as! String)
            cell.descLbl.text = (cellDict["cn_details"] as! String)
            cell.selectionStyle = .none
            let imageUrl = (cellDict["cn_image"] as! String)
            cell.profilePic.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as! TAEClub2TableViewCellRight
            cell.nameLbl.text = (cellDict["cn_name"] as! String)
            cell.descLbl.text = (cellDict["cn_details"] as! String)
            let imageUrl = (cellDict["cn_image"] as! String)
            cell.selectionStyle = .none
            cell.profilePic.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1.0, animations: {
                cell.transform = CGAffineTransform.identity
            })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121
    }
    
    var nutritionistsInfoArray = [[String: AnyObject]]()
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var text2Lbl: UILabel!
    @IBOutlet weak var text1Lbl: UILabel!
    @IBOutlet weak var text2LblView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.text2LblView.layer.cornerRadius = 5
        self.text2LblView.isHidden = true
        // Do any additional setup after loading the view.
//        if UserDefaults.standard.value(forKey: "TAE_CLUB2_DATA") != nil {
//            let data = UserDefaults.standard.value(forKey: "TAE_CLUB2_DATA") as! [[String: AnyObject]]
//            updateUI(data: data)
//        } else {
//           // getClub1Info()
//        }
        self.getClub2Info()


        
    }
    
    func updateUI(data: [[String: AnyObject]] ) {
        if data.count == 0 {
            
        } else {
          for dict in data {
              if dict["name"] as! String == "submit_btn_title" {
                  let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                  
                let attributedString = getAttributedString(htmlText: htmlText)
                let textAttribute: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white, .font: UIFont(name:"QUESTRIAL-REGULAR", size: 24.0)!]

                    self.nextBtn.setAttributedTitle(NSAttributedString(string: attributedString.string, attributes: textAttribute), for: .normal)
              }
            
            if dict["name"] as! String == "text1" {
                            let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                                             
                                           let attributedString = getAttributedString(htmlText: htmlText)
                self.text1Lbl.attributedText = attributedString
                self.text1Lbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 20.0)

            }
            if dict["name"] as! String == "text2" {
                            let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                                             
                                           let attributedString = getAttributedString(htmlText: htmlText)
                self.text2Lbl.attributedText = attributedString
                self.text2Lbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 22.0)
                self.text2LblView.isHidden = false

            }
              if dict["name"] as! String == "title" {
                  self.title = (dict["value"] as! String)
              }
            if dict["name"] as! String == "nu_list" {
                self.nutritionistsInfoArray = (dict["value"] as! [[String: AnyObject]])
                self.tblView.reloadData()
                
            }

          }
        }
    }
    
    func getAttributedString(htmlText: String) -> NSAttributedString {
        let encodedData = htmlText.data(using: String.Encoding.utf8)!
                           var attributedString: NSAttributedString

                           do {
                               attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
                           
                             return attributedString

                           } catch let error as NSError {
                               print(error.localizedDescription)
                           } catch {
                               print("error")
                           }
        return NSAttributedString()
        
    }
    
    func getClub2Info() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_SUB2, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                    UserDefaults.standard.set(data, forKey: "TAE_CLUB2_DATA")
                    UserDefaults.standard.synchronize()
                    self.updateUI(data: data)

                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
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
