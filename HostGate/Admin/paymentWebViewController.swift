//
//  paymentWebViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 28/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import WebKit
import GiFHUD_Swift

class paymentWebViewController: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var wbview: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var titlelbl: UILabel!
    
    //MARK:- Variables
    var webView: WKWebView!
    var defaults:UserDefaults!
    var codeHTPP:String!
    var UserId = Int()
    var roleId = Int()
    var adminuserid = Int()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        UserId = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        wbview.navigationDelegate = self
        //view = webView
        let urlStr = String(format: "http://i.devtechnosys.tech:8083/hostgates/users/add_mob_subscriptions/")
        let postString = String(format: String(describing: UserId) + "/" + String(describing: roleId) + "/" + String(describing: adminuserid))
        let url = URL(string: urlStr + postString)!
        wbview.load(URLRequest(url: url))
        //        webview.delegate = self
        indicatorView.style =  .whiteLarge
        indicatorView.color = UIColor.black
        indicatorView.center = self.view.center
        //        termsandconditionmethod()
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Purchase More User Account" : "شراء المزيد من حساب المستخدم"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaults = UserDefaults.standard
        codeHTPP = defaults.value(forKey: "CodeHttp") as? String
    }
    
    func termsandconditionmethod() {
        let urlString = "http://192.168.1.145/hostgates/users/add_mob_subscriptions/15/2/0"
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        webview.scrollView.isScrollEnabled = true
        webview.scrollView.contentOffset = CGPoint(x: 0, y: 800)
        webview.scalesPageToFit = true
        webview.scrollView.bounces = false
        if let aString = URL(string: urlString) {
            webview.loadRequest(URLRequest(url: aString))
        }
    }
    
    //    func webViewDidStartLoad(_ webView: UIWebView) {
    //        indicatorView.startAnimating()
    //    }
    //
    //    func webViewDidFinishLoad(_ webView: UIWebView) {
    //        indicatorView.stopAnimating()
    //        indicatorView.isHidden = true
    //    }
    //
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        indicatorView.startAnimating()
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        if codeHTPP == "400" {
            if let url = webView.url?.absoluteString{
                print("url = \(url)")
                indicatorView.stopAnimating()
                indicatorView.isHidden = true
                self.codeHTPP = "401"
            }
        }else {
            if let url = webView.url?.absoluteString{
                print("url = \(url)")
                let url = URL(string: url)
                
                let task = URLSession.shared.dataTask(with: url!) { _, response, _ in
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode == 200 {
                            DispatchQueue.main.async() {
                                self.navigationController?.popViewController(animated: true)
                                self.codeHTPP = "401"
                            }
                        }
                    }
                }
                
                task.resume()
                indicatorView.stopAnimating()
                indicatorView.isHidden = true
                
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension paymentWebViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
