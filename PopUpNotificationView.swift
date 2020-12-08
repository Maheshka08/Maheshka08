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

//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
//                       let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
//        vc.packageID = packageID
//        vc.identifierFromPopUp = identifier
//         vc.fromHomePopups = true
//                       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//                       navController?.pushViewController(vc, animated: true);
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
        if promoAppLink == "HOME" || promoAppLink == "" {
            self.goToHomePage()
            
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
        } else if link == "CLUB_SUBSCRIPTION" || link == "-ClubInd3gu7tfwko6Zx" || link == "-ClubIdn4hd8flchs9Vy" {
            //MYTAE_PUR_IND_OP_3M
                      if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
                         self.goToTAEClubMemPage()
                       } else {
                           //self.goToTAEClub()
                        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                        }
                        if self.countryCode == "91" {
                            DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self, animated: true);
                            }
                            self.moveToAnotherView(promoAppLink: "-ClubInd3gu7tfwko6Zx")
                        } else {
                            DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self, animated: true);
                            }
                            self.moveToAnotherView(promoAppLink: "-ClubIdn4hd8flchs9Vy")
                        }
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
    
    @IBAction func doneTappedOnSmallPopUp(_ sender: Any) {
        self.removeFromSuperview()
        if link == "HOME" || link == "" {
            self.goToHomePage()
               } else if link == "CALS_LEFT_FS_POPUP" {
                   //UIView.setani
                  // self.performSegue(withIdentifier: "calorieMeter", sender: self)
            self.showCaloriesVC()

               } else if link == "HOW_IT_WORKS" {
                   
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
               } else if link == "CLUB_SUBSCRIPTION" || link == "-ClubInd3gu7tfwko6Zx" || link == "-ClubIdn4hd8flchs9Vy" {
            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
                self.goToTAEClubMemPage()

            } else {
                //self.goToTAEClub()
             if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                 self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
             }
             if self.countryCode == "91" {
                 DispatchQueue.main.async {
                 MBProgressHUD.showAdded(to: self, animated: true);
                 }
                 self.moveToAnotherView(promoAppLink: "-ClubInd3gu7tfwko6Zx")
             } else {
                 DispatchQueue.main.async {
                 MBProgressHUD.showAdded(to: self, animated: true);
                 }
                 self.moveToAnotherView(promoAppLink: "-ClubIdn4hd8flchs9Vy")
             }
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
           // let url = URL(string: imgUrlString)!
//            let videoURL = URL(string: imgUrlString);
//            let player = AVPlayer(url: videoURL!);
//            let playerViewController = AVPlayerViewController();
//            playerViewController.view.frame = self.videoPlayerView.bounds
//            playerViewController.player = player;
//
//            UIApplication.shared.keyWindow?.rootViewController!.present(playerViewController, animated: true) {
//                playerViewController.player!.play();
//            }
//            if let url = URL(string: imgUrlString) {
//                //2. Create AVPlayer object
//                let asset = AVAsset(url: url)
//                let playerItem = AVPlayerItem(asset: asset)
//                let player = AVPlayer(playerItem: playerItem)
//
//                //3. Create AVPlayerLayer object
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = self.videoPlayerView.bounds //bounds of the view in which AVPlayer should be displayed
//                playerLayer.videoGravity = .resizeAspect
//
//                //4. Add playerLayer to view's layer
//                self.videoPlayerView.layer.addSublayer(playerLayer)
//
//                //5. Play Video
//                player.play()
//            }
            let mywkwebviewConfig = WKWebViewConfiguration()

              mywkwebviewConfig.allowsInlineMediaPlayback = true
            webView = WKWebView(frame: self.videoPlayerView.frame, configuration: mywkwebviewConfig)
                        self.videoPlayerView.addSubview(webView)

              let myURL = URL(string: "https://www.youtube.com/embed/\(imgUrlString)")
              let youtubeRequest = URLRequest(url: myURL!)

            webView.load(youtubeRequest)

//            let url = URL(string: imgUrlString)!
//            webView.frame = self.videoPlayerView.bounds
//            self.videoPlayerView.addSubview(webView)
//            webView.load(URLRequest(url: url))
//            let videoURL = NSURL(string: imgUrlString)
//            let player = AVPlayer(url: videoURL! as URL)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.videoPlayerView.bounds
//            self.layer.addSublayer(playerLayer)
//            player.play()

        }
        self.link = link
        
  
    }
}
