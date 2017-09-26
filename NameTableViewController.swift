//
//  NameTableViewController.swift
//  Tweak and Eat
//
//  Created by admin on 4/12/17.
//  Copyright © 2017 Viswa Gopisetty. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class NameTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var tableData = ["One", "Two", "Three", "Four", "Five"]
    
    var filteredData:[String] = []
    
    var resultSearchController:UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = UISearchController(searchResultsController: nil)
        
        resultSearchController.searchResultsUpdater = self
        
        resultSearchController.hidesNavigationBarDuringPresentation = false
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.showsScopeBar = false
        
        resultSearchController.searchBar.scopeButtonTitles = ["All", "3 char", "4 char"]
        
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        resultSearchController.searchBar.sizeToFit()
        
        resultSearchController.searchBar.delegate = self
        
        tableView.tableHeaderView = resultSearchController.searchBar
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if resultSearchController.isActive {
            return filteredData.count
        }
        else {
            return tableData.count
        }

    }
    func updateSearchResults(for searchController: UISearchController) {
        let categoryIndex = searchController.searchBar.selectedScopeButtonIndex
        
        filterArrayWithCharacterLength(selectedIndex: categoryIndex)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        // Configure the cell...
        if resultSearchController.isActive {
            cell.textLabel?.text = filteredData[indexPath.row]
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row]
        }
        
        return cell
    }
    func filterArrayWithCharacterLength(selectedIndex: Int){
        
        let filterByCharacter = self.tableData.filter { (word) -> Bool in
            
            if selectedIndex == 1 && word.characters.count == 3 {
                
                return true
                
            }
            else if selectedIndex == 2 && word.characters.count == 4 {
                
                return true
                
            }
            else if selectedIndex == 0 {
                
                return true
                
            }
            else {
                
                return false
                
            }
            
        }
        
        if resultSearchController.searchBar.text?.characters.count > 0 {
            
            filterArrayWithPredicate(filterByCharacter as NSArray)
            
        }
        else {
            
            filteredData.removeAll(keepingCapacity: false)
            
            filteredData = filterByCharacter
            
            tableView.reloadData()
            
        }
    }
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        filterArrayWithCharacterLength(selectedIndex: selectedScope)

    }
    func filterArrayWithPredicate(_ arrayToFilter: NSArray) {
        
        // 1
        filteredData.removeAll(keepingCapacity: false)
        // 2
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", resultSearchController.searchBar.text!)
        // 3
        let array = (arrayToFilter).filtered(using: searchPredicate)
        // 4
        filteredData = array as! [String]
        // 5
        tableView.reloadData()
        
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
