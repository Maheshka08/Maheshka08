//
//  WebViewController.swift
//  Tweak and Eat
//
//  Created by  Meher Uday Swathi on 27/09/17.
//  Copyright © 2017 Purpleteal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    @objc var urlString: String = ""
    @objc var navigationTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.navigationTitle
       
        if let url = URL(string: self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.loadRequest(request)
        }       
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Please check your internet connection and try again !!")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
