//
//  PopUpNotificationView.swift
//  Tweak and Eat
//
//  Created by Mehera on 12/06/20.
//  Copyright © 2020 Purpleteal. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Firebase
class PopUpNotificationView: UIView {
    
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var fullScreenPopUp: UIView!
    @IBOutlet weak var smallScreenImageView: UIImageView!
    @IBOutlet weak var popUpTextView: UITextView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallScreenPopUp: UIView!
    var link = ""
    var countryCode = ""
    var ptpPackage = ""
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    func showAvailablePremiumPackageVC(obj: [String : AnyObject]) {
        //AvailablePremiumPackagesViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                      let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
       let cellDict = obj as AnyObject as! [String: AnyObject]
       vc.packageID = (cellDict["packageId"] as AnyObject as? String)!
        vc.fromHomePopups = true
                      let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                      navController?.pushViewController(vc, animated: true);
    }
    
    func moveToAnotherView(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {

                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == promoAppLink {
                        packageObj = premiumPackages.value as! [String : AnyObject]

                    }

                }

                dispatch_group.leave();

                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self, animated: true);
                    self.showAvailablePremiumPackageVC(obj: packageObj)
                    //self.performSegue(withIdentifier: "fromAdsToMore", sender: packageObj)
                }
            }
        })
    }
    func tappedOnPopUpDone() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        
        if self.countryCode == "91" {
            self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
        } else if self.countryCode == "1" {
            self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
        } else if self.countryCode == "65" {
            self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
        } else if self.countryCode == "62" {
            self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
        } else if self.countryCode == "60" {
            self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
        } else if self.countryCode == "63" {
            self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
        }
        let promoAppLink = link //PP_PACKAGES
        if promoAppLink == "PP_PACKAGES" {
          //  self.performSegue(withIdentifier: "buyPackages", sender: self);
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                                 let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
                  
                  // vc.fromHomePopups = true
                                 let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                                 navController?.pushViewController(vc, animated: true);
        } else if promoAppLink == "PP_LABELS" || promoAppLink == "-Qis3atRaproTlpr4zIs" {
           // self.performSegue(withIdentifier: "nutritionPack", sender: self)
            self.showNutritionLabels(promoLink: promoAppLink)
        } else if promoAppLink == self.link {
                   
                   
                   if UserDefaults.standard.value(forKey: promoAppLink) != nil {
                    self.showMyTweakAndEatVC(promoLink: promoAppLink)
                       //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                       MBProgressHUD.showAdded(to: self, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)

                       
                       
                   }
                   
               }
        else if promoAppLink == "CHECK_THIS_OUT" {
                  // self.performSegue(withIdentifier: "checkThisOut", sender: self)
               }
        //else if promoAppLink == "-Qis3atRaproTlpr4zIs" {
