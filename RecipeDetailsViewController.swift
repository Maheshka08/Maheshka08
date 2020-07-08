//
//  RecipeDetailsViewController.swift
//  Tweak and Eat
//
//  Created by Anusha Thota on 12/8/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import AVKit
import AVFoundation

class RecipeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    @objc var bundle = Bundle();
    let realm :Realm = try! Realm();
    @objc var countryCode = "";

    @objc var hasVideo = false;
    @objc var videoPath = "";
    @objc var benifitsArray = NSMutableArray();
    @objc var nutritionFactsArray = NSMutableArray();
    @objc var ingredientsArray = NSMutableArray();
    @objc var instructionsArray = NSMutableArray();
    @objc var tempArray = NSMutableArray();
    var ingredientsDict: [Ingredients] = [];
    @objc var buyIngredientsArray = NSMutableArray();
    @objc var vendorsArrayForDIY = NSMutableArray();
    @objc var vendorsArrayForIngredients = NSMutableArray();
    var canBuyDiyVendor: [CanBuyDIYVendor] = [];
    var sticker1Image = UIImage()
    var sticker2Image = UIImage()
    @objc var cookingTime: String = "";
    @objc var prepTime: String = "";
    @objc var carbs: String = "";
    @objc var recipeTitle : String = "";
    @objc var imgString: String = "";
    @objc var snapshotKey: String = "";
    @objc let backgroundImage = UIImage(named: "stamp.png");
    @objc var tweakDictionary = Dictionary<String, Any>();
    var canBuyDiyFrm: [CanBuyDIYFrom] = [];
    @objc var canBuyDiy = false;
    @objc var canBuyIngredients = false;
    
    @IBOutlet weak var buyButtonTop: UIButton!;
    @IBOutlet weak var buyButtonButtom: UIButton!;
    
    @IBOutlet weak var buyDIYTopBtn: UIButton!;
    @IBOutlet weak var buyDIYButtomBtn: UIButton!;
    
    @IBOutlet weak var playIcon: UIButton!;
    @IBOutlet var tableView: UITableView!;
    @IBOutlet var prepTimeLabel: UILabel!;
    @IBOutlet var cookingTimeLabel: UILabel!;
    @IBOutlet var carbsLabel: UILabel!;
    
    @IBOutlet weak var sticker2ImageView: UIImageView!
    @IBOutlet weak var prepTimeLbl: UILabel!;
    @IBOutlet weak var cookingTimeLbl: UILabel!;
    @IBOutlet weak var carbsLbl: UILabel!;
    @IBOutlet var recipeImageView: UIImageView!;
    var immunityStickerUrl = ""
    var vegStickerUrl = ""
    var nonVegStickerUrl = ""
    @IBOutlet weak var sticker1ImageView: UIImageView!
    @IBOutlet var recipeTitleLbl: UILabel!;
    var isVeg = false
    override func viewDidLoad() {
        super.viewDidLoad();
        self.sticker2ImageView.isHidden = true
        self.sticker1ImageView.isHidden = true
      
        if self.immunityStickerUrl.count > 0 {
            self.sticker2ImageView.isHidden = false
            self.sticker2ImageView.sd_setImage(with: URL(string: self.immunityStickerUrl))
            if self.isVeg == true {
                self.sticker1ImageView.isHidden = false
            self.sticker1ImageView.sd_setImage(with: URL(string: self.vegStickerUrl))
            } else {
                self.sticker1ImageView.isHidden = false
                 self.sticker1ImageView.sd_setImage(with: URL(string: self.nonVegStickerUrl))
            }
        } else if self.immunityStickerUrl.count == 0 {
            self.sticker2ImageView.isHidden = true
           
            if self.isVeg == true {
                self.sticker1ImageView.isHidden = false
                       self.sticker1ImageView.sd_setImage(with: URL(string: self.vegStickerUrl))
                       } else {
                self.sticker1ImageView.isHidden = false
                            self.sticker1ImageView.sd_setImage(with: URL(string: self.nonVegStickerUrl))
                       }
        }

        self.recipeImageView.contentMode = .scaleAspectFill
        self.recipeImageView.clipsToBounds = true
        bundle = Bundle.init(path: path!)! as Bundle;
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            }
        }
        self.cookingTimeLbl.text = bundle.localizedString(forKey: "cooking_Time", value: nil, table: nil);
        
        self.prepTimeLbl.text = bundle.localizedString(forKey: "preparation_Time", value: nil, table: nil);
        
        self.carbsLbl.text = bundle.localizedString(forKey: "carbs_details", value: nil, table: nil);
        
        if self.hasVideo == false {
            self.playIcon.isHidden = true;
        } else {
            self.playIcon.isHidden = false;
        }

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.buyButtonTop.isHidden = true
//        self.buyButtonButtom.isHidden = true
//        self.buyDIYTopBtn.isHidden = true
//        self.buyDIYButtomBtn.isHidden = true
        
