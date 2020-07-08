//
//  SettingsTabBarController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 11/10/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class SettingsTabBarController: UITabBarController {
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj")
    @objc var bundle = Bundle()

    override func viewDidLoad() {
        super.viewDidLoad()
        bundle = Bundle.init(path: path!)! as Bundle

        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            } else if language == "EN" {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle.init(path: path!)! as Bundle
            }
        }


        self.selectedIndex = 0
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor(red: 89/255, green: 21/255, blue: 112/255, alpha: 1.0)]);
       
        
    }
    
    @objc func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBackButton()
        guard let tabbaritem = tabBar.items else { return }
        
        tabbaritem[0].title = bundle.localizedString(forKey: "ideal_plate", value: nil, table: nil)
        tabbaritem[1].title = bundle.localizedString(forKey: "manage_profile", value: nil, table: nil)
        tabbaritem[2].title = bundle.localizedString(forKey: "tweak_reminders", value: nil, table: nil)
        tabbaritem[3].title = bundle.localizedString(forKey: "about_app", value: nil, table: nil)
        tabbaritem[4].title = bundle.localizedString(forKey: "how_it_works", value: nil, table: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
