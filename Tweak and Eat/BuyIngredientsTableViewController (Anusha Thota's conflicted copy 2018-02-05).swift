//
//  BuyIngredientsTableViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 24/01/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BuyIngredientsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, BuyIngredientCellDelegate {
   
    
    var cellIndexPath: Int = 0
    var myIndexPath: IndexPath!
    var ingredientsArrayList = NSMutableArray()
    var daySelcted: String!
    var ingredientsUnits = NSMutableArray()
    var totalResult : String!
    var vendorsArray = [[String : AnyObject]]()
    var vendorKey :String = ""
    @IBOutlet weak var companyNameTF: UITextField!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if unitsString == "names"{
            return 1
        }else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if unitsString == "names"{
            return self.vendorsArray.count
        }
        else {
            if component == 0 {
                return self.kgsArray.count
        }
        return units.count
    }
    }
    
    var units = ["gms","kgs", "lit", "ml"]
    var gmsArray = [String]()
    var kgsArray = [String]()
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var unitsString : String!
    var vendorListRef : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyNameTF.text = ""
        vendorListRef = Database.database().reference().child("FulfilmentVendors")
        vendorListRef.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                for vendorLists in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    var vendors = vendorLists.value as? [String : AnyObject];
                    vendors!["key"] = vendorLists.key as AnyObject
                    self.vendorsArray.append(vendors!)
                    
                    print(self.vendorsArray)
                    self.companyNameTF.text = (self.vendorsArray[0]["name"] as? String)!
                    self.vendorKey = (self.vendorsArray[0]["key"] as? String)!
                    print(self.vendorKey)
                }
            }
            
        })
        
        self.companyNameTF.delegate = self
        
        doneButton();
        
//        for i in 1...1000{
//            let str1 = String(i)
//            self.kgsArray.append(str1)
//
//        }
   self.kgsArray = ["50","100","150","200","250","300","350","400","450","500","550","600","650","700","750","800","850","900","950"]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if unitsString == "names"{
       
            return self.vendorsArray[row]["name"] as? String

        }
        else {
            
        if component == 0{
            
            return kgsArray[row]
        }
        }
        let unit : String = units[pickerView.selectedRow(inComponent: 1)]

                let kgsString : String = kgsArray[pickerView.selectedRow(inComponent: 0)]
        totalResult = kgsString + " " + unit


        return units[row]
    }
    
    // MARK: - BuyIngredientsCellDelegate Methods
    
    func cellTappedOnCheckedBtn(_ cell: BuyIngredientsCell) {
        if cell.checkedBox.imageView?.image == UIImage.init(named: "checked_box.png") {
        cell.checkedBox.setImage(UIImage.init(named: "check_box.png"), for: .normal)
            cell.qtyTextField.text = ""
        } else {
            cell.checkedBox.setImage(UIImage.init(named: "checked_box.png"), for: .normal)
            cell.qtyTextField.becomeFirstResponder()


        }
    }
    func cellTappedOnTextField(_ cell: BuyIngredientsCell) {
        pickerView.delegate = self
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        let ingredient = ingredientsArrayList[self.myIndexPath.row] as? String
        if (ingredient?.contains("kg"))! || (ingredient?.contains("count"))! {
            units = ["gms","kgs"]
        } else if (ingredient?.contains("ml"))! {
            units = ["ml","lt"]
        }
        unitsString = "qty"
        cell.qtyTextField.inputView = pickerView
        cell.qtyTextField.inputAccessoryView = toolBar
        pickerView.reloadAllComponents()
        self.pickerView.selectRow(0, inComponent: 0, animated: false)

    }
    
    func didEndEditingTextField(_ cell: BuyIngredientsCell) {
        if cell.qtyTextField.text == "" {
        cell.checkedBox.setImage(UIImage.init(named: "check_box.png"), for: .normal)
        } else {
            cell.checkedBox.setImage(UIImage.init(named: "checked_box.png"), for: .normal)

        }

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArrayList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if unitsString == "names"{
            self.companyNameTF.text = self.vendorsArray[row]["name"] as? String
            self.vendorKey = (self.vendorsArray[pickerView.selectedRow(inComponent: 0)]["key"] as? String)!
        }else{
        let cell = tableView.cellForRow(at: self.myIndexPath) as! BuyIngredientsCell
        
        let unit : String = units[pickerView.selectedRow(inComponent: 1)]
            if (unit == "ml" || unit == "gms") {
                self.kgsArray = []
            self.kgsArray = ["50","100","150","200","250","300","350","400","450","500","550","600","650","700","750","800","850","900","950"]
            } else {
                self.kgsArray = []
                for i in 1...500{
                    let str1 = String(i)
                    self.kgsArray.append(str1)
                    
                }
            }
            //self.pickerView.reloadAllComponents()
            self.pickerView.reloadComponent(0)
            //self.pickerView.selectRow(0, inComponent: 0, animated: false)

        
        let kgsString : String = kgsArray[pickerView.selectedRow(inComponent: 0)]

        totalResult = kgsString + " " + unit
        cell.qtyTextField.text = totalResult
        
    }
    }
 
    func doneButton(){
        
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        companyNameTF.inputAccessoryView = toolBar

        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 89/255, green: 0/255, blue: 120/255, alpha: 1.0);
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BuyIngredientsTableViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BuyIngredientsTableViewController.canclePicker))
        
        toolBar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
    }
    
    
    func donePicker() {
        if unitsString == "names"{
            self.view.endEditing(true)
         return
        }
        let cell = tableView.cellForRow(at: self.myIndexPath) as! BuyIngredientsCell
        cell.qtyTextField.text = totalResult
        self.view.endEditing(true)
    
    }
    
    func canclePicker() {
        if unitsString == "names"{
            self.view.endEditing(true)
            return
        }
        let cell = tableView.cellForRow(at: self.myIndexPath) as! BuyIngredientsCell
        cell.qtyTextField.text = ""
         self.view.endEditing(true)

    }
    
 

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == companyNameTF {
            self.unitsString = "names"
            pickerView.delegate = self
            self.companyNameTF.inputView = pickerView
            pickerView.reloadAllComponents()
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! BuyIngredientsCell;
        //if cell.cellDelegate != nil {
        cell.cellDelegate = self
        //}
        cell.myIndexPath = indexPath
        cell.cellIndexPath = indexPath.row
        let ingredient = ingredientsArrayList[indexPath.row] as? String
        let ingredientArray = ingredient?.components(separatedBy: "-")
        cell.ingredientsLabel.text = ingredientArray?[0]
       
        
        
        return cell
    }
    
}