//        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//
//        if self.countryCode == "91" {
//        if self.canBuyDiy == true {
//            self.buyButtonTop.isHidden = false;
//            self.buyButtonButtom.isHidden = false;
//            buyButtonTop.setImage(UIImage(named: "buy_diy_kit_btn"), for: .normal);
//            buyButtonButtom.setImage(UIImage(named: "buy_diy_kit_btn"), for: .normal);
//            if canBuyDiyFrm.count > 0 {
//                for vendor in canBuyDiyFrm {
//                    let localVendorData = self.realm.object(ofType: FulfillmentVendors.self, forPrimaryKey: vendor.vendorId);
//                    if localVendorData != nil {
//
//                        let dict: NSDictionary = ["snapShot": localVendorData?.snapShot as AnyObject as! String, "canSellDiy":localVendorData?.canSellDiy as AnyObject as! Bool, "canSellIngredients":localVendorData?.canSellIngredients as AnyObject as! Bool,"fcmGroupName": localVendorData?.fcmGroupName as AnyObject as! String,"logo": localVendorData?.logo as AnyObject as! String,"name": localVendorData?.name as AnyObject as! String,"warningMessage": localVendorData?.warningMessage as AnyObject as! String]
//                        vendorsArrayForDIY.add(dict)
//                    }
//                }
//            }
//        }
//        if self.canBuyIngredients == true {
//            self.buyButtonTop.isHidden = false;
//            self.buyButtonButtom.isHidden = false;
//            buyButtonTop.setImage(UIImage(named: "buy_ingredients"), for: .normal);
//            buyButtonButtom.setImage(UIImage(named: "buy_ingredients"), for: .normal);
//            let localVendorData = self.realm.objects(FulfillmentVendors.self).filter("canSellIngredients = %@", true);
//            print(localVendorData)
//            for vendors in localVendorData {
//                let dict: NSDictionary = ["snapShot": vendors.snapShot as AnyObject as! String, "canSellDiy":vendors.canSellDiy as AnyObject as! Bool, "canSellIngredients":vendors.canSellIngredients as AnyObject as! Bool,"fcmGroupName": vendors.fcmGroupName as AnyObject as! String,"logo": vendors.logo as AnyObject as! String,"name": vendors.name as AnyObject as! String,"warningMessage": vendors.warningMessage as AnyObject as! String]
//                vendorsArrayForIngredients.add(dict)
//            }
//
////            if localVendorData.count > 0 {
////
////                let dict: NSDictionary = ["snapShot": localVendorData?.snapShot as AnyObject as! String, "canSellDiy":localVendorData?.canSellDiy as AnyObject as! Bool, "canSellIngredients":localVendorData?.canSellIngredients as AnyObject as! Bool,"fcmGroupName": localVendorData?.fcmGroupName as AnyObject as! String,"logo": localVendorData?.logo as AnyObject as! String,"name": localVendorData?.name as AnyObject as! String,"warningMessage": localVendorData?.warningMessage as AnyObject as! String]
////                vendorsArray.add(dict)
////            }
//
//        }
//        if (self.canBuyDiy == true && self.canBuyIngredients == true) {
//            self.buyButtonTop.isHidden = false
//            self.buyButtonButtom.isHidden = false
//            self.buyDIYTopBtn.isHidden = false
//            self.buyDIYButtomBtn.isHidden = false
//
//        }
//            }
    //    }

        let imageView = UIImageView(image: backgroundImage);
        imageView.alpha = 0.1;
        self.tableView.backgroundView = imageView;
        self.tableView.backgroundColor = UIColor.white;
        self.cookingTimeLabel.text = self.cookingTime;
        
        self.carbsLabel.text = self.carbs;
        self.prepTimeLabel.text = self.prepTime;
        self.recipeTitleLbl.text = self.recipeTitle;
        self.recipeImageView?.sd_setImage(with: URL(string: self.imgString));
        self.recipeImageView.isUserInteractionEnabled = true;
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage));
        tapped.numberOfTapsRequired = 1;
        self.recipeImageView?.addGestureRecognizer(tapped);
    }
    
    @IBAction func buyDIYBtn1Tapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showVendors", sender: sender);
    }
    
    @IBAction func buyDIYBtn2Tapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showVendors", sender: sender);
    }
    
    @IBAction func buyIngredientsBtn2Tapped(_ sender: Any) {
        print(sender);
        self.performSegue(withIdentifier: "showVendors", sender: sender);
    }
    
    @IBAction func buyIngredientsBtn1Tapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showVendors", sender: sender);
    }
    
    @IBAction func recipeVideoAction(_ sender: Any) {
        if self.videoPath == "" {
          
        } else {
            let videoURL = URL(string: self.videoPath);
            let player = AVPlayer(url: videoURL!);
            let playerViewController = AVPlayerViewController();
            playerViewController.player = player;
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play();
            }
        }
    }
    
    @objc func tappedOnImage(sender:UITapGestureRecognizer){
        if self.videoPath == "" {
            let imageView = sender.view as! UIImageView;
            let newImageView = UIImageView(image: imageView.image);
            let stampImageView = UIImageView(image: UIImage(named: "smallStamp.png"));
        
            newImageView.frame = CGRect(x:0, y:0 - 64, width: self.view.frame.size.width, height: self.view.frame.size.height + 64);
            stampImageView.frame = CGRect(x:newImageView.frame.minX, y:22, width: 50, height: 50);
            let logo = UIImageView(image: UIImage(named: "birdiefood.png"));
        
            logo.frame = CGRect(x:self.view.frame.size.width - 50, y:22, width: 30, height: 50);
            stampImageView.frame = CGRect(x:newImageView.frame.minX, y:22, width: 50, height: 50);
            let stickerImageView1 = UIImageView(frame: CGRect(x: newImageView.frame.size.width - 70, y: newImageView.frame.maxY - 0, width: 50, height: 50))
                newImageView.addSubview(stickerImageView1)

             let stickerImageView2 = UIImageView(frame: CGRect(x: stickerImageView1.frame.minX - 60, y: newImageView.frame.maxY - 0, width: 50, height: 50))
          
             newImageView.addSubview(stickerImageView2)
            stickerImageView1.isHidden = true
            stickerImageView2.isHighlighted = true
            if self.immunityStickerUrl.count > 0 {
                stickerImageView2.isHidden = false
                stickerImageView2.sd_setImage(with: URL(string: self.immunityStickerUrl))
                if self.isVeg == true {
                    stickerImageView1.isHidden = false
                stickerImageView1.sd_setImage(with: URL(string: self.vegStickerUrl))
                } else {
                    stickerImageView1.isHidden = false
                     stickerImageView1.sd_setImage(with: URL(string: self.nonVegStickerUrl))
                }
            } else if self.immunityStickerUrl.count == 0 {
                stickerImageView2.isHidden = true
               
                if self.isVeg == true {
                    stickerImageView1.isHidden = false
                           stickerImageView1.sd_setImage(with: URL(string: self.vegStickerUrl))
                           } else {
                    stickerImageView1.isHidden = false
                                stickerImageView1.sd_setImage(with: URL(string: self.nonVegStickerUrl))
                           }
            }
            newImageView.backgroundColor = .black;
            newImageView.contentMode = .scaleAspectFit;
            newImageView.clipsToBounds = true;
            newImageView.isUserInteractionEnabled = true;
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage));
            newImageView.addGestureRecognizer(tap);
            self.view.addSubview(newImageView);
            newImageView.addSubview(stampImageView);
            newImageView.addSubview(logo);

            self.navigationController?.navigationBar.isHidden = true;
            
        } else {
            let videoURL = URL(string: self.videoPath);
            let player = AVPlayer(url: videoURL!);
            let playerViewController = AVPlayerViewController();
            playerViewController.player = player;
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play();
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.buyButtonTop.isHidden = true;
        self.buyButtonButtom.isHidden = true;
        self.buyDIYTopBtn.isHidden = true;
        self.buyDIYButtomBtn.isHidden = true;
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview();
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.benifitsArray.count;
        }
        if section == 1 {
            return self.ingredientsArray.count;
        }
        if section == 2 {
            return self.instructionsArray.count;
        }
        if section == 3 {
            return self.nutritionFactsArray.count;
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RecipeDetailsCell;
        if indexPath.section == 0 {
            cell.lbl.text = "\n" + (self.benifitsArray[indexPath.row] as? String)!;
        }
        if indexPath.section == 1 {
            cell.lbl.text = "\n" + "\(indexPath.row + 1)" + ". " + "\(self.ingredientsArray[indexPath.row] as! String)";
        }
        if indexPath.section == 2 {
            cell.lbl.text = "\n" + (self.instructionsArray[indexPath.row] as? String)!;
        }
        if indexPath.section == 3 {
            cell.lbl.text = "\n" + (self.nutritionFactsArray[indexPath.row] as? String)!;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = setHeaderView(imageName: "benifitsIcon.png", titleText: bundle.localizedString(forKey: "benfits", value: nil, table: nil), titleColor: UIColor.init(red: 178.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0));
            return headerView;
        }
        if section == 1 {
            let headerView = setHeaderView(imageName: "ingredientsIcon.png", titleText: bundle.localizedString(forKey: "ingredients", value: nil, table: nil), titleColor: UIColor.init(red: 37.0/255.0, green: 163.0/255.0, blue: 136.0/255.0, alpha: 1.0));
            return headerView;
        }
        if section == 2 {
            let headerView = setHeaderView(imageName: "instructions.png", titleText: bundle.localizedString(forKey: "instructions", value: nil, table: nil), titleColor: UIColor.init(red: 242.0/255.0, green: 173.0/255.0, blue: 13.0/255.0, alpha: 1.0));
            return headerView;
        }
        if section == 3 {
            let headerView = setHeaderView(imageName: "nutrition.png", titleText: bundle.localizedString(forKey: "nutrition", value: nil, table: nil), titleColor: UIColor.init(red: 200.0/255.0, green: 22.0/255.0, blue: 55.0/255.0, alpha: 1.0));
            return headerView;
        }
        return nil
    }
    
    @objc func setHeaderView(imageName: String, titleText: String, titleColor: UIColor) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 5, width: tableView.frame.size.width, height: 60));
        let imgView = UIImageView(frame: CGRect(x: 5, y: 0, width: 60, height: 60));
        let bcndImg =  UIImage(named: imageName);
        imgView.image = bcndImg;
        let titleLbl = UILabel(frame: CGRect(x: imgView.frame.maxX + 8, y: 0, width: 200, height: 60));
        titleLbl.text = titleText;
        titleLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0);
        titleLbl.textColor = titleColor;
        view.addSubview(imgView);
        view.addSubview(titleLbl);
        return view;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65;
    }

    @IBAction func shareTapped(_ sender: Any) {
        TweakAndEatUtils.AlertView.showAlert(view: self, message: bundle.localizedString(forKey: "coming_soon", value: nil, table: nil));
    }
    
    @IBAction func awesomeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "popOver", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popOver" {
            let destination = segue.destination as! AwesomeCountViewController;
            destination.tweakDictionary["awesomeMembers"] = self.tempArray as AnyObject;
            destination.titleName = bundle.localizedString(forKey: "awesome", value: nil, table: nil);
            destination.checkVariable = bundle.localizedString(forKey: "awesome", value: nil, table: nil);
            destination.recipeTitle = self.recipeTitle;
            destination.imageUrl = self.imgString;

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
