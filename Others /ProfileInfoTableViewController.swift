//
//  ProfileInfoTableViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 10/30/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Firebase

class ProfileInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var headerLbl: UILabel!;
    var myProfile : Results<MyProfileInfo>?;
    @objc var packageID = "";
    @objc var questionsArray = NSMutableArray();

    @objc var allergiesArray = [[String : AnyObject]]();
    @objc var foodHabitsArray = [[String : AnyObject]]();
    @objc var conditionsArray = [[String : AnyObject]]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.getQuestionsFromFB1();
    }
    
    @objc func getQuestionsFromFB1() {
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("UserPremiumPackages").child(currentUserID).child(self.packageID).child("answers").observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    let dispatch_group = DispatchGroup();
                    dispatch_group.enter();
                    
                    for questions in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let questionsObj = questions.value as! Dictionary<String,AnyObject>;
                        self.questionsArray.add(questionsObj);
                        
                    }
                    print(self.questionsArray);
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.tableView.reloadData();

                    }
                }
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.questionsArray.count > 0 {
            return self.questionsArray.count;
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.questionsArray.count > 0 {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ProfileInfoTableViewCell;
        if self.questionsArray.count > 0 {

            let cellDict  = self.questionsArray[indexPath.section] as! [String : AnyObject];
            cell.answerLbl.text = cellDict["answer"] as? String;
        }
        return cell
    }
    
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if self.questionsArray.count > 0 {

        let cellDict  = self.questionsArray[section] as! [String : AnyObject];
        return cellDict["question"] as? String;
    }
    return ""
    }
}
