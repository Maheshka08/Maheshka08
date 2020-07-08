//
//  MHAAddReadingsContainer.swift
//  My Health Assistant
//
//  Created by  Meher Uday Swathi on 21/07/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Firebase
import FirebaseDatabase
class MHAAddReadingsContainer: UIViewController, UITextFieldDelegate {
    
    let realm :Realm = try! Realm()
    @objc let dispatch_group = DispatchGroup()
    @objc let logo = UIImage(named: "logo_symbol_45h")
    @IBOutlet var overlayView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @objc let datePickerView:UIDatePicker = UIDatePicker()
    
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var data1InputHeightConstraint: NSLayoutConstraint!
    @IBOutlet var data1HeightConstraint: NSLayoutConstraint!
    @IBOutlet var timeTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var data1Lbl: UILabel!
    @IBOutlet var readingsName: UILabel!
    @IBOutlet var data1InputTF: UITextField!
    @objc var snapShot = ""
    @objc var dateTime = ""
    @objc var weight = ""
    @objc var readingType : String = ""
    @objc var params = [String : Any]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.weight != "" {
        self.data1InputTF.text = self.weight
            self.dateTF.isUserInteractionEnabled = false
            self.timeTF.isUserInteractionEnabled = false
            self.dateTF.textColor = UIColor.lightGray
            self.timeTF.textColor = UIColor.lightGray
        }
        self.data1InputTF.delegate = self
        self.navigationItem.hidesBackButton = true
        let btn3 = UIButton(type: .custom)
        btn3.setImage(logo, for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let item3 = UIBarButtonItem(customView: btn3)
        
        let btn4 = UIButton(type: .custom)
        btn4.setTitle("MHA",for:.normal)
        btn4.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let item4 = UIBarButtonItem(customView: btn4)
        btn4.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.setLeftBarButtonItems([item3,item4], animated: true)
        self.title = "Add Readings"
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])

        self.navigationItem.hidesBackButton = true
        self.overlayView.layer.cornerRadius = 10.0
        self.overlayView.layer.masksToBounds = true
        self.doneBtn.layer.cornerRadius = 10.0
        self.doneBtn.layer.masksToBounds = true
        self.cancelBtn.layer.cornerRadius = 10.0
        self.cancelBtn.layer.masksToBounds = true
        self.data1InputTF.setBottomBorder()
        
        datePickerTapped(dateTF)
        self.setUpTextFieldDatePicker()
        self.readingsName.text = "Weight Reading"
        self.data1Lbl.text = "Weight Readings"
        self.data1InputTF.placeholder = "weight"
        
    }
  
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
         if textField == data1InputTF {
        // Block multiple dot
        if (textField.text?.contains("."))! && string == "." {
            return false
        }
        }
        let newLength = text.characters.count + string.characters.count - range.length
        if textField == data1InputTF {
            return newLength <= 6
        }

        return newLength <= 0
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    func currentTimeInMiliseconds(dateStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        
        let currentDate = dateFormatter.date(from:dateStr)
        let since1970 = currentDate!.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if (data1InputTF.text == "") {
            TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please enter weight");
            self.data1InputTF.becomeFirstResponder()
            return
            
        }
        let myWeightObj = WeightInfo()
        let separator = " "
        let clientTime : String = dateTF.text! + separator + timeTF.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MM yyyy hh:mm b"
        
        let date = dateFormatter.date(from:clientTime)
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        let theDateStr = dateFormatter.string(from: date!)
        myWeightObj.datetime = theDateStr
        myWeightObj.weight = Double(self.data1InputTF.text!)!
        myWeightObj.id = incrementDatesID()
        myWeightObj.timeIn = dateFormatter.date(from: theDateStr)!
        saveToRealmOverwrite(objType: WeightInfo.self, objValues: myWeightObj)
       var milliseconds = currentTimeInMiliseconds(dateStr: theDateStr);
      
        if self.snapShot != "" {
            milliseconds = Int(self.dateTime)!
 Database.database().reference().child("UserWeight").child((Auth.auth().currentUser?.uid)!).child(self.snapShot).updateChildValues(["weight": self.data1InputTF.text!, "datetime": milliseconds], withCompletionBlock: { (error, _) in
                if error == nil {
                    
                } else {
                    print(error?.localizedDescription)
                }
            })
        } else {
            Database.database().reference().child("UserWeight").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["weight": self.data1InputTF.text!, "datetime": milliseconds], withCompletionBlock: { (error, _) in
            if error == nil {
          
            } else {
                print(error?.localizedDescription)
            }
        })
        }
        UserDefaults.standard.setValue("YES", forKey: "WEIGHT_SENT_TO_FIREBASE")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "READINGS_ADDED"), object: nil)
        self.dismiss(animated: true, completion: {})
        
    }
    
    @objc func incrementDatesID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WeightInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
   
    @IBAction func datePickerTapped(_ sender: UITextField) {
        let formatter = DateFormatter();
        formatter.dateFormat = "d MMM yyyy";
       sender.text = formatter.string(from: Date())
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(MHAAddReadingsContainer.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        dateTF.text = formatter.string(from: sender.date)
       
    }
    
    @objc func setUpTextFieldDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .time
        datePicker.date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm b"
        datePicker.addTarget(self, action: #selector(self.updateTextField), for: .valueChanged)
        self.timeTF.inputView = datePicker
        self.timeTF.text = formatter.string(from: Date())
    }
    
    @objc func updateTextField(_ sender:Any) {
        let picker: UIDatePicker? = (self.timeTF.inputView as? UIDatePicker)
        _ = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm b"
        let dateString: String? = formatter.string(from: (picker?.date)!)
        self.timeTF.text = dateString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
