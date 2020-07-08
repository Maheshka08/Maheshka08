//
//  TweakRecipeViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 11/28/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Realm
import RealmSwift
import AVFoundation


class TweakRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AwesomeButtonCellDelegate {
    
    var tweakRecipesRef : DatabaseReference!
    @IBOutlet weak var recipeWallTableView: UITableView!
    var tweakRecipesInfo : Results<TweakRecipesInfo>?
    let realm :Realm = try! Realm()
    var myIndex : Int = 0
    var myIndexPath : IndexPath = []
    var player: AVAudioPlayer?
    var nicKName : String = ""
    var sex : String = ""
    var userMsisdn : String = ""
    var isLiked : Bool?
    var Number : String = ""
    var myProfileInfo : Results<MyProfileInfo>?

    @IBOutlet weak var cartBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweakRecipesInfo = self.realm.objects(TweakRecipesInfo.self)
        UserDefaults.standard.removeObject(forKey: "DELETE_RECIPES")

        if UserDefaults.standard.value(forKey: "DELETE_RECIPESS") as? String == nil {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        //let build = dictionary["CFBundleVersion"] as! String
        if version == "1.0.9" {
            if (self.tweakRecipesInfo?.count)! > 0 {
                
                for recipeObj in self.tweakRecipesInfo! {
                    UserDefaults.standard.set("YES", forKey: "DELETE_RECIPESS")
                    deleteRealmObj(objToDelete: recipeObj)
                }
        }
        }
        }
        if UserDefaults.standard.value(forKey: "DELETE_RECIPESS1") as? String == nil {
            let dictionary = Bundle.main.infoDictionary!
            let version = dictionary["CFBundleShortVersionString"] as! String
            //let build = dictionary["CFBundleVersion"] as! String
            if version == "2.1" {
                if (self.tweakRecipesInfo?.count)! > 0 {
                    
                    for recipeObj in self.tweakRecipesInfo! {
                        UserDefaults.standard.set("YES", forKey: "DELETE_RECIPESS1")
                        deleteRealmObj(objToDelete: recipeObj)
                    }
                }
            }
        }
        self.userMsisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
        self.myProfileInfo = self.realm.objects(MyProfileInfo.self)
        for myProfObj in self.myProfileInfo! {
            nicKName = myProfObj.name
            sex = myProfObj.gender
            Number = myProfObj.msisdn
            
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        tweakRecipesRef = Database.database().reference().child("Recipes")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        getFirebaseData()
        
    }
  
