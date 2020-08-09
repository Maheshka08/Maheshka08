//
//  TAEClub1VCViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 07/08/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

class TAEClub1VCViewController: UIViewController {

    @IBOutlet weak var gotItBtn: UIButton!
    
    @IBOutlet weak var club1ImageView: UIImageView!
    @IBAction func gotItTapped(_ sender: Any) {
    }
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if UserDefaults.standard.value(forKey: "TAE_CLUB1_DATA") != nil {
//            let data = UserDefaults.standard.value(forKey: "TAE_CLUB1_DATA") as! [[String: AnyObject]]
//            updateUI(data: data)
//        } else {
//            //getClub1Info()
//        }
        getClub1Info()

    }
    
    func updateUI(data: [[String: AnyObject]] ) {
        if data.count == 0 {
            
        } else {
          for dict in data {
              if dict["name"] as! String == "submit_btn_title" {
                  let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                  let encodedData = htmlText.data(using: String.Encoding.utf8)!
                    var attributedString: NSAttributedString

                    do {
                        attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
                    
                      let textAttribute: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white, .font: UIFont(name:"QUESTRIAL-REGULAR", size: 24.0)!]

                      self.gotItBtn.setAttributedTitle(NSAttributedString(string: attributedString.string, attributes: textAttribute), for: .normal)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    } catch {
                        print("error")
                    }
              }
                  if dict["name"] as! String == "body_img" {
                      let urlString = dict["value"] as! String

                      self.club1ImageView.sd_setImage(with: URL(string: urlString)) { (image, error, cache, url) in
                                                                       // Your code inside completion block
                      let ratio = image!.size.width / image!.size.height
                      let newHeight = self.club1ImageView.frame.width / ratio
                     
                          UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                animations: {
                                                 self.imageViewHeightConstraint.constant = newHeight
                                                  self.view.layoutIfNeeded()
                                 }, completion: nil)


                      }
              }
              if dict["name"] as! String == "title" {
                  self.title = (dict["value"] as! String)
              }

          }
        }
    }
    
    func getClub1Info() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_SUB1, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                    UserDefaults.standard.set(data, forKey: "TAE_CLUB1_DATA")
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
