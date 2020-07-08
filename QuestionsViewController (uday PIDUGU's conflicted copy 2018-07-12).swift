//
//  QuestionsViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 6/25/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, TextViewDelegate, CheckboxDelegate, SwitchCellDelegate {
    func cellTappedOnCheckBoxAnswerTV(_ cell: CheckBoxTableViewCell) {
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.nextButtonBottomContraint.constant = 0
        
        answer = cell.answerTextView.text
        //questionValues["answer"] = answer as AnyObject
       // let cellDict = self.section0[cell.cellIndexPath] as! Dictionary<String, AnyObject>

        let valuesArray = questionValues["value"] as AnyObject as! NSMutableArray
        var valuesDict = valuesArray[cell.cellIndexPath] as! Dictionary<String, AnyObject>
        valuesDict["answer"] = answer as AnyObject
        questionValues["value"]?.removeObject(at: cell.cellIndexPath)
        questionValues["value"]?.insert(valuesDict, at: cell.cellIndexPath)


    }
    
    func cellDidBeginOnCheckBoxAnswerTV(_ cell: CheckBoxTableViewCell) {
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.nextButtonBottomContraint.constant = 220
//        if cell.checkBoxButton.imageView?.image == UIImage.init(named: "check_box.png") {
//                cell.answerTextView.isUserInteractionEnabled = false
//                cell.answerTextView.resignFirstResponder()
//            
//        } else {
//            cell.answerTextView.isUserInteractionEnabled = true
//            cell.answerTextView.becomeFirstResponder()
//        }

    }
    
    func cellTappedOnSwitchAnswerTV(_ cell: SwitchTableViewCell) {
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.nextButtonBottomContraint.constant = 0
        
       let cellAnswer = cell.answerTextView.text
        let valuesArray = questionValues["value"] as AnyObject as! NSMutableArray
        var valuesDict = valuesArray[cell.cellIndexPath] as! Dictionary<String, AnyObject>
        valuesDict["answer"] = cellAnswer as AnyObject
        questionValues["value"]?.removeObject(at: cell.cellIndexPath)
        questionValues["value"]?.insert(valuesDict, at: cell.cellIndexPath)
    }
    
    func cellDidBeginOnSwitchAnswerTV(_ cell: SwitchTableViewCell) {
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.nextButtonBottomContraint.constant = 220

    }
    
   
    
    func cellTappedOnSwitch(_ cell: SwitchTableViewCell) {
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        if cell.answerSwitch.isOn {
            
            answer = "Y"
            
            
        } else {
            
            answer = "N"
            
            
        }
        questionValues["answer"] = answer as AnyObject
        
        
    }
    
    func cellTappedOnAnswerTV(_ cell: TextAreaTableViewCell) {
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        self.nextButtonBottomContraint.constant = 0

        answer = cell.answerTextView.text
        questionValues["answer"] = answer as AnyObject
    }
    
    func cellDidBeginOnAnswerTV(_ cell: TextAreaTableViewCell) {
        self.nextButtonBottomContraint.constant = 220

    }
    
    func cellTappedOnCheckBox(_ cell: CheckBoxTableViewCell) {
        self.view.endEditing(true)
        self.cellIndexPath = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
        let cellDict = self.section0[cell.cellIndexPath] as AnyObject
        if cell.checkBoxButton.imageView?.image == UIImage.init(named: "check_box.png") {
            cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
            if questionValues.index(forKey: "Y") != nil {

            self.addValuesArray.add(cellDict["name"] as AnyObject as! String)
            } else {
                self.addValuesArray.add(cellDict as AnyObject as! String)

            }
            print(self.addValuesArray)
        } else {
            subQuestion = ""
            cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
            if self.addValuesArray.count != 0 {
         self.addValuesArray.removeObject(identicalTo: cellDict)
            }
           // self.addValuesArray.remove(cellDict as AnyObject as! String)
            print(self.addValuesArray)
            
        }
    }
    
    
    
    @IBAction func popBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
//    func cellDidEndOnAnswerTV(_ cell: QuestionsTableCell) {
//        self.cellTVIndexPath = cell.cellIndexPath
//        self.myTVIndexPath = cell.myIndexPath
//        self.nextButtonBottomContraint.constant = 0
//        answer = cell.textAreaTextView.text
//        questionValues["answer"] = answer as AnyObject
//
//    }
    
//    func cellTappedOnSwitch(_ cell: QuestionsTableCell) {
//        self.cellTVIndexPath = cell.cellIndexPath
//        self.myTVIndexPath = cell.myIndexPath
//       
//        
//    }
//    func cellTappedOnCheckBox(_ cell: QuestionsTableCell) {
//        self.cellIndexPath = cell.cellIndexPath
//        self.myIndexPath = cell.myIndexPath
//        let cellDict = self.section0[cell.cellIndexPath] as! Dictionary<String, AnyObject>
//        if cell.checkBoxButton.imageView?.image == UIImage.init(named: "check_box.png") {
//            cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
//            self.addValuesArray.add(cellDict["name"] as AnyObject as! String)
//            print(self.addValuesArray)
//            // self.selection = "Y"
//            if questionValues.index(forKey: "Y") != nil {
//                for obj in questionValues["Y"] as! NSMutableArray {
//                var objDict = obj as! Dictionary<String, AnyObject>
//                 subQuestion = objDict["question"] as AnyObject as! String
//                }
//               // heightConstraint += 177
//                let indexPath = IndexPath(item: self.myIndexPath.row, section: 0)
//                self.questionsTableView.reloadRows(at: [indexPath], with: .none)
//
//            }
//            
//            
//        } else {
//            subQuestion = ""
//            cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
//            // if self.addValuesArray.count > cell.cellIndexPath {
//            // self.addValuesArray.removeObject(at: cell.cellIndexPath)
//            self.addValuesArray.remove(cellDict["name"] as AnyObject as! String)
//            // self.selection = "N"
//            // }
//            let indexPath = IndexPath(item: self.myIndexPath.row, section: 0)
//            self.questionsTableView.reloadRows(at: [indexPath], with: .none)
//            print(self.addValuesArray)
//           
//        }
//        
//       
//
//        
//    }
    
    var myArray = [1,2,3,4,5]
    var genderArray = ["Male", "Female"]
    var heightArray = [Int](20...250)
    var whichPicker = ""
    var heightConstraint = 0
    var selection = ""
    var addValuesArray = NSMutableArray()
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if whichPicker == "GENDER" {
            return genderArray.count

        } else {
            return heightArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if whichPicker == "GENDER" {
            return genderArray[row]
            
        } else {
            return "\(heightArray[row])"
        }
      
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.questionsTableView.cellForRow(at: indexPath) as! TextAreaTableViewCell
        if whichPicker == "GENDER" {
        cell.answerTextView.text = genderArray[row]
        } else {
            cell.answerTextView.text = "\(heightArray[row])"
        }
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section0.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myCell = UITableViewCell();

        if type == "EditText" || type == "TextArea" || type == "RadioButton" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textAreaCell", for: indexPath) as! TextAreaTableViewCell;
            cell.cellDelegate = self
                cell.answerTextView.text = ""
            cell.myIndexPath = indexPath;
            cell.cellIndexPath = indexPath.row;
            if self.questionValues.index(forKey: "answer") != nil {
//            for obj in self.answersArray {
//                let objDict = obj as! Dictionary<String, AnyObject>
//                for (key, val) in objDict {
//                    if key == self.questionKey {
//                        cell.answerTextView.text = "\(val["answer"] as AnyObject)"
//                    }
//                }
//            }
                cell.answerTextView.text = self.questionValues["answer"] as AnyObject as! String
               
                } else {
                    if question.contains("AGE") {
                        
                        cell.answerTextView.text = self.age
                    } else if question.contains("GENDER") {
                        
                        
                        if self.sex == "M" {
                            cell.answerTextView.text = "Male"
                        } else {
                            cell.answerTextView.text = "Female"
                        }
                    } else if question.contains("HEIGHT") {
                        
                        
                        cell.answerTextView.text = self.height
                    } else if question.contains("WEIGHT") {
                        
                        
                        cell.answerTextView.text = self.weight
                    }
                }
                if cell.answerTextView.text.isEmpty {
                    cell.placeholderLabel.isHidden = false
                } else {
                    cell.placeholderLabel.isHidden = true
                    
                }
                
                cell.answerTextView.textAlignment = .center
                answer = cell.answerTextView.text
                //questionValues["answer"] = answer as AnyObject
                
                
                
            cell.answerTextView.inputView = nil

            if questionValues.index(forKey: "condition") != nil {
                condition = questionValues["condition"] as AnyObject as! String
                if condition == "alphanumeric" {
                    cell.answerTextView.keyboardType = UIKeyboardType.default
                } else if condition == "number" {
                    cell.answerTextView.keyboardType = UIKeyboardType.numberPad
                } else if  condition == "picker" {
                    let pickerView = UIPickerView()
                    pickerView.delegate = self
                    cell.answerTextView.inputView = pickerView
                    if question.contains("HEIGHT") {
                        whichPicker = "HEIGHT"
                    } else if question.contains("GENDER") {
                        whichPicker = "GENDER"
                    }
                } else if condition == "decimal" {
                    cell.answerTextView.inputView = nil
                    cell.answerTextView.keyboardType = UIKeyboardType.decimalPad
                }
            } else {
                cell.answerTextView.keyboardType = UIKeyboardType.default
                
            }
            return cell
        } else if type == "switch" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell;
                cell.switchDelegate = self
            cell.answerTextView.text = ""

            cell.myIndexPath = indexPath;
            cell.cellIndexPath = indexPath.row;
            cell.answerSwitch.setOn(false, animated: false)
                if questionValues.index(forKey: "answer") != nil {
                    if questionValues["answer"] as AnyObject as! String == "Y" {
                        cell.answerSwitch.isOn = true
                        
                    } else {
                        cell.answerSwitch.isOn = false
                    }
                    for values in self.addValuesArray {
                        let vals = values as! Dictionary<String, AnyObject>
                    
                            if questionValues.index(forKey: "Y") != nil {
                                if vals.index(forKey: "answer") != nil {
                                cell.answerTextView.text = vals["answer"] as AnyObject as! String
                                }
                            }
                        
                    }
                //cell.answerTextView.text =
            }
            if cell.answerTextView.text.isEmpty {
                cell.placeholderLabel.isHidden = false
            } else {
                cell.placeholderLabel.isHidden = true
                
            }

            if questionValues.index(forKey: "Y") != nil {
                for obj in questionValues["Y"] as! NSMutableArray {
                    var objDict = obj as! Dictionary<String, AnyObject>
                    subQuestion = objDict["question"] as AnyObject as! String
                    cell.subQuestionLabel.text = subQuestion
                    
                }
                
            }
            
          return cell
        } else if type == "CheckBox" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell", for: indexPath) as! CheckBoxTableViewCell;
            cell.checkBxDelegate = self
            cell.myIndexPath = indexPath;
            cell.cellIndexPath = indexPath.row;
            cell.answerTextView.text = ""
            cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);

            let val = self.section0[indexPath.row]
            if val is String {
                cell.checkBoxQuestionLabel.text = val as AnyObject as? String
            for values in self.addValuesArray {
                if values as AnyObject as! String == val as! String {
                    cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
                }
                }
            } else if val is Dictionary<String, AnyObject> {
                for values in self.section0 {
                    let vals = values as! Dictionary<String, AnyObject>
                    if self.addValuesArray.count > 0 {
                    if vals["name"] as AnyObject as! String == val as! String {
                        cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
                        if questionValues.index(forKey: "Y") != nil {
                            let ansVal = questionValues["value"]
                            cell.answerTextView.text = ansVal!["answer"] as AnyObject as! String
                        }
                    }
                }
            }
            
            
            
            if cell.answerTextView.text.isEmpty {
                cell.placeholderLabel.isHidden = false
            } else {
                cell.placeholderLabel.isHidden = true
                
            }
            
            if questionValues.index(forKey: "Y") != nil {
                for obj in questionValues["Y"] as! NSMutableArray {
                    var objDict = obj as! Dictionary<String, AnyObject>
                    subQuestion = objDict["question"] as AnyObject as! String
                    cell.subQuestionLabel.text = subQuestion

                }
                
            }
            cell.setNeedsLayout()

            
            
            return cell
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! QuestionsTableCell;
//        cell.cellDelegate = self
//        cell.checkBoxView.isHidden = true
//        cell.textAreaView.isHidden = true
//        cell.switchView.isHidden = true
//        cell.subQuestionView.isHidden = true
//        cell.myIndexPath = indexPath;
//        cell.cellIndexPath = indexPath.row;
//        cell.subViewHeightConstraint.constant = 0
//
//            if type == "EditText" || type == "TextArea" {
//                cell.textAreaTextViewHeightConstraint.constant = 87
//
//                cell.textAreaTextView.text = ""
//
//                if questionValues.index(forKey: "answer") != nil {
//                    cell.textAreaTextView.text = questionValues["answer"] as AnyObject as! String
//
//                } else {
//                    if question.contains("AGE") {
//                        cell.textAreaTextViewHeightConstraint.constant = 120
//                        heightConstraint = 40
//
//                    cell.textAreaTextView.text = self.age
//                    } else if question.contains("GENDER") {
//                        cell.textAreaTextViewHeightConstraint.constant = 120
//                        heightConstraint = 40
//
//                        if self.sex == "M" {
//                        cell.textAreaTextView.text = "Male"
//                        } else {
//                            cell.textAreaTextView.text = "Female"
//                        }
//                    } else if question.contains("HEIGHT") {
//                        cell.textAreaTextViewHeightConstraint.constant = 120
//                        heightConstraint = 40
//
//                        cell.textAreaTextView.text = self.height
//                    } else if question.contains("WEIGHT") {
//                        cell.textAreaTextViewHeightConstraint.constant = 120
//                        heightConstraint = 40
//
//                        cell.textAreaTextView.text = self.weight
//                    }
//                }
//                if cell.textAreaTextView.text.isEmpty {
//                    cell.placeholderLabel.isHidden = false
//                } else {
//                    cell.placeholderLabel.isHidden = true
//
//                }
//                cell.textAreaView.isHidden = false
//                cell.setNeedsLayout()
//            cell.textAreaTextView.textAlignment = .center
//                answer = cell.textAreaTextView.text
//                questionValues["answer"] = answer as AnyObject
//
//
//
//            }
//            if questionValues.index(forKey: "condition") != nil {
//            condition = questionValues["condition"] as AnyObject as! String
//            if condition == "alphanumeric" {
//                cell.textAreaTextView.keyboardType = UIKeyboardType.default
//            } else if condition == "number" {
//                cell.textAreaTextView.keyboardType = UIKeyboardType.numberPad
//            } else if  condition == "picker" {
//                let pickerView = UIPickerView()
//                pickerView.delegate = self
//                cell.textAreaTextView.inputView = pickerView
//                if question.contains("HEIGHT") {
//                    whichPicker = "HEIGHT"
//                } else if question.contains("GENDER") {
//                    whichPicker = "GENDER"
//                }
//            } else if condition == "decimal" {
//                cell.textAreaTextView.inputView = nil
//                cell.textAreaTextView.keyboardType = UIKeyboardType.decimalPad
//            }
//            } else {
//                cell.textAreaTextView.keyboardType = UIKeyboardType.default
//
//            }
//        if type == "switch" {
//            //cell.subViewTopConstraint.constant = 122
//            cell.switchView.isHidden = false
//            cell.answerSwitch.isOn = false
//            if questionValues.index(forKey: "answer") != nil {
//                if questionValues["answer"] as AnyObject as! String == "Y" {
//                    cell.answerSwitch.isOn = true
//                    questionValues["answer"] = answer as AnyObject
//
//                } else {
//                    cell.answerSwitch.isOn = false
//                    questionValues["answer"] = answer as AnyObject
//                }
//            }
//        }
//
//            if type == "CheckBox" {
//                //cell.subViewTopConstraint.constant = 122
//                cell.checkBoxView.isHidden = false
//                let cellDict = self.section0[indexPath.row] as! Dictionary<String, AnyObject>
//                cell.checkBoxQuestionLabel.text = cellDict["name"] as AnyObject as? String
//                cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
//                    if self.addValuesArray.contains((cellDict["name"] as AnyObject as? String)!) {
//                        //checked_box.png
//                        cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
//
//                }
//            }
//
//           if subQuestion != "" {
//            if indexPath.row == self.myIndexPath.row {
////cell.subTextView.text = ""
//            //cell.subViewTopConstraint.constant = 0
//                cell.subQuestionView.isHidden = false
//            cell.subViewHeightConstraint.constant = 142
//            cell.subQuestion.text = subQuestion
//            cell.subQuestionView.backgroundColor = UIColor.groupTableViewBackground
//            } else {
//            }
//        } else {
//           //cell.subViewTopConstraint.constant = 122
//            cell.subQuestionView.isHidden = true
//            cell.subViewHeightConstraint.constant = 0
//
//
//
//        }
//        cell.setNeedsLayout()
        return myCell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 54))
            
            let titleLbl = UILabel(frame: CGRect(x: 0 , y: 0, width: tableView.frame.size.width, height: 54))
            
            titleLbl.numberOfLines = 0
            titleLbl.text = "  " + question
            titleLbl.font = UIFont(name: "Trebuchet MS", size: 14.0)
            titleLbl.textColor = UIColor.darkGray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(titleLbl)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (hint != "")  {
            let view = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: 54))
            
            let titleLbl = UILabel(frame: CGRect(x: 0 , y: 0, width: tableView.frame.size.width, height: 54))
            
            titleLbl.numberOfLines = 0
            titleLbl.text = "Hint: " + hint
            titleLbl.font = UIFont(name: "Trebuchet MS", size: 14.0)
            titleLbl.textColor = UIColor.darkGray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(titleLbl)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if hint != "" {
        return 54
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if type == "TextArea" {
            return 90
         } else if type == "EditText" || type == "RadioButton" {
            return 40
         } else if type == "CheckBox" && questionValues.index(forKey: "Y") != nil  {
           
              return 50 + 142
            
         } else if type == "CheckBox" && questionValues.index(forKey: "Y") == nil {
            return 50
            
         }else if type == "switch" && questionValues.index(forKey: "Y") != nil  {
                return 46 + 142
            
         } else if type == "switch" && questionValues.index(forKey: "Y") == nil {
                return 46
            
            
        }
        return 0
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        if indexPath.row == self.myArray.count - 1 {
////            if type == "EditText" {
////                return CGFloat(heightConstraint)
////
////            }
////          return 177
////
////        } else {
////            return CGFloat(heightConstraint)
////        }
////        if indexPath.row == self.section0.count - 1 && (type == "CheckBox" || type == "CheckBox") {
////            return CGFloat(heightConstraint) + 177
////        }
//        if subQuestion != "" {
//            if indexPath.row == self.myIndexPath.row {
//            return CGFloat(heightConstraint) + 177
//            }
//        } else {
//            return 50
//        }
//        return CGFloat(heightConstraint)
//
//    }

    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var nextButtonBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    var questionairreReference : DatabaseReference!
    
    var questionsArray = NSMutableArray()
    var questionsArray1 = NSMutableArray()

    var packageIDArray = NSMutableArray()
    var answersArray = NSMutableArray()
    var section0 = NSMutableArray()
    var section1 = NSMutableArray()
    var subQuestion = ""
    let textEditBottomConstant: CGFloat = 18.0
    var num: Int = 0
    var den: Int = 0
    var questionValues = Dictionary<String, AnyObject>()
    var condition = ""
    var type = ""
    var question = ""
    var cellIndexPath: Int = 0
    var myIndexPath: IndexPath!
    var cellTVIndexPath: Int = 0
    var myTVIndexPath: IndexPath!
    var hint = ""
    var questionKey = ""
    var myProfileInfo : Results<MyProfileInfo>?
    var weight : String = ""
    var sex : String = ""
    var height : String = ""
    var age : String = ""
    
    let realm :Realm = try! Realm()
    var placeholderLabel : UILabel!
    var packageID = ""
    var questionDict =  Dictionary<String, AnyObject>()
    var answer = ""
    var fromSegue = ""



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self)
        for myProfObj in self.myProfileInfo! {
            self.age = myProfObj.age
            self.sex = myProfObj.gender
            self.weight = myProfObj.weight
            self.height = myProfObj.height
            
        }
        self.questionairreReference = Database.database().reference().child("PremiumPackageQuestions")
        MBProgressHUD.showAdded(to: self.view, animated: true);
        if self.fromSegue == "InstaMojo" {
            self.getQuestionsFromFB()
        } else {
            self.getQuestionsFromFB1()
        }

    }
    func getQuestionsFromFB1() {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.packageID).child("answers").observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    
                    for questions in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let questionsObj = questions.value as! Dictionary<String,AnyObject>
                        self.questionsArray1.add(questionsObj)
                        
                    }
                    dispatch_group.leave()
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        // print(self.questionsArray)
                        self.showQuestions()

                    }
                } else {
                    self.getQuestionsFromFB()
                }
            })
        }
    }
    
    // fetch questions from Firebase
    
    func resetAllViews() {
        //self.textAreaView.isHidden = true
    }
    
    func getQuestionsFromFB() {
        self.questionairreReference.child(self.packageID).child("questions").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for questions in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let questionsObj = questions.value as! Dictionary<String,AnyObject>
                    self.questionsArray.add([questions.key: questionsObj])
                    
                    
                }
                print(self.questionsArray)
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    // print(self.questionsArray)

                    self.showQuestions()
                    
                }
            }
        })
    }
    
    
    
    func showQuestions() {
        
        
        
        section0 = [1]
        self.num = self.num + 1
        if self.questionsArray.count > 0 {
        self.den = self.questionsArray.count
    } else {
        self.den = self.questionsArray1.count
    }
        let total = (self.num / self.den)
        print(total)
        print(Float(total))
        self.progressBar.setProgress(Float(Float(self.num)/Float(self.den)), animated: true)
        if self.num == self.den {
            self.submitButton.setTitle("FINISH", for: .normal)
        }
        if self.num > self.den {
          
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child((Auth.auth().currentUser?.uid)!).child("packages").observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    
                    for pkgs in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let pkgID = pkgs.value as AnyObject
                        if pkgID as! String != self.packageID {
                            self.packageIDArray.add(pkgID)
                            
                        }
                        
                    }
                    dispatch_group.leave()
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        // print(self.questionsArray)
                        
                    }
                }
            })
            if let currentUserID = Auth.auth().currentUser?.uid {
                Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.packageID).child("answers").setValue(self.answersArray, withCompletionBlock: { (error, _) in
                    if error == nil {
                        for pkgID in self.packageIDArray {
                            if pkgID as! String == self.packageID {
                                self.packageIDArray.remove(self.packageID)
                            }
                        }
                        self.packageIDArray.add(self.packageID)
                        let currentDate = Date();
                        let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: currentDate as NSDate);
                        let currentTime = Int64(currentTimeStamp);
                        var pkgsArray = [ "lastUpdatedOn": currentTime!, "name": self.myProfileInfo?.first?.name as Any, "unread": false] as [String : Any]
                        pkgsArray["packages"] = self.packageIDArray
                        
                        Database.database().reference().child("NutritionistPremiumPackages").child(UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String).child(currentUserID).setValue(pkgsArray, withCompletionBlock: { (error, _) in
                            if error == nil {
                                if self.fromSegue == "InstaMojo" {
                                let nickName = UserDefaults.standard.value(forKey: "NutritionistFirstName") as! String
                                let signature =  UserDefaults.standard.value(forKey: "NutritionistSignature") as! String
                                
                                let msg = signature.html2String
                                
                                let refreshAlert = UIAlertController(title: "", message: "Our world class senior nutritionist " + "(" + msg + ")" + " has been assigned to you. Wow! Congratulations!" , preferredStyle: UIAlertControllerStyle.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    print("Handle Ok logic here")
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DISMISS_QUESTIONS"), object: nil)
                                    self.dismiss(animated: true, completion: {})
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                                
                            } else {
                                self.navigationController?.popViewController(animated: true)
                                    return

                                }
                            } else {
                            }
                        })
                        
                        
                    } else {
                    }
                })
            }

            return
        }
        if self.questionsArray.count > 0 {
        questionDict = self.questionsArray[self.num - 1] as! Dictionary<String, AnyObject>
        } else if self.questionsArray1.count > 0 {
            print(self.questionsArray1)
            questionDict = self.questionsArray1[self.num - 1] as! Dictionary<String, AnyObject>

        }
        print(questionDict)
        questionKey = ""
        questionValues = [String : AnyObject]()
        question = ""
        type = ""
        hint = ""
        subQuestion = ""
        self.addValuesArray = NSMutableArray()
        for key in self.questionDict.keys {
            questionKey = key
        }
        if self.questionsArray.count > 0 {
        for value in self.questionDict.values {
            questionValues = value as! [String : AnyObject]
        }
        } else {
            questionValues = self.questionDict
        }
        print(questionValues)

        question = questionValues["question"] as AnyObject as! String
        type = questionValues["type"] as AnyObject as! String
        if questionValues.index(forKey: "hint") != nil {
            hint = questionValues["hint"] as AnyObject as! String
        }
        if type == "CheckBox" {
            if questionValues.index(forKey: "value") != nil {
                let valuesArray = questionValues["value"] as AnyObject as! NSMutableArray
                let valArray = NSMutableArray()
                for values in valuesArray {
                    let valDict = values as AnyObject as! Dictionary<String, AnyObject>
                    if questionValues.index(forKey: "Y") != nil {
                    valArray.add(valDict)
                    } else {
                        valArray.add(valDict["name"] as AnyObject as! String)

                    }
                    
                }
                self.section0 = valArray
                //self.addValuesArray = valuesArray
//
//                if (questionValues["answer"]?.contains(","))! {
//                    let answers = questionValues["answer"] as AnyObject as! String
//                    let addValArray = answers.components(separatedBy: ",")
//                    self.addValuesArray = NSMutableArray(array: addValArray)
//                } else {
//                    self.addValuesArray.add(addValuesArray)
//                }
//                self.section0 = self.addValuesArray
//
//
//            } else {
//                if questionValues.index(forKey: "value") != nil {
//
//                }
            }
        } else if type == "switch" {
            if questionValues.index(forKey: "value") != nil {
                let valuesArray = questionValues["value"] as AnyObject as! NSMutableArray
                let valArray = NSMutableArray()
                for values in valuesArray {
                    let valDict = values as AnyObject as! Dictionary<String, AnyObject>
                    valArray.add(valDict["name"] as AnyObject as! String)
                    
                }
                //self.section0 = valArray
                self.addValuesArray = valuesArray
             
            }
        }
        self.questionsTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
        

    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submitButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if type == "EditText" || type == "TextArea" || type == "RadioButton" {
            questionValues["answer"] = answer as AnyObject
            questionValues["answered"] = true as AnyObject
            questionValues["qid"] = self.questionKey as AnyObject
            self.answersArray.add(questionValues)

        } else if type == "CheckBox" {
            if self.addValuesArray.count > 1 {
                let answer = self.addValuesArray.componentsJoined(by: ",")
                questionValues["answer"] = answer as AnyObject
                questionValues["answered"] = true as AnyObject
                questionValues["qid"] = self.questionKey as AnyObject

                self.answersArray.add(questionValues)
            } else if self.addValuesArray.count == 1 {
                questionValues["answer"] = self.addValuesArray[0] as AnyObject
                questionValues["answered"] = true as AnyObject
                questionValues["qid"] = self.questionKey as AnyObject
                self.answersArray.add(questionValues)
            } else if self.addValuesArray.count == 0 {
                questionValues["answer"] = "" as AnyObject
                questionValues["answered"] = false as AnyObject
                questionValues["qid"] = self.questionKey as AnyObject
                self.answersArray.add(questionValues)

            }
        } else if type == "switch"  {
            if answer == "Y" {
                questionValues["answer"] = answer as AnyObject
                questionValues["answered"] = true as AnyObject
                questionValues["qid"] = self.questionKey as AnyObject

            } else {
                questionValues["answer"] = answer as AnyObject
                questionValues["answered"] = false as AnyObject
                questionValues["qid"] = self.questionKey as AnyObject

            }
            self.answersArray.add(questionValues)

        }
        print("answersArray: \(self.answersArray)")
        self.showQuestions()
        
    }
}
