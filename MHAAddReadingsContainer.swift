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

class MHAAddReadingsContainer: UIViewController {
    let realm :Realm = try! Realm()
    let dispatch_group = DispatchGroup()
    let logo = UIImage(named: "logo_symbol_45h")
    @IBOutlet var overlayView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    let datePickerView:UIDatePicker = UIDatePicker()
    
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var data1InputHeightConstraint: NSLayoutConstraint!
    @IBOutlet var data1HeightConstraint: NSLayoutConstraint!
    @IBOutlet var timeTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var data1Lbl: UILabel!
    @IBOutlet var readingsName: UILabel!
    @IBOutlet var data1InputTF: UITextField!
    
    var readingType : String = ""
    
    var params = [String : Any]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

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
        self.data1Lbl.text = "Weight Reading"
        self.data1InputTF.placeholder = "kg"
        
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func doneTapped(_ sender: Any) {
        if (data1InputTF.text == "") {
            self.data1InputTF.becomeFirstResponder()
            return
            
        }
        let myWeightObj = WeightInfo()
        let separator = " "
        let clientTime : String = dateTF.text! + separator + timeTF.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm b"
        
        let date = dateFormatter.date(from:clientTime)
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        let theDateStr = dateFormatter.string(from: date!)
        myWeightObj.datetime = theDateStr
        myWeightObj.weight = Double(self.data1InputTF.text!)!
        myWeightObj.id = incrementDatesID()
        myWeightObj.timeIn = dateFormatter.date(from: theDateStr)!
        saveToRealmOverwrite(objType: WeightInfo.self, objValues: myWeightObj)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "READINGS_ADDED"), object: nil)
        self.dismiss(animated: true, completion: {})
        
        
    }
    
    func incrementDatesID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WeightInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    
    @IBAction func datePickerTapped(_ sender: UITextField) {
        let formatter = DateFormatter();
        formatter.dateFormat = "dd/MM/yyyy";
       sender.text = formatter.string(from: Date())
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(MHAAddReadingsContainer.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTF.text = formatter.string(from: sender.date)
       
    }
    
    func setUpTextFieldDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm b"
        datePicker.addTarget(self, action: #selector(self.updateTextField), for: .valueChanged)
        self.timeTF.inputView = datePicker
        self.timeTF.text = formatter.string(from: Date())
    }
    
    func updateTextField(_ sender:Any) {
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
    
}
