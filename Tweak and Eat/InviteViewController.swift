//
//  InviteViewController.swift
//  Tweak and Eat
//
//  Created by admin on 21/11/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import CoreData


class InviteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , UISearchResultsUpdating{
    
    @IBOutlet weak var contactsTable: UITableView!;
    var searchActive:Bool = false;
    let rc = UIRefreshControl();
    var arrIndexSection : NSMutableArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    var selectedArray : [IndexPath] = [IndexPath]();
    var filteredData:[String] = [];
    var dataArray  = NSArray();
    var contact = [String : Any]();
    var arrayContacts = NSArray();
    var tweak : Contacts! = nil;
    var indexPath: NSIndexPath!;
    var resultSearchController:UISearchController!;
    var shouldShowSearchResults = false;
    var commitPredicate: NSPredicate?;
    var friendsArray = [[String : AnyObject]]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        resultSearchController = UISearchController(searchResultsController: nil);
        resultSearchController.searchResultsUpdater = self;
        resultSearchController.searchBar.placeholder = "Search";
        resultSearchController.hidesNavigationBarDuringPresentation = false;
        resultSearchController.dimsBackgroundDuringPresentation = false;
        resultSearchController.searchBar.showsScopeBar = false;
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent;
        resultSearchController.searchBar.sizeToFit();
        resultSearchController.searchBar.delegate = self;
        
        contactsTable.tableHeaderView = resultSearchController.searchBar;
        
