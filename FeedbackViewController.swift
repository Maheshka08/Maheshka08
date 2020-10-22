//
//  FeedbackViewController.swift
//  Tweak and Eat
//
//  Created by Mehera on 24/09/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import UIKit
import MessageUI

let NUMBER_OF_CHAR = 230
class FeedbackViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.feedbackTextView.keyboardType = .asciiCapable
        self.setupUI()
        
    }
    
    func sendFeedBack() {
        if feedbackTextView.text == "" {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please enter your feedback and continue!")
return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)

        APIWrapper.sharedInstance.postReceiptData(TweakAndEatURLConstants.SAVE_FEEDBACK, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, params: ["feedBack": self.feedbackTextView.text] as [String: AnyObject], success: { response in
                         var responseDic : [String:AnyObject] = response as! [String:AnyObject];
                         var responseResult = ""
                         if responseDic.index(forKey: "callStatus") != nil {
                             responseResult = responseDic["callStatus"] as! String
                         } else if responseDic.index(forKey: "CallStatus") != nil {
                             responseResult = responseDic["CallStatus"] as! String
                         }
                         if  responseResult == "GOOD" {
                             MBProgressHUD.hide(for: self.view, animated: true);
                            self.feedbackTextView.text = ""
                            self.view.endEditing(true)
                            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Thank you for your feedback!")

                         }
                     }, failure : { error in
                         MBProgressHUD.hide(for: self.view, animated: true);
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please check your internet connection!")

                         
                     })
    }
    
    func setupUI() {
        self.title = "Feedback"
        self.feedbackTextView.layer.cornerRadius = 10
        self.sendFeedbackButton.layer.cornerRadius = 18
        let emailBtnAttr : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)]
               let attributeString = NSMutableAttributedString(string: "appsmanager@purpleteal.com",
                                                                  attributes: emailBtnAttr)
               self.emailButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(textView.text.count)/\(NUMBER_OF_CHAR)"
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    return textView.text.count + (text.count - range.length) <= NUMBER_OF_CHAR
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["appsmanager@purpleteal.com"])
            //mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setSubject("Your feedback matters to us")
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func sendFeedBackBtnTapped(_ sender: Any) {
        sendFeedBack()
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        sendEmail()
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
