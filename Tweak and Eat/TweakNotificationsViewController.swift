//
//  TweakNotificationsViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 11/1/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TweakNotificationsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource{

    var tweakNotifyRef : DatabaseReference!
    var notifyObj : [String : AnyObject]?
    @IBOutlet weak var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tweakNotifyRef = Database.database().reference().child("TweakNotifications")
         tweakNotifyRef.observe(DataEventType.value, with: { (snapshot) in
            self.notifyObj = snapshot.value as? [String : AnyObject]
            print(self.notifyObj)
            // ...
        })
//        tweakNotifyRef.observe(DataEventType.childAdded, with: { (snapshot) in
//            self.notifyObj = snapshot.value as? [String : AnyObject]
//
//        })
        // Do any additional setup after loading the view.
       
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TweakNotifyTableViewCell
      

        tweakNotifyRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for tweakNotifications in snapshot.children.allObjects as! [DataSnapshot] {
                 
                    let notifyObj = tweakNotifications.value as? [String : AnyObject]
                    //String(self.dict["totalTrips"]!)
                    cell.notificationDate.text = notifyObj!["dateTime"]! as? String
                   // cell.notificationDate = notifyObj?["dateTime"] as! UILabel
                }
            }
        })
        return cell
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
