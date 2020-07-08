//
//  PrivacyPoliciesViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 15/12/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase

class PrivacyPoliciesViewController: UIViewController {
    @objc var staticName: String = ""
    @objc var introTextArray : [AnyObject]? = nil;
    @objc var aboutAppRef : DatabaseReference!
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()
    @objc var lang = ""
    
    @IBOutlet weak var textView: UITextView!
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        // Do any additional setup after loading the view.
        MBProgressHUD.showAdded(to: self.view, animated: true);

        aboutAppRef = Database.database().reference().child("StaticText")
        bundle = Bundle.init(path: path!)! as Bundle
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
                lang = language
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
                lang = language
            }
//            aboutAppRef.child(lang).observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.exists() {
//                    let data = snapshot.value as! [String: AnyObject]
//                    print(data)
//                    if data.count > 0 {
//                    if self.staticName == TweakAndEatConstants.GUIDE_LINES {
//                        self.textView.text = (data["GuideLines"] as! String).html2String.replacingOccurrences(of: "\\\"", with: "").replacingOccurrences(of: "\\r\\n", with: "")
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                    }
//                    if self.staticName == TweakAndEatConstants.PRIVACY {
//                        self.textView.text = (data["PrivacyPolicy"] as! String).html2String.replacingOccurrences(of: "\\\"", with: "").replacingOccurrences(of: "\\r\\n", with: "")
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                    }
//                    if self.staticName == TweakAndEatConstants.TERMS_OF_USE {
//                        self.textView.text = (data["TermsOfUse"] as! String).html2String.replacingOccurrences(of: "\\\\\\\"", with: "").replacingOccurrences(of: "\">", with: "")
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                    }
//                    }
//                    
//                }
//                })
        }
        
        self.textView.layer.cornerRadius = 10.0
        let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
        APIWrapper.sharedInstance.getStaticText(lang: language, { (responceDic : AnyObject!) ->(Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {

                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    self.introTextArray = response[TweakAndEatConstants.DATA] as? [AnyObject];
                    if(self.introTextArray != nil) {
                        let introTextDic = self.introTextArray!.filter({ (element) -> Bool in
                            if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == self.staticName) {
                                return true;
                            } else {
                                return false;
                            }
                        })
                        var welcomeText : String? = nil;

                        if(introTextDic.count > 0) {
                            welcomeText = ((introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? String)?.replacingOccurrences(of: "\\\"", with: "").replacingOccurrences(of: "\\\\", with: "");
                        }
                        if(welcomeText != nil) {
             self.changeFonts1((welcomeText!.html2AttributedString.mutableCopy()) as! NSMutableAttributedString);
                        }

                    }
                }
            } else {
                //error
                MBProgressHUD.hide(for: self.view, animated: true);
            }
        }) { (error : NSError!) -> (Void) in
            //error
            MBProgressHUD.hide(for: self.view, animated: true);
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
        }
    }
    
    @objc func changeFonts1(_ htmlString : NSMutableAttributedString) {
        htmlString.beginEditing();
        htmlString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                let oldFont : UIFont = value as! UIFont;
                htmlString.removeAttribute(NSAttributedString.Key.font, range: range);
                
                if(oldFont.fontName == "TimesNewRomanPS-BoldMT") {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Semibold", size: 18)!;
                    htmlString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range);
                } else {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Regular", size: 16)!;
                    htmlString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range);
                }
            }
        })
        
        htmlString.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                htmlString.removeAttribute(NSAttributedString.Key.foregroundColor, range: range);
                htmlString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 147.0/255, green: 147.0/255, blue: 147.0/255, alpha: 1.0), range: range);
            }
        })
        
        htmlString.endEditing();
        self.setTermsOfUse(htmlString);
    }
    
    @objc func setTermsOfUse(_ attributedText : NSAttributedString) {
        
        self.textView.attributedText = attributedText;
        MBProgressHUD.hide(for: self.view, animated: true);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
