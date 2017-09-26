//
//  AboutAppViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 24/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickOfBack(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true);
    }
}
