//
//  WebViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 27/09/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @objc var urlString: String = ""
    @objc var navigationTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.navigationTitle
       
        if let url = URL(string: self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.load(request)
        }       
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
