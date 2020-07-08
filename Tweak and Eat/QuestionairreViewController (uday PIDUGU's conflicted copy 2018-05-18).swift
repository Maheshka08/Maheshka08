//
//  QuestionairreViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 30/04/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift

class QuestionairreViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, SwitchChangeDelegate, CheckBoxDelegate, TextAreaDelegate {
    func cellTappedOnAnswerTV(_ cell: QuestionairreTextAreaCell) {
        self.cellTVIndexPath = cell.cellIndexPath
        self.myTVIndexPath = cell.myIndexPath
        print(self.myTVIndexPath)
        if questionDict.index(forKey: "Y") != nil {
          var tempArray = questionDict["Y"] as! NSMutableArray
        var tempDict = tempArray[self.cellTVIndexPath] as! Dictionary<String, AnyObject>
        tempDict["answer"] = cell.answerTextView.text! as AnyObject
            if cell.answerTextView.text! == "" {
                tempDict["answered"] = false as AnyObject

            } else {
                tempDict["answered"] = true as AnyObject
            }
        tempArray.removeObject(at: self.cellTVIndexPath)
        tempArray.insert(tempDict, at: self.cellTVIndexPath)

        questionDict["Y"] = tempArray

        print(questionDict)
        }
    }
    
    
    func cellTappedOnCheckBox(_ cell: QuestionairreCheckBoxCell) {
        let cellDict = self.section0[cell.cellIndexPath] as! Dictionary<String, AnyObject>
        if cell.checkBoxButton.imageView?.image == UIImage.init(named: "check_box.png") {
            cell.checkBoxButton.setImage(UIImage.init(named: "checked_box.png"), for: .normal);
            self.addValuesArray.add(cellDict["name"] as AnyObject as! String)
            print(self.addValuesArray)
            self.selection = "Y"
            
        } else {
            cell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
           // if self.addValuesArray.count > cell.cellIndexPath {
           // self.addValuesArray.removeObject(at: cell.cellIndexPath)
            self.addValuesArray.remove(cellDict["name"] as AnyObject as! String)
            self.selection = "N"
           // }
            print(self.addValuesArray)
        }
        if self.addValuesArray.count == 0 {
            self.section1 = NSMutableArray()
            self.multipleQuestionsTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
        } else {
            self.section1 = self.localQuestionsArray
            self.multipleQuestionsTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
        }
        if self.addValuesArray.count > 0 {
            let values = self.addValuesArray.componentsJoined(by: ",")

        questionDict["answered"] = true as AnyObject
        questionDict["answer"] = values as AnyObject

        } else {
            questionDict["answered"] = false as AnyObject
            questionDict["answer"] = "" as AnyObject

        }
    }
    
    func cellTappedOnSwitch(_ cell: QuestionairreSwitchCell) {
        if cell.selectSwitch.isOn {
         
            self.selection = "Y"
            self.section1 = self.localQuestionsArray
            self.multipleQuestionsTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)

        } else {
           
            self.selection = "N"
            self.section1 = NSMutableArray()
            self.multipleQuestionsTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)

        }
       
    }
    func setDefaultArrayValues() {
        self.section0 = NSMutableArray()
        self.section1 = NSMutableArray()
        self.localQuestionsArray = NSMutableArray()
        self.addValuesArray = NSMutableArray()
        self.selection = "N"

        self.multipleQuestionsTableView.reloadData()
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        if indexPath.section == 1 {
            return 123
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.section0.count
//            if self.section0.count > 0 {
//                return self.section0.count
//
//            }
        }
        if section == 1 && section1.count > 0 {
            return self.section1.count
//            if self.section1.count > 0 {
//                return self.section1.count
//            } else {
//                return 0
//            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var checkBoxCell: QuestionairreCheckBoxCell
        var switchCell: QuestionairreSwitchCell
        var textAreaCell: QuestionairreTextAreaCell
        var cell = UITableViewCell();

        if indexPath.section == 0 {
            if self.questionType == "CheckBox" {
                
            
            checkBoxCell = tableView.dequeueReusableCell(withIdentifier: "QuestionairreCheckBoxCell" , for: indexPath) as! QuestionairreCheckBoxCell;
                // checkBoxCell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
                let cellDict = self.section0[indexPath.row] as! Dictionary<String, AnyObject>
                checkBoxCell.myIndexPath = indexPath;
                checkBoxCell.cellIndexPath = indexPath.row;

                checkBoxCell.checkBxDelegate = self
                if self.selection == "N" {
                 checkBoxCell.checkBoxButton.setImage(UIImage.init(named: "check_box.png"), for: .normal);
                    
                }
                checkBoxCell.questionLabel.text = cellDict["name"] as AnyObject as? String
            
            return checkBoxCell
            } else if self.questionType == "switch" {
                switchCell = tableView.dequeueReusableCell(withIdentifier: "QuestionairreSwitchCell" , for: indexPath) as! QuestionairreSwitchCell;
               switchCell.switchDelegate = self
                return switchCell
            }
            
        }
        
        if indexPath.section == 1 {
            textAreaCell = tableView.dequeueReusableCell(withIdentifier: "QuestionairreTextAreaCell" , for: indexPath) as! QuestionairreTextAreaCell;
            textAreaCell.cellDelegate = self
            textAreaCell.cellIndexPath = indexPath.row
            textAreaCell.myIndexPath = indexPath
            let cellDict = self.section1[indexPath.row] as! Dictionary<String, AnyObject>
            textAreaCell.questionLabel.text = cellDict["question"] as AnyObject as? String
            textAreaCell.answerTextView.text = ""
            return textAreaCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? QuestionairreTextAreaCell {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section == 0 {
                return self.question
            }
       return ""
    }
    
    @IBOutlet weak var multipleQuestionsTableView: UITableView!
    @IBOutlet weak var multipleQuestionsView: UIView!
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textEditView: UIView!


    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    var addValuesArray = NSMutableArray()
    var questionType = ""
    var selection = "N"
    var questionsArray = NSMutableArray()
    var section0 = NSMutableArray()
    var section1 = NSMutableArray()
    let textEditBottomConstant: CGFloat = 18.0
    var num: Int = 0
    var den: Int = 0
    var cellIndexPath: Int = 0
    var myIndexPath: IndexPath!
    var cellTVIndexPath: Int = 0
    var myTVIndexPath: IndexPath!
    var myProfileInfo : Results<MyProfileInfo>?
    var weight : String = ""
    var sex : String = ""
    var height : String = ""
    var age : String = ""
    let realm :Realm = try! Realm()
    var placeholderLabel : UILabel!
    var question = ""
    var localQuestionsArray = NSMutableArray()
    var questionDict =  Dictionary<String, AnyObject>()
    
    @IBOutlet weak var textEditTVBottomConstraint: NSLayoutConstraint!
    
    var questionairreReference : DatabaseReference!

    @IBAction func skipButtonTapped(_ sender: Any) {
        //self.questionsView.isHidden = true
        //self.multipleQuestionsTableView.deleteSections(NSIndexSet(index: 1) as IndexSet, with: .none)
        if self.questionsArray.count > 0 {
            if let currentUserID = Auth.auth().currentUser?.uid {
                Database.database().reference().child("UserPremiumPackages").child(currentUserID).child("-KyotHu4rPoL3YOsVxUu").child("questions").setValue(self.questionsArray, withCompletionBlock: { (error, _) in
                    if error == nil {
                        
                        Database.database().reference().child("NutritionistPremiumPackages").child("").child(currentUserID).observe(DataEventType.value, with: { (snapshot) in
                            if snapshot.childrenCount > 0 {
                                let dispatch_group = DispatchGroup()
                                dispatch_group.enter()
                                
                                for questions in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    let questionsObj = questions.value as! Dictionary<String,AnyObject>
                                    self.questionsArray.add(questionsObj)
                                    
                                }
                                dispatch_group.leave()
                                dispatch_group.notify(queue: DispatchQueue.main) {
                                    MBProgressHUD.hide(for: self.view, animated: true);
                                    self.questionsView.isHidden = false
                                    // print(self.questionsArray)
                                    self.showQuestionView()
                                    
                                }
                            }
                        })
                        Database.database().reference().child("NutritionistPremiumPackages").child("").childByAutoId().child(currentUserID).setValue(self.questionsArray, withCompletionBlock: { (error, _) in
                            if error == nil {
                                
                                
                                self.questionsView.isHidden = true
                                self.dismiss(animated: true, completion: {})
                                
                                
                                
                                
                            } else {
                            }
                        })
                        
                        
                        
                    } else {
                    }
                })
            }
        } else {
            self.questionsView.isHidden = true
            self.dismiss(animated: true, completion: {})


        }
        
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if questionDict["type"] as AnyObject as? String == "EditText" || questionDict["type"] as AnyObject as? String == "TextView" || questionDict["type"] as AnyObject as? String == "TextArea" {
            if self.answerTextView.text! == "" {
                questionDict["answered"] = false as AnyObject
                
            } else {
                questionDict["answered"] = true as AnyObject
            }
            questionDict["answer"] = self.answerTextView.text! as AnyObject

        } else {
        
        if self.selection == "Y" {
            questionDict["answered"] = true as AnyObject
            questionDict["answer"] = self.selection as AnyObject

        } else {
            if questionDict.index(forKey: "Y") != nil {
               // questionDict["Y"] = tempArray
                var tempArray = NSMutableArray()
                for obj in questionDict["Y"] as! NSMutableArray {
                    var objDict = obj as! Dictionary<String, AnyObject>
                    if objDict.index(forKey: "answer") != nil {
                    objDict.removeValue(forKey: "answer")
                    }
                    if objDict.index(forKey: "answered") != nil {
                    objDict.removeValue(forKey: "answered")
                    }
                    tempArray.add(objDict)
                }
                questionDict["Y"] = NSMutableArray()
                questionDict["Y"] = tempArray
                if questionDict.index(forKey: "answered") != nil {
                questionDict.removeValue(forKey: "answered")
                }
            }
            }
        
        }
        self.questionsArray.removeObject(at: self.num - 1)
        self.questionsArray.insert(questionDict, at: self.num - 1)
        //self.questionsArray.add(questionDict)
        print(self.questionsArray)


        self.setDefaultArrayValues()
        self.hideAllViews()
        //self.showQuestionsCount()
        self.showQuestionView()
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textEditView.isHidden = true
        self.multipleQuestionsView.isHidden = true

        // Do any additional setup after loading the view.
        self.multipleQuestionsTableView.register(UINib.init(nibName: "QuestionairreCheckBoxCell", bundle: nil), forCellReuseIdentifier: "QuestionairreCheckBoxCell");
        self.multipleQuestionsTableView.register(UINib.init(nibName: "QuestionairreTextAreaCell", bundle: nil), forCellReuseIdentifier: "QuestionairreTextAreaCell");
        self.multipleQuestionsTableView.register(UINib.init(nibName: "QuestionairreSwitchCell", bundle: nil), forCellReuseIdentifier: "QuestionairreSwitchCell");
        
        self.answerTextView.layer.cornerRadius = 10.0
        self.answerTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Please write about few words..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.answerTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        self.answerTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.answerTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.answerTextView.text.isEmpty
        
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self)
        for myProfObj in self.myProfileInfo! {
            self.age = myProfObj.age
            self.sex = myProfObj.gender
            self.weight = myProfObj.weight
            self.height = myProfObj.height
            
        }
        self.questionsView.isHidden = true
        self.questionairreReference = Database.database().reference().child("PremiumQuestions")
        MBProgressHUD.showAdded(to: self.view, animated: true);
        self.getQuestionsFromFB()

    }
    // textview delegate methods
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if placeholderLabel.isHidden == true {
            self.disableOrEnableSubmitButton(enabled: true, colour: .white)
        } else {
            self.disableOrEnableSubmitButton(enabled: false, colour: .lightGray)
        }
    }
    
    func showQuestionsCount() {
        self.num = self.num + 1
        self.den = self.questionsArray.count
        self.questionsCountLabel.text = "\(self.num)" + "/" + "\(self.den)"
        if self.num == self.den {
            self.submitButton.setTitle("FINISH", for: .normal)
        }
//        if self.num > self.den {
//            return
//        }
    }
    
