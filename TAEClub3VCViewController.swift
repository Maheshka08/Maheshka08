//
//  TAEClub3VCViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 08/08/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit

class TAEClub3VCViewController: UIViewController {
    @IBOutlet weak var text2Lbl: UILabel!
    @IBOutlet weak var text3Lbl: UILabel!
       @IBOutlet weak var text1Lbl: UILabel!
    @IBOutlet weak var text1LblView: UIView!
       @IBOutlet weak var text2LblView: UIView!
    @IBOutlet weak var text4TV: UITextView!
    @IBOutlet weak var nextBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.text1LblView.layer.cornerRadius = 5
        self.text2LblView.layer.cornerRadius = 5
        
        self.getClub3Info()
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
                
                UIView.animate(
                    withDuration: 0.5,
                animations: {
                    self.text1LblView.alpha = 1
                    },  completion: {(_ completed: Bool) -> Void in

                              })

//                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//                    self.text1LblView.alpha = 1
//
//                }) { _ in
//
//                }


            }
            if dict["name"] as! String == "text2" {
                            let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                                             
                                           let attributedString = getAttributedString(htmlText: htmlText)
                self.text2Lbl.attributedText = attributedString
                self.text2Lbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 20.0)
                UIView.animate(
                    withDuration: 0.5, delay: 1,
                               animations: {
                                   self.text2LblView.alpha = 1
                                   },  completion: {(_ completed: Bool) -> Void in

                                             })
            }
            if dict["name"] as! String == "text3" {
                            let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                                             
                                           let attributedString = getAttributedString(htmlText: htmlText)
                self.text3Lbl.attributedText = attributedString
                self.text3Lbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 24.0)
                UIView.animate(
                    withDuration: 0.5, delay: 1.5,
                               animations: {
                                   self.text3Lbl.alpha = 1
                                   },  completion: {(_ completed: Bool) -> Void in

                                             })

            }
            if dict["name"] as! String == "benefits" {
                            let htmlText = (dict["value"] as! String).replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
                                             
                                           let attributedString = getAttributedString(htmlText: htmlText)
                self.text4TV.attributedText = attributedString
                self.text4TV.font = UIFont(name:"QUESTRIAL-REGULAR", size: 20.0)
                self.text4TV.textAlignment = .left
                UIView.animate(
                    withDuration: 0.5, delay: 2.5,
                animations: {
                    self.text4TV.alpha = 1
                    },  completion: {(_ completed: Bool) -> Void in

                              })


            }
              if dict["name"] as! String == "title" {
                  self.title = (dict["value"] as! String)
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
    
    func getClub3Info() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_SUB3, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                  
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
