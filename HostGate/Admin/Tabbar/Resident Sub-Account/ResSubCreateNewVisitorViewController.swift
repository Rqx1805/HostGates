//
//  ResSubCreateNewVisitorViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class ResSubCreateNewVisitorViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var countTxt: UITextField!
    @IBOutlet weak var visitor_nameTxt: UITextField!
    @IBOutlet weak var visitor_typeTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var update_Btn: UIButton!
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var deviceId = String()
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceTocken = NSString()
    
    //MARK:- Login WebService
     @objc func HostGateAccountStatusAction(_ notification: Notification) {
         let status = (notification.userInfo?["status"] as? Int)!
         let str_message = (notification.userInfo?["message"] as? String)!
         
         DispatchQueue.main.async() {
             
             if status == 0{
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                 self.removeAllOverlays()
                 self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
             }
             else if status == 1{
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                 self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                 self.removeAllOverlays()
                GIFHUD.shared.dismiss()
             }else {
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
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
        GIFHUD.shared.setGif(named: "loader.gif")
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        if language == "en" {
            self.update_Btn.setTitle("UPDATE", for: .normal)
            self.countTxt.textAlignment = .left
            self.visitor_nameTxt.textAlignment = .left
            self.visitor_typeTxt.textAlignment = .left
            self.dateTxt.textAlignment = .left
            self.timeTxt.textAlignment = .left
        }else if language == "ar" {
            self.update_Btn.setTitle("تحديث", for: .normal)
            self.countTxt.textAlignment = .right
            self.visitor_nameTxt.textAlignment = .right
            self.visitor_typeTxt.textAlignment = .right
            self.dateTxt.textAlignment = .right
            self.timeTxt.textAlignment = .right
        }
        
        self.titlelbl.text = language == "en" ? "Create Visitor Record" : "إنشاء سجل الزوار"
        self.countTxt.placeholder = language == "en" ? "Count" : "العدد"
        self.visitor_nameTxt.placeholder = language == "en" ? "Visitor name" : "اسم الزائر"
        self.visitor_typeTxt.placeholder = language == "en" ? "Visitor type" : "أنواع الزوار"
        self.dateTxt.placeholder = language == "en" ? "Date" : "تاريخ"
        self.timeTxt.placeholder = language == "en" ? "Time" : "زمن"
        
       // GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateBtnAction(_ sender: Any) {
    }
    
}
