//
//  TabbarVcViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 24/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit


class TabbarVcViewController: UITabBarController, UITabBarControllerDelegate {
    
    let IS_IPHONEX = (UIScreen.main.bounds.size.height - 812) != 0.0 ? false : true
    let IS_IPHONE_XS = (UIScreen.main.bounds.size.height - 812) != 0.0 ? false : true
    let IS_IPHONE_X_MAX = (UIScreen.main.bounds.size.height - 896) != 0.0 ? false : true
    let IS_IPHONE_XR = (UIScreen.main.bounds.size.height - 828) != 0.0 ? false : true
    var arb = ""
    var eng = ""
    var isFirstTimeReload = Bool()
    var defaults:UserDefaults!
    var Language:String!
    var role:Int!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        
        tabBarController?.delegate = self
        
        Language = defaults.value(forKey: "Language") as? String
        role = defaults.integer(forKey: "ROLE")
        user_sts = defaults.value(forKey: "User_Status") as? String
        
        
        if user_sts == "1" {
            self.viewControllers![0].title = Language == "en" ? "DASHBOARD" : "لوحة القيادة"
            self.viewControllers![1].title = Language == "en" ? "COMMUNITIES" : "مجتمعات"
            self.viewControllers![2].title = Language == "en" ? "ADMIN ACCOUNTS" : "حسابات المسؤول"
            self.viewControllers![3].title = Language == "en" ? "REPORTS" : "تقارير"
        }else if user_sts == "2"{
            if role == 1 {
                var viewControllers = self.viewControllers
                viewControllers?.remove(at: 2)
                self.viewControllers = viewControllers
                self.viewControllers![0].title = Language == "en" ? "DASHBOARD" : "لوحة القيادة"
                self.viewControllers![1].title = Language == "en" ? "COMMUNITIES" : "مجتمعات"
                self.viewControllers![2].title = Language == "en" ? "REPORTS" : "تقارير"
            }else if role == 2 {
                
            }else if role == 3 {
                self.viewControllers![0].title = Language == "en" ? "DASHBOARD" : "لوحة القيادة"
                self.viewControllers![1].title = Language == "en" ? "COMMUNITIES" : "مجتمعات"
                self.viewControllers![2].title = Language == "en" ? "ADMIN ACCOUNTS" : "حسابات المسؤول"
                self.viewControllers![3].title = Language == "en" ? "REPORTS" : "تقارير"
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
        view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        if (IS_IPHONEX || IS_IPHONE_XS || IS_IPHONE_X_MAX || IS_IPHONE_XR) {
            var tabFrame = self.tabBar.frame
            // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
            tabFrame.size.height = 83
            tabFrame.origin.y = self.view.frame.size.height - 83
            self.tabBar.frame = tabFrame
        }
    }
    
}
