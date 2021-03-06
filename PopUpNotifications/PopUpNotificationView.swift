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
import MediaPlayer
import WebKit

class PopUpNotificationView: UIView {
    
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var fullScreenPopUp: UIView!
    @IBOutlet weak var smallScreenImageView: UIImageView!
    @IBOutlet weak var popUpTextView: UITextView!
    @IBOutlet weak var videoPlayerView: UIView!
    var webView = WKWebView()
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallScreenPopUp: UIView!
    var link = ""
    var countryCode = ""
    var ptpPackage = ""
    var noteType = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func goToBuyScreen(packageID: String, identifier: String) {
        UserDefaults.standard.set(identifier, forKey: "POP_UP_IDENTIFIERS")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
                              MBProgressHUD.showAdded(to: self, animated: true);
                              }
                              self.moveToAnotherView(promoAppLink: packageID)

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
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
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
                    if packageObj.count == 0 {
                        self.goToHomePage()
                        return
                    }
                    self.showAvailablePremiumPackageVC(obj: packageObj)
                    //self.performSegue(withIdentifier: "fromAdsToMore", sender: packageObj)
                }
            }
        })
    }
    func goToNutritonConsultantScreen(packageID: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
        clickViewController?.packageID = packageID
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    
    func goToAskSia() {
        //AskSiaViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "AskSiaViewController") as? AskSiaViewController;
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    
    func tapToTweak() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
        clickViewController?.tapToTweak = true
     let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    
    func goToCheckThisOut() {
        //AskSiaViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakNotificationsViewController") as? TweakNotificationsViewController;
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    
    func tappedOnPopUpDone() {
        if self.noteType == 8 {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
            return
        }
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
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        let promoAppLink = link //PP_PACKAGES
        if promoAppLink == "HOME" || promoAppLink == "" {
            self.goToHomePage()
            
        } else if link == "ASKSIA" {
            self.goToAskSia()
        } else if link == "RECIPE_WALL" {
            self.goToRecipeWall()
        } else if link == "TAP_TO_TWEAK" {
            self.tapToTweak()
            
        } else if link == "NCP_PUR_IND_OP" || link == "PACK_IND_NCP" {
            if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil {
                self.goToNutritonConsultantScreen(packageID: "-NcInd5BosUcUeeQ9Q32")
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
        self.goToBuyScreen(packageID: "-NcInd5BosUcUeeQ9Q32", identifier: link)
            }
        } else if link == "CLUBAIDP_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                self.showMyTweakAndEatVC(promoLink: "-ClubInd4tUPXHgVj9w3")
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
           self.goToBuyScreen(packageID: "-ClubInd4tUPXHgVj9w3", identifier: link)
            }
        } else if link == "MYAIDP_PUR_IND_OP_3M" || link == "MYAIDP_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
             self.showMyTweakAndEatVC(promoLink: "-AiDPwdvop1HU7fj8vfL")
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
        self.goToBuyScreen(packageID: "-AiDPwdvop1HU7fj8vfL", identifier: link)
            }
        } else if link == "MYTAE_PUR_IND_OP_3M" || link == "WLIF_PUR_IND_OP_3M" || link == "MYTAE_PUR_IND_OP_1M" || link == "WLIF_PUR_IND_OP_1M" {
            if link == "MYTAE_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.showMyTweakAndEatVC(promoLink: "-IndIWj1mSzQ1GDlBpUt")
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: link)
                }
            }else if link == "MYTAE_PUR_IND_OP_1M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.showMyTweakAndEatVC(promoLink: "-IndIWj1mSzQ1GDlBpUt")
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: link)
                }
            } else if link == "WLIF_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.showMyTweakAndEatVC(promoLink: "-IndWLIntusoe3uelxER")
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: link)
                }
            } else if link == "WLIF_PUR_IND_OP_1M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.showMyTweakAndEatVC(promoLink: "-IndWLIntusoe3uelxER")
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: link)
                }
            }
        } else if link == "CLUB_PURCHASE" || link == "CLUB_PUR_IND_OP_1M" {
            
            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
              self.goToTAEClubMemPage()
            } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
        } else if link == "CLUB_SUBSCRIPTION" || link == clubPackageSubscribed {
            //MYTAE_PUR_IND_OP_3M
                      if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                         self.goToTAEClubMemPage()
                       } else {
                        DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self, animated: true);
                        }
                        self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
        } else if link == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: link) != nil {
                self.goToNutritonConsultantScreen(packageID: promoAppLink)
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "PP_PACKAGES" {
          //  self.performSegue(withIdentifier: "buyPackages", sender: self);
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                                 let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
                  
                  // vc.fromHomePopups = true
                                 let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                                 navController?.pushViewController(vc, animated: true);
        } else if promoAppLink == "PP_LABELS" || promoAppLink == "-Qis3atRaproTlpr4zIs" {
           // self.performSegue(withIdentifier: "nutritionPack", sender: self)
            self.showNutritionLabels(promoLink: promoAppLink)
        }else if promoAppLink == "CHECK_THIS_OUT" {
           // self.performSegue(withIdentifier: "checkThisOut", sender: self)
            goToCheckThisOut()
        } else if promoAppLink == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: promoAppLink) != nil {
                self.goToNutritonConsultantScreen(packageID: promoAppLink)
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
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
        if self.link == "HOME" || self.link == "" {
            self.goToHomePage()
           return
        }
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
    
    func goToHomePage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
     let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
    }
    
    func goToTAEClub() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    
    func goToTAEClubMemPage() {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
          let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
       navController?.pushViewController(clickViewController!, animated: true);
         
      }
    
    func goToPurchaseTAEClubScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
        clickViewController?.fromPopUpScreen = true
     let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
     navController?.pushViewController(clickViewController!, animated: true);
    }

    
    
    func showCaloriesVC() {
        //CaloriesLeftForTheDayController
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
         let vc : CaloriesLeftForTheDayController = storyBoard.instantiateViewController(withIdentifier: "CaloriesLeftForTheDayController") as! CaloriesLeftForTheDayController;
        // myWall.postedOn = postedOn
        
         let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
         navController?.pushViewController(vc, animated: true);
    }
    func goToRecipeWall() {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakRecipeViewController") as? TweakRecipeViewController;
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navController?.pushViewController(clickViewController!, animated: true);
        }
    
    @IBAction func doneTappedOnSmallPopUp(_ sender: Any) {
        self.removeFromSuperview()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if link == "HOME" || link == "" {
            self.goToHomePage()
               } else if link == "CALS_LEFT_FS_POPUP" {
                   //UIView.setani
                  // self.performSegue(withIdentifier: "calorieMeter", sender: self)
            self.showCaloriesVC()

               } else if link == "HOW_IT_WORKS" {
                   
                 self.playVideo()
               } else if link == "RECIPE_WALL" {
                self.goToRecipeWall()
                self.playVideo()
              } else if link == "MYTAE_PUR_IND_OP_3M" || link == "WLIF_PUR_IND_OP_3M" {
                   if link == "MYTAE_PUR_IND_OP_3M" {
                       if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                        self.showMyTweakAndEatVC(promoLink: "-IndIWj1mSzQ1GDlBpUt")
                           //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                       } else {
                   self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: link)
                       }
                   } else if link == "WLIF_PUR_IND_OP_3M" {
                       if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                        self.showMyTweakAndEatVC(promoLink: "-IndWLIntusoe3uelxER")
                           //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                       } else {
                   self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: link)
                       }
                   }
               } else if link == "CLUB_PURCHASE" || link == "CLUB_PUR_IND_OP_1M" {
                   if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
                     self.goToTAEClubMemPage()
                   } else {
                    if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                        self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                    }
                    if self.countryCode == "91" {
                    self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                    } else {
                        self.goToPurchaseTAEClubScreen()

                    }
                    

                }
               } else if link == "CLUB_SUBSCRIPTION" || link == clubPackageSubscribed {
                //MYTAE_PUR_IND_OP_3M
                          if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                             self.goToTAEClubMemPage()
                           } else {
                            DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self, animated: true);
                            }
                            self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
            } else if link == "-NcInd5BosUcUeeQ9Q32" {
                
                
                if UserDefaults.standard.value(forKey: link) != nil {
                    self.goToNutritonConsultantScreen(packageID: link)
                } else {
                    DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self, animated: true);
                    }
                    self.moveToAnotherView(promoAppLink: link)

                    
                    
                }
                
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
        } else if type == 5 {
            self.fullScreenPopUp.isHidden = false
            self.videoPlayerView.isHidden = false
       
            let mywkwebviewConfig = WKWebViewConfiguration()

              mywkwebviewConfig.allowsInlineMediaPlayback = true
            webView = WKWebView(frame: self.videoPlayerView.frame, configuration: mywkwebviewConfig)
                        self.videoPlayerView.addSubview(webView)

              let myURL = URL(string: "https://www.youtube.com/embed/\(imgUrlString)")
              let youtubeRequest = URLRequest(url: myURL!)

            webView.load(youtubeRequest)



        } else if type == 8 {
            self.fullScreenPopUp.isHidden = false
            self.fullScreenImageView.sd_setImage(with: URL(string: imgUrlString))
            self.noteType = type

            
        }
        self.link = link
        
  
    }
}