//                   self.performSegue(withIdentifier: "floatingToNutrition", sender: promoAppLink)
//
//               } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
//                   if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
//
//                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                   } else {
//                       DispatchQueue.main.async {
//                       MBProgressHUD.showAdded(to: self.view, animated: true);
//                       }
//                     self.moveToAnotherView(promoAppLink: promoAppLink)
//
//                   }
//               } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
//                   if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
//
//                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                   } else {
//                       DispatchQueue.main.async {
//                           MBProgressHUD.showAdded(to: self.view, animated: true);
//                       }
//                       self.moveToAnotherView(promoAppLink: promoAppLink)
//
//                   }
//               } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
//                   if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
//
//                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                   } else {
//                       DispatchQueue.main.async {
//                           MBProgressHUD.showAdded(to: self.view, animated: true);
//                       }
//                       self.moveToAnotherView(promoAppLink: promoAppLink)
//
//                   }
//               } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
//                   if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
//
//                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                   } else {
//                       DispatchQueue.main.async {
//                           MBProgressHUD.showAdded(to: self.view, animated: true);
//                       }
//                       self.moveToAnotherView(promoAppLink: promoAppLink)
//
//                   }
//               } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
//                   if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
//
//                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                   } else {
//                       DispatchQueue.main.async {
//                           MBProgressHUD.showAdded(to: self.view, animated: true);
//                       }
//                       self.moveToAnotherView(promoAppLink: promoAppLink)
//
//                   }
//               } else if promoAppLink == "-MysRamadanwgtLoss99" {
//                          if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
//
//                              self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                          } else {
//                              DispatchQueue.main.async {
//                                  MBProgressHUD.showAdded(to: self.view, animated: true);
//                              }
//                              self.moveToAnotherView(promoAppLink: promoAppLink)
//
//                          }
//                      } else if promoAppLink == self.ptpPackage {
//                   if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
//
//                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//                   } else {
//
//                       DispatchQueue.main.async {
//                           MBProgressHUD.showAdded(to: self.view, animated: true);
//                       }
//                       self.moveToAnotherView(promoAppLink: promoAppLink)
//
//
//                   }
//               }
    }
    
    @objc func playVideo() {
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            
            if self.countryCode == "91" || self.countryCode == "63" || self.countryCode == "65" {
                
                let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                navController?.topViewController!.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
            } else {
                if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                    let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                    
                    if language == "EN" {
                        
                        let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        navController?.topViewController!.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                        
                    } else if language == "BA" {
                        let videoURL = URL(string: "https://s3.ap-south-1.amazonaws.com/tweakandeatappassets/tae_and_how_it_works_ba.mp4")
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        navController?.topViewController!.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                        
                        
                    }
                } else {
                    guard let vPath = Bundle.main.path(forResource: "tae_en_howitworks_20180926", ofType: "mp4") else {
                        debugPrint("video.mp4 not found")
                        return
                    }
                    let player = AVPlayer(url: URL(fileURLWithPath: vPath))
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    navController?.topViewController!.present(playerController, animated: true) {
                        player.play()
                    }
                }
            }
        }
        
    }
    @IBAction func doneTapped(_ sender: Any) {
        self.removeFromSuperview()
       tappedOnPopUpDone()

    }
    
    func showNutritionLabels(promoLink: String) {
        //NutritionLabelViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                       let vc : NutritionLabelViewController = storyBoard.instantiateViewController(withIdentifier: "NutritionLabelViewController") as! NutritionLabelViewController;
               vc.packageID = promoLink
                       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                       navController?.pushViewController(vc, animated: true);
    }
    
    func showMyTweakAndEatVC(promoLink: String) {
        //MyTweakAndEatVCViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : MyTweakAndEatVCViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as! MyTweakAndEatVCViewController;
        vc.packageID = promoLink
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    
    func showCaloriesVC() {
        //CaloriesLeftForTheDayController
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
         let vc : CaloriesLeftForTheDayController = storyBoard.instantiateViewController(withIdentifier: "CaloriesLeftForTheDayController") as! CaloriesLeftForTheDayController;
        // myWall.postedOn = postedOn
        
         let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
         navController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func doneTappedOnSmallPopUp(_ sender: Any) {
        self.removeFromSuperview()
        if link == "" {
               } else if link == "CALS_LEFT_FS_POPUP" {
                   //UIView.setani
                  // self.performSegue(withIdentifier: "calorieMeter", sender: self)
            self.showCaloriesVC()

               } else if link == "HOW_IT_WORKS" {
                   
                 self.playVideo()
               } else {
                   tappedOnPopUpDone()
               }
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
//        let myWall : MyWallViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as! MyWallViewController;
//       // myWall.postedOn = postedOn
//        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//        navController?.pushViewController(myWall, animated: true);
    }
    
    func showUIForSmallPopUp(imgUrlString: String, msg: String, link: String, type: Int) {
        if type == 0 {
            self.smallScreenPopUp.isHidden = false
                self.smallScreenImageView.sd_setImage(with: URL(string: imgUrlString)) { (image, error, cache, url) in
                // Your code inside completion block
                let ratio = image!.size.width / image!.size.height
                let newHeight = self.smallScreenImageView.frame.width / ratio
                self.imageViewHeightConstraint.constant = newHeight
                self.layoutIfNeeded()
                self.popUpTextView.text = msg
            }
        } else if type == 1 {
            self.fullScreenPopUp.isHidden = false
            self.fullScreenImageView.sd_setImage(with: URL(string: imgUrlString))
        }
        self.link = link
        
  
    }
}