        contactsTable.register(ContactTableViewCell.nib(), forCellReuseIdentifier: "Cell");
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
        searchBar .resignFirstResponder();
        searchBar.setShowsCancelButton(false, animated: true);
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar .resignFirstResponder();
        searchBar.setShowsCancelButton(false, animated: true);
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.setShowsCancelButton(true, animated: true);
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder();
        searchBar.setShowsCancelButton(false, animated: true);
        contactsTable.reloadData();
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        contactsTable.reloadData();
        refreshControl.endRefreshing();
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchActive == false {
            return index;
        }
        else
        {
            return 0;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        loadcontacts();
    }
    func loadcontacts(){
        dataArray  = Contacts.sharedContacts().contactsArray as NSArray;
        rc.addTarget(self, action: #selector(InviteViewController.refresh(refreshControl:)), for: UIControlEvents.valueChanged);
        if #available(iOS 10.0, *) {
            contactsTable.refreshControl = rc;
        } else {
            // Fallback on earlier versions
        }
        contactsTable.reloadData();

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive == true {
            return 1;
        }
        else
        {
            return arrIndexSection.count;
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive == false {
            return arrIndexSection.object(at: section) as? String;
        }
        else
        {
            return nil;
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if resultSearchController.isActive  {
            let predicate = NSPredicate(format: "name contains[c] %@", resultSearchController.searchBar.text! as CVarArg);
            let arrContacts = (dataArray as NSArray).filtered(using: predicate);
            return arrContacts.count;
            
        }
        else
        {
            let predicate = NSPredicate(format: "name beginswith[c] %@", arrIndexSection.object(at: section) as! CVarArg);
            let arrContacts = (dataArray as NSArray).filtered(using: predicate);
            return arrContacts.count;

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContactTableViewCell;
        var predicate : NSPredicate;
        if resultSearchController.isActive
        {
            
            predicate = NSPredicate(format: "name contains[c] %@", resultSearchController.searchBar.text! as CVarArg);
            
        }
        else{
        
            predicate = NSPredicate(format: "name beginswith[c] %@", arrIndexSection.object(at: indexPath.section) as! CVarArg);
        }
        let arrContacts = (dataArray as NSArray).filtered(using: predicate) as NSArray;
        let contactObject = arrContacts[indexPath.row] as! NSDictionary;
        
        
        cell.fullNameContact.text = contactObject["name"] as! String?;
        cell.phoneNumberContact.text = contactObject["number"] as! String?;
        cell.contactImage.image = UIImage(data: contactObject["imageData"] as! Data);
        

        if selectedArray.contains(indexPath) {
            cell.accessoryType = .checkmark;
            
        }   else{
            cell.accessoryType = .none;
            
        }
      
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75;
    }
    
    @IBAction func onClickOfDoneBtn(_ sender: Any) {
        if friendsArray.count == 0 {
            return;
        }
        var friends = [[String : AnyObject]]();
        
        for contact in friendsArray {
            var dictionary = [String : AnyObject]();
            dictionary["name"] = contact["name"];
            dictionary["msisdn"] = contact["number"];
            friends.append(dictionary as [String : AnyObject]);
        }
        MBProgressHUD.showAdded(to: self.view, animated: true);
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.INVITE_NEW_FRIENDS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, parameters: ["friends" : friends as AnyObject], success: { response in
            
           
            
            for contact in self.friendsArray {
             
                let favoriteContact = NSEntityDescription.insertNewObject(forEntityName: "TBL_Contacts", into: context) as! TBL_Contacts;
                favoriteContact.contact_name = contact["name"] as! String?;
                favoriteContact.contact_number = contact["number"] as! String?;
                favoriteContact.contact_profilePic = contact["imageData"] as? Data as NSData?;
                favoriteContact.contact_selectedDate = Date() as NSDate?;
                DatabaseController.saveContext();
            }
           
            DispatchQueue.global(qos: .background).async {
                Contacts.sharedContacts().getContactsAuthenticationForAddressBook();
                DispatchQueue.main.async {
                    self.selectedArray = [];
                    self.friendsArray = [];
                    self.loadcontacts();
                     MBProgressHUD.hide(for: self.view, animated: true);
                     self.showAlerController(message: "Selected members are added to Buzz List");
            }
                

            }
                   }, failure: { error in
            MBProgressHUD.hide(for: self.view, animated: true);
             TweakAndEatUtils.AlertView.showAlert(view: self, message: "Something went Wrong!")
        })
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true);
        var predicate : NSPredicate;
        if resultSearchController.isActive
        {
            
            predicate = NSPredicate(format: "name contains[c] %@", resultSearchController.searchBar.text! as CVarArg);
            
        }
        else{
            
            predicate = NSPredicate(format: "name beginswith[c] %@", arrIndexSection.object(at: indexPath.section) as! CVarArg);
        }
        let arrContacts = (dataArray as NSArray).filtered(using: predicate) as NSArray;
        let contactObject = arrContacts[indexPath.row] as! NSDictionary;

        if !selectedArray.contains(indexPath) {
            if selectedArray.count >= 10 {
                self.showAlerController(message: "No more selection");
                return;
            }
            selectedArray.append(indexPath);
            friendsArray.append(contactObject as! [String : AnyObject]);
            
        }else{
            if let index = selectedArray.index(where: {$0 == indexPath}) {
                selectedArray.remove(at: index);
                friendsArray.remove(at: index);
            }
        }
        tableView.reloadRows(at: [indexPath], with: .none);
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchActive == false {
            return self.arrIndexSection as? [String]; //Side Section title
        }
        else
        {
            return nil;
        }
    }
    
    func showAlerController(message : String) {
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert);
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let BuzzViewController : BuzzViewController = storyBoard.instantiateViewController(withIdentifier: "BuzzViewController") as! BuzzViewController;
            BuzzViewController.onClickSeg.selectedSegmentIndex = 1
            self.navigationController?.popViewController(animated: true)
            self.present(BuzzViewController, animated: true, completion: nil)
        })
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil);
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let categoryIndex = searchController.searchBar.selectedScopeButtonIndex;
        
        filterArrayWithCharacterLength(categoryIndex);
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        filterArrayWithCharacterLength(selectedScope);
        
    }
    
    func filterArrayWithCharacterLength(_ selectedIndex: Int) {
        
        let cells: ContactTableViewCell? = nil;
        if cells == nil {
            
            let contact = Contacts.sharedContacts().contactsArray[selectedIndex]
            let id1 = contact["name"] as! String?;
            let fullNameArr1 = id1?.characters.split{$0 == " "}.map(String.init);
           
            let filterByCharacter = fullNameArr1?.filter { (word) -> Bool in
                
                if selectedIndex == 1 && word.characters.count == 3 {
                    
                    return true;
                    
                }
                else if selectedIndex == 2 && word.characters.count == 4 {
                    
                    return true;
                    
                }
                else if selectedIndex == 0 {
                    
                    return true;
                    
                }
                else {
                    
                    return false;
                    
                }
                
            }
            
            if (resultSearchController.searchBar.text?.characters.count)! > 0 {
                
                filterArrayWithPredicate(filterByCharacter! as NSArray);
                
            }
            else {
                
                filteredData.removeAll(keepingCapacity: false);
                
                filteredData = filterByCharacter!;
                
                contactsTable.reloadData();
                
            }
            
        } else {
            return;
        }
        
    }
    
    func filterArrayWithPredicate(_ arrayToFilter: NSArray) {
        
        // 1
        filteredData.removeAll(keepingCapacity: false);
        // 2
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", resultSearchController.searchBar.text!);
        // 3
        let array = (arrayToFilter).filtered(using: searchPredicate);
        // 4
        filteredData = array as! [String];
        // 5
        contactsTable.reloadData();
        
    }
    
}