    @IBAction func cacrtBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "orders", sender: self)
    }
    func getFirebaseData(){
        tweakRecipesRef.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for tweakRecipes in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let recipeObj = tweakRecipes.value as? [String : AnyObject]
                    
                    let recipeItemObj = TweakRecipesInfo()
                    let milisecond = recipeObj?["crtOn"] as AnyObject as! NSNumber;
                    let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 );
                    let dateFormatter = DateFormatter();
                    dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                    let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject;
                    recipeItemObj.crtOn = dateArrayElement as! String;
                    if let bannerImg = recipeObj?["bannerImg"] {
                        recipeItemObj.bannerImg = bannerImg as AnyObject as! String
                    }
                    
                    recipeItemObj.bannerImg = (recipeObj?["bannerImg"] as AnyObject) as! String
                    
                    if !((recipeObj?["canBuyDiy"] as AnyObject) is NSNull) {
                        
                    
                    recipeItemObj.canBuyDiy = (recipeObj?["canBuyDiy"] as AnyObject) as! Bool
                        
                    }
                    
                    if !((recipeObj?["canBuyIngredients"] as AnyObject) is NSNull) {
                    recipeItemObj.canBuyIngredients = (recipeObj?["canBuyIngredients"] as AnyObject) as! Bool
                    }
                    recipeItemObj.cookingTime = (recipeObj?["cookingTime"] as AnyObject) as! String
                    
                    recipeItemObj.crtBy = (recipeObj?["crtBy"] as AnyObject) as! String
                    
                    recipeItemObj.img = (recipeObj?["img"] as AnyObject) as! String
                    
                    recipeItemObj.preparationTime = (recipeObj?["preparationTime"] as AnyObject) as! String
                    
                    recipeItemObj.serving = (recipeObj?["serving"] as AnyObject) as! Int
                    
                    recipeItemObj.title = (recipeObj?["title"] as AnyObject) as! String
                    var awesomeCount = 0
                    if let awesomeC = recipeObj?["awesomeCount"]  {
                        awesomeCount = awesomeC as AnyObject as! Int
                    }
                    
                    recipeItemObj.awesomeCount = awesomeCount
                    let awesomeMembers = recipeObj?["awesomeMembers"]  as? [String : AnyObject]
                    
                    if awesomeCount != 0 && awesomeMembers != nil{
                        for members in awesomeMembers! {
                            
                            let awesomeMemObj = RecipeAwesomeMembers()
                            let number = (members.value["msisdn"] as AnyObject) as! String
                            if number == UserDefaults.standard.value(forKey: "msisdn") as! String {
                                awesomeMemObj.youLiked = "true"
                            }else {
                                awesomeMemObj.youLiked = "false"
                            }
                            awesomeMemObj.awesomeSnapShot = members.key
                            awesomeMemObj.aweSomeNickName = (members.value["nickName"] as AnyObject) as! String
                            let milisecond = members.value["postedOn"] as AnyObject;
                            let dateFormatter = DateFormatter();
                            dateFormatter.dateFormat = "d MMM, EEE, yyyy h:mm:ss:SSS a";
                            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond as! Int64) / 1000.0 )
                            let dateArrayElement = dateFormatter.string(from: dateVar) as AnyObject
                            
                            awesomeMemObj.aweSomePostedOn = dateArrayElement as! String
                            awesomeMemObj.aweSomeMsisdn = (members.value["msisdn"] as AnyObject) as! String
                            recipeItemObj.awesomeMembers.append(awesomeMemObj)
                        }
                    }
                    if !(recipeObj?["canBuyDiyFrom"] is NSNull) {
                    let canBuyDiyfrm = recipeObj?["canBuyDiyFrom"]  as? [String : AnyObject]
                         let canBuyDiyObj = CanBuyDiyFrom()
                          for (_, value) in canBuyDiyfrm!{
                            canBuyDiyObj.vendorId = value as! String

                        }
                        recipeItemObj.canBuyDiyFrm.append(canBuyDiyObj)

                        
                    }
                    let nutritions = recipeObj?["nutrition"]  as? [String : AnyObject]
                    
                    if nutritions != nil{
                        let factsObj = NutritionFacts()
                        
                        for (key, value) in nutritions!{
                            if key == "Calories" {
                                factsObj.Calories = value as! String
                            }
                            if key == "Carbs" {
                                factsObj.Carbs = value as! String
                            }
                            if key == "Fibre" {
                                factsObj.Fibre = value as! String
                            }
                            if key == "Protein" {
                                factsObj.Protein = value as! String
                            }
                            if key == "Total Fat" {
                                factsObj.TotalFat = value as! String
                            }
                            if key == "Sugars" {
                                factsObj.Sugars = value as! String
                            }
                            
                            if key == "SaturatedFat" {
                                factsObj.SaturatedFat = value as! String
                            }
                            
                        }
                        recipeItemObj.nutrition.append(factsObj)
                        
                    }
                    
                    let ingredients = recipeObj?["ingredients"]  as! NSMutableArray
                    if ingredients.count > 0 {
                        
                        for ingredient in ingredients{
                            if ingredient is NSNull {
                            } else {
                                let ingredientsObj = IngredientsList()
                                for (key,value) in ingredient as! [String: AnyObject] {
                                    if key == "name" {
                                        ingredientsObj.name = value as! String
                                    }
                                    if key == "qty" {
                                        ingredientsObj.qty = value as! String
                                    }
                                    if key == "unit" {
                                        ingredientsObj.unit = value as! String
                                    }
                                }
                                recipeItemObj.ingredients.append(ingredientsObj)
                                
                            }
                            
                        }
                    }
                    let benefits = recipeObj?["benefits"]  as! NSMutableArray
                    if benefits.count > 0 {
                        
                        for benefit in benefits{
                            if benefit is NSNull {
                            } else {
                                let benefitsObj = StringObj()
                                benefitsObj.value = benefit as! String
                                recipeItemObj.benefits.append(benefitsObj)
                                
                            }
                            
                        }
                    }
                    
                    let instructions = recipeObj?["instructions"]  as! NSMutableArray
                    if instructions.count > 0 {
                        
                        for instruction in instructions{
                            if instruction is NSNull {
                            } else {
                                let instructionsObj = StringObj()
                                instructionsObj.value = instruction as! String
                                recipeItemObj.instructions.append(instructionsObj)
                                
                            }
                            
                        }
                        
                    }
                    
                    recipeItemObj.snapShot = tweakRecipes.key
                    saveToRealmOverwrite(objType: TweakRecipesInfo.self, objValues: recipeItemObj)
                   
                }
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    let sortProperties = [SortDescriptor(keyPath: "crtOn", ascending: false)]
                    self.tweakRecipesInfo = self.tweakRecipesInfo!.sorted(by: sortProperties)
                    self.recipeWallTableView.reloadData()
                    
                }
                
            }
            
        })
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(TweakRecipesInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweakRecipesInfo != nil {
            if self.tweakRecipesInfo!.count > 0 {
                MBProgressHUD.hide(for: self.view, animated: true);
            }
            return self.tweakRecipesInfo!.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RecipeWallTableViewCell;
        let cellDictionary = self.tweakRecipesInfo?[indexPath.row]
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self;
        }
        cell.cellIndexPath = indexPath.row
        cell.myIndexPath = indexPath
        cell.recipeTitleLabel.text = cellDictionary?["title"] as AnyObject as? String
        let imageUrl = cellDictionary?["img"] as AnyObject as? String
        cell.recipeImageView?.sd_setImage(with: URL(string: imageUrl!))
        let recipeNutritions = cellDictionary?["nutrition"] as! List<NutritionFacts>
        for nutrition in recipeNutritions {

            cell.carbsLbl.attributedText =  setAttributedStringForLabel(mainString: "carbs: \(nutrition.Carbs)", stringToColor: nutrition.Carbs)
            cell.caloriesLabel.attributedText = setAttributedStringForLabel(mainString: "carbs: \(nutrition.Calories)", stringToColor: nutrition.Calories)
        }
//        if let awesomeCount = cellDictionary?["awesomeCount"] as AnyObject as? Int {
//            cell.awesomeLabel.text = "\(awesomeCount)" + " awesome"
//        } else {
//           cell.awesomeLabel.text = "0 awesome"
//        }
        cell.awesomeBtn?.setImage(UIImage(named: "AwesomeIcon.png"), for: .normal)
        let awesomeMem = cellDictionary?["awesomeMembers"]  as! List<RecipeAwesomeMembers>
        for mem in awesomeMem {
            
            if mem.youLiked  == "true" {
                cell.awesomeBtn?.setImage(UIImage(named: "AwesomeIconFilled.png"), for: .normal)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailedRecipe", sender: self)
    }
    
    func setAttributedStringForLabel(mainString: String, stringToColor: String) -> NSAttributedString {
        let main_string = mainString
        let string_to_color = stringToColor
        
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray , range: range)
        return attribute
    }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "detailedRecipe") {
    let benifitsArray = NSMutableArray()
    let nutritionFactsArray = NSMutableArray()
    let ingredientsArray = NSMutableArray()
    let instructionsArray = NSMutableArray()
    let awesomeArray = NSMutableArray()
    let destination = segue.destination as! RecipeDetailsViewController
    let myIndexPath = self.recipeWallTableView.indexPathForSelectedRow
    let cellDict = self.tweakRecipesInfo?[(myIndexPath?.row)!]
    destination.snapshotKey = cellDict?["snapShot"] as! String

    let benifitsDict = cellDict?["benefits"] as! List<StringObj>
    let nutritionFactsDict = cellDict?["nutrition"] as! List<NutritionFacts>
    let instructionsDict = cellDict?["instructions"] as! List<StringObj>
    let ingredientsDict = cellDict?["ingredients"] as! List<IngredientsList>

    if benifitsDict.count > 0 {
        var i = 0
        for benifit in benifitsDict {
            i += 1
            let value: String = "\(i)" + ". " + benifit.value
            benifitsArray.add(value)
        }
    }
    
    if nutritionFactsDict.count > 0 {
        for nutritionFact  in nutritionFactsDict {

            if nutritionFact.Calories != "" {
                nutritionFactsArray.add("Calories : " + nutritionFact.Calories)
            }
            if nutritionFact.Carbs != "" {
                destination.carbs = nutritionFact.Carbs
                nutritionFactsArray.add("Carbs : " + nutritionFact.Carbs)
            }
            if nutritionFact.Fibre != "" {
                nutritionFactsArray.add("Fibre : " + nutritionFact.Fibre)
            }
            if nutritionFact.Protein != "" {
                nutritionFactsArray.add("Protein : " + nutritionFact.Protein)
            }
            if nutritionFact.SaturatedFat != "" {
                nutritionFactsArray.add("Saturated Fat : " + nutritionFact.SaturatedFat)
            }
            if nutritionFact.Sugars != "" {
                nutritionFactsArray.add("Sugars : " + nutritionFact.Sugars)
            }
            if nutritionFact.TotalFat != "" {
                nutritionFactsArray.add("Total Fat : " + nutritionFact.TotalFat)
            }
        }
    }
    
    if instructionsDict.count > 0 {
        var i = 0
        for instruction in instructionsDict {
            i += 1
            let value: String = "\(i)" + ". " + instruction.value
            instructionsArray.add(value)
            
        }
    }
    
    if ingredientsDict.count > 0 {
        for ingredient in ingredientsDict {
            let value: String = ingredient.name + " - " + ingredient.qty 
            ingredientsArray.add(value)
            
        }
    }
    var tempDict : [String:AnyObject] = [:]
    let awesomeMembers = cellDict?["awesomeMembers"] as! List<RecipeAwesomeMembers>
    if cellDict?["awesomeCount"] as! Int != 0 {
        for members in awesomeMembers {
            tempDict["nickName"] = members.aweSomeNickName as AnyObject
            tempDict["postedOn"] = members.aweSomePostedOn as AnyObject
            tempDict["msisdn"] = members.aweSomeMsisdn as AnyObject
            awesomeArray.add(tempDict)
            
        }
        destination.tempArray = awesomeArray 
    }

    destination.benifitsArray = benifitsArray
    destination.nutritionFactsArray = nutritionFactsArray
    destination.instructionsArray = instructionsArray
    destination.ingredientsArray = ingredientsArray
    destination.ingredientsDict = ingredientsDict
    destination.cookingTime = (cellDict?["cookingTime"] as AnyObject as? String)!
    destination.prepTime = (cellDict?["preparationTime"] as AnyObject as? String)!
    destination.cookingTime = (cellDict?["cookingTime"] as AnyObject as? String)!
    destination.recipeTitle = (cellDict?["title"] as AnyObject as? String)!
    destination.imgString = (cellDict?["img"] as AnyObject as? String)!
    
    }
    }
    
    //Awesome Button delegate methods
    
    func cellTappedAwesome(_ cell: RecipeWallTableViewCell) {
      
        self.updateAwesomeMembers(cell)
    }
    
    func updateAwesomeMembers(_ cell: RecipeWallTableViewCell) {
        self.myIndex = cell.cellIndexPath
        self.myIndexPath = cell.myIndexPath
    
        cell.awesomeBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        cell.awesomeBtn.transform = .identity
                        cell.awesomeBtn.setImage(UIImage(named: "AwesomeIconFilled.png")!, for: UIControlState.normal);
            },
        completion: nil)
        let currentTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate)
        let currentTime = Int64(currentTimeStamp)
        let cellDict = self.tweakRecipesInfo?[self.myIndexPath.row]
        let snap = cellDict?["snapShot"] as! String
        var aweSomeCount = cellDict?["awesomeCount"] as! Int
        let awesomeMem = cellDict?["awesomeMembers"]  as! List<RecipeAwesomeMembers>
        for mem in awesomeMem {
            if mem.youLiked == "true" {
                let awesomeSnap = mem.awesomeSnapShot 
                cell.awesomeBtn.setImage(UIImage(named:"AwesomeIcon.png"), for: UIControlState.normal)
                aweSomeCount -= 1
                MBProgressHUD.showAdded(to: self.view, animated: true)
                DispatchQueue.global(qos: .background).async {
                    // Bounce back to the main thread to update the UI
    self.tweakRecipesRef.child(snap).child("awesomeMembers").child(awesomeSnap).removeValue()
                    
        self.tweakRecipesRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                return
            }
        }
        
        cell.awesomeBtn.setImage(UIImage(named:"AwesomeIconFilled.png"), for: UIControlState.normal)
        aweSomeCount += 1
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global(qos: .background).async {
            // Bounce back to the main thread to update the UI
    self.tweakRecipesRef.child(snap).child("awesomeMembers").childByAutoId().setValue(["msisdn" : self.userMsisdn as AnyObject, "postedOn" : currentTime as AnyObject,"nickName": self.nicKName as AnyObject])
            
        self.tweakRecipesRef.child(snap).updateChildValues(["awesomeCount" : aweSomeCount as AnyObject])
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        self.awesomePopUpSound()
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        
        let milliseconds: Int64 = Int64(dateToConvert.timeIntervalSince1970 * 1000)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    func awesomePopUpSound(){
        guard let url = Bundle.main.url(forResource: "AwesomePopUpSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func cellTappedOnAwesomeLabel(_ cell: RecipeWallTableViewCell, sender: UITapGestureRecognizer) {
        
        self.updateAwesomeMembers(cell)
    }
    
    func cellTappedShare(_ cell: RecipeWallTableViewCell){
         TweakAndEatUtils.AlertView.showAlert(view: self, message: "Coming soon..")
    }
    
    func cellTappedShareLabel(_ cell: RecipeWallTableViewCell, sender:UITapGestureRecognizer){
        
          TweakAndEatUtils.AlertView.showAlert(view: self, message: "Coming soon..")
    }
    
    func cellTappedSubView(_ cell: RecipeWallTableViewCell, sender:UITapGestureRecognizer){
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
