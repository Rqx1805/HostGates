//
//  ViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport

class ViewController: UIViewController {
    
      var user_sts1 = String()
      var defaults1: UserDefaults!
      var nav1: UIStoryboard!
      var navControlle1r : UINavigationController?
      var window1:UIWindow!
      var role2:Int!
      var comType1:Int!
      var user_Id1:Int!
      var roleId2:Int!
      var adminuserid1:Int!
      let identifierManager1 = ASIdentifierManager.shared()
      var deviceId1 = String()
      var urlString1 = String()
      var language1:String!
      var deviceTocken1:NSString!
      var sts:Int!
      var timer = Timer()
      
      //MARK:- Login WebService
             @objc func HostGateAccountStatusAction(_ notification: Notification) {
                 let status = (notification.userInfo?["status"] as? Int)!
                 let str_message = (notification.userInfo?["message"] as? String)!
                 sts = (notification.userInfo?["status"] as? Int)!
                 DispatchQueue.main.async() {
                     
                     if status == 0{
                        self.scheduledTimerWithTimeInterval()
                         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
      //                   self.removeAllOverlays()
                         self.defaults1.set("0", forKey: "Check_User_For_Support_Condition")
                      
                     }
                     else if status == 1{
                         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                         SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language1 == "en" ? "OK" : "حسنا")
                         self.defaults1.set("1", forKey: "Check_User_For_Support_Condition")
      //                   self.removeAllOverlays()
                     
                     }else {
                         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                         SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language1 == "en" ? "OK" : "حسنا")
                         let deafults = UserDefaults.standard
                         deafults.set(nil, forKey: "Logoutstatus")
                         deafults.synchronize()
                         let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
                         self.navigationController?.pushViewController(Leaderboard, animated: true)
                     }
                 }
             }

      override func viewDidLoad() {
          super.viewDidLoad()
          
//          defaults1 = UserDefaults.standard
//          language1 = defaults1.value(forKey: "Language") as? String
//          user_Id1 = defaults1.integer(forKey: "UserIDGet")
//          deviceTocken1 = defaults1.value(forKey: "Devicetoken") as? NSString
//          roleId2 = defaults1.integer(forKey: "RoleId")
//          adminuserid1 = defaults1.integer(forKey: "AdminUserId")
//          role2 = defaults1.integer(forKey: "ROLE")
//          if identifierManager1.isAdvertisingTrackingEnabled {
//              deviceId1 = identifierManager1.advertisingIdentifier.uuidString
//          }
//        
//        if user_Id1 == nil {
//            
//        }else {
//        Parsing().HostGateCheckAccountStatus(Language: language1, UserID: user_Id1, RoleID: roleId2, DeviceID: deviceId1, Role: role2, AdminUserID: adminuserid1, device_id: deviceTocken1)
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//        }
//          
//        
         
          // Do any additional setup after loading the view.
      }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
         Parsing().HostGateCheckAccountStatus(Language: language1, UserID: user_Id1, RoleID: roleId2, DeviceID: deviceId1, Role: role2, AdminUserID: adminuserid1, device_id: deviceTocken1)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
      

      /*
      // MARK: - Navigation

      // In a storyboard-based application, you will often want to do a little preparation before navigation
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          // Get the new view controller using segue.destination.
          // Pass the selected object to the new view controller.
      }
      */

  }


