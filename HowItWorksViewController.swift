//
//  HowItWorksViewController.swift
//  Tweak and Eat
//
//  Created by Apple on 9/26/18.
//  Copyright © 2018 Purpleteal. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HowItWorksViewController: UIViewController, AVAudioPlayerDelegate {
    var countryCode = ""

    @IBOutlet weak var videoBtnImg: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.playVideo();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func playVideo() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            
            if countryCode == "91" || countryCode == "63" || countryCode == "65" {
                videoBtnImg.setImage(UIImage(named: "tae_en_howitworks_img.jpg"), for: .normal);

                let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
            } else {
                if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                    let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                    
                    if language == "EN" {
                        videoBtnImg.setImage(UIImage(named: "tae_en_howitworks_img.jpg"), for: .normal);
                        let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                        
                    } else if language == "BA" {
                        videoBtnImg.setImage(UIImage(named: "tae_en_howitworks_img.jpg"), for: .normal);
//
                        let videoURL = URL(string: "https://s3.ap-south-1.amazonaws.com/tweakandeatappassets/tae_and_how_it_works_ba.mp4")
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
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
                    present(playerController, animated: true) {
                        player.play()
                    }
                }
            }
        }
        
    }
    


    @IBAction func videoPlayAction(_ sender: Any) {
        self.playVideo();
    }
    
}