//    func createQuestionsAndAnswersDictionary(index: Int, questionDictionary: Dictionary<String, AnyObject>) {
//        let dict = ["\(index)": questionDictionary]
//    }
    
    func disableOrEnableSubmitButton(enabled: Bool, colour: UIColor) {
        self.submitButton.isEnabled = enabled
        self.submitButton.setTitleColor(colour, for: .normal)
    }
    
    func showQuestionView() {
        
        if self.questionsArray.count > 0 {
            self.showQuestionsCount()
            if self.num > self.den {
                if let currentUserID = Auth.auth().currentUser?.uid {
                    Database.database().reference().child("UserPremiumPackages").child(currentUserID).child("-KyotHu4rPoL3YOsVxUu").child("questions").setValue(self.questionsArray, withCompletionBlock: { (error, _) in
                    if error == nil {
                       // need to push data in NutritionistsPremiumPackage
                        
                        self.questionsView.isHidden = true
                        self.dismiss(animated: true, completion: {})

                       
                        
                        
                    } else {
                    }
                })
                }
                return
            }
             questionDict = self.questionsArray[self.num - 1] as! Dictionary<String, AnyObject>
            print(questionDict)
            self.questionLabel.text = questionDict["question"] as AnyObject as? String
            // differentiate type
            if questionDict["type"] as AnyObject as? String == "EditText" || questionDict["type"] as AnyObject as? String == "TextView" {
                placeholderLabel.isHidden = true
                self.textEditView.isHidden = false
                self.answerTextView.text = ""
                if questionDict["condition"] as AnyObject as? String == "alphanumeric" {
                    self.answerTextView.keyboardType = UIKeyboardType.default
                } else if questionDict["condition"] as AnyObject as? String == "number" {
                    self.answerTextView.keyboardType = UIKeyboardType.numberPad
                }
                if questionDict["question"] as AnyObject as? String == "AGE" || questionDict["question"] as AnyObject as? String == "WEIGHT" || questionDict["question"] as AnyObject as? String == "HEIGHT" || questionDict["question"] as AnyObject as? String == "GENDER" {
                    self.textEditTVBottomConstraint.constant = 120
                    
                    self.answerTextView.textAlignment = .center
                    if questionDict["question"] as AnyObject as? String == "HEIGHT" || questionDict["question"] as AnyObject as? String == "GENDER" {
                        self.answerTextView.backgroundColor = UIColor.lightGray
                        self.answerTextView.isUserInteractionEnabled = false
                        if questionDict["question"] as AnyObject as? String == "HEIGHT" {
                            self.answerTextView.text = self.height
                        } else if questionDict["question"] as AnyObject as? String == "GENDER" {
                            self.answerTextView.text = self.sex
                        }
                        
                    } else {
                        if questionDict["question"] as AnyObject as? String == "WEIGHT" {
                            self.answerTextView.text = self.weight
                        } else if questionDict["question"] as AnyObject as? String == "AGE" {
                            self.answerTextView.text = self.age
                        }
                        self.answerTextView.backgroundColor = UIColor.white
                        self.answerTextView.isUserInteractionEnabled = true
                    }
                    
                } else {
                    placeholderLabel.isHidden = false
                    self.answerTextView.text = ""
                    self.textEditTVBottomConstraint.constant = self.textEditBottomConstant
                    self.answerTextView.textAlignment = .left
                    self.answerTextView.isUserInteractionEnabled = true
                    
                }
            } else if questionDict["type"] as AnyObject as? String == "TextArea" {
                placeholderLabel.isHidden = false
                self.textEditView.isHidden = false

                self.answerTextView.keyboardType = UIKeyboardType.default
                self.textEditTVBottomConstraint.constant = self.textEditBottomConstant
                self.answerTextView.textAlignment = .left
                self.questionLabel.text = questionDict["question"] as AnyObject as? String
                self.answerTextView.text = ""
                self.answerTextView.backgroundColor = UIColor.white
                self.answerTextView.isUserInteractionEnabled = true
                
            } else if questionDict["type"] as AnyObject as? String == "CheckBox" {
                self.view.endEditing(true)

                self.questionType = (questionDict["type"] as AnyObject as? String)!
                self.question = (questionDict["question"] as AnyObject as? String)!
                print(questionDict)
                let val = questionDict["value"] as AnyObject as! NSMutableArray
                self.section0 = val
                if questionDict.index(forKey: "Y") == nil {
                   // print("the key 'Y' is NOT in the dictionary")
                    self.localQuestionsArray = NSMutableArray()
                } else {
                self.localQuestionsArray = questionDict["Y"] as AnyObject as! NSMutableArray
                }
                self.multipleQuestionsView.isHidden = false
                self.multipleQuestionsTableView.delegate = self
                self.multipleQuestionsTableView.dataSource = self
                self.multipleQuestionsTableView.reloadData()
            } else if questionDict["type"] as AnyObject as? String == "switch" {
                self.view.endEditing(true)

                self.questionType = (questionDict["type"] as AnyObject as? String)!
                self.question = (questionDict["question"] as AnyObject as? String)!
                self.section0 = ["1"]
                if questionDict.index(forKey: "Y") == nil {
                    // print("the key 'Y' is NOT in the dictionary")
                    self.localQuestionsArray = NSMutableArray()
                } else {
                    self.localQuestionsArray = questionDict["Y"] as AnyObject as! NSMutableArray
                }
                print(questionDict)
                self.multipleQuestionsView.isHidden = false
                self.multipleQuestionsTableView.delegate = self
                self.multipleQuestionsTableView.dataSource = self
                self.multipleQuestionsTableView.reloadData()
            }
        }
//        if placeholderLabel.isHidden == true {
//            self.disableOrEnableSubmitButton(enabled: true, colour: .white)
//        } else {
//            self.disableOrEnableSubmitButton(enabled: false, colour: .lightGray)
//        }
    }
    
    func getQuestionsFromFB() {
        self.questionairreReference.child("-KyotHu4rPoL3YOsVxUu").child("questions").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for questions in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let questionsObj = questions.value as! Dictionary<String,AnyObject>
                    self.questionsArray.add(questionsObj)

                }
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.questionsView.isHidden = false
                  // print(self.questionsArray)
                    self.showQuestionView()

                }
            }
})
    }
    
    func hideAllViews() {
        if self.textEditView.isHidden == false {
            self.textEditView.isHidden = true
        }
        if self.multipleQuestionsView.isHidden == false {
            self.multipleQuestionsView.isHidden = true
        }
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

}
