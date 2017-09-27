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
    var urlString: String = ""
    var navigationTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.navigationTitle
        // Do any additional setup after loading the view.
        
        
        //let url = URL(string: self.urlString)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
