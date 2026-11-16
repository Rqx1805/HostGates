//
//  ChangePasswordViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class ChangePasswordViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var submit_btn: UIButton!
    
    var str_currentPassword:NSString!
    var str_newPassword:NSString!
    var str_confirmPassword:NSString!
    var defaults:UserDefaults!
    var user_id:Int!
    var roleId:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var adminuserid:Int!
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    //MARK:- Update Password WebService
    @objc func ChangePasswordAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateChangePasswordNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
               
                self.showAlertChangePassword(message: str_message)
            }
        }
    }
    
    func showAlertChangePassword(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.currentPassword.text = ""
            self.newPassword.text = ""
            self.confirmPassword.text = ""
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateChangePasswordNotification"), object: nil)
            //                self.removeAllOverlays()
            GIFHUD.shared.dismiss()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Login WebService
    @objc func HostGateAccountStatusAction(_ notification: Notification) {
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                self.removeAllOverlays()
                self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
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
        defaults = UserDefaults.standard
        user_id = defaults.integer(forKey: "UserIDGet")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        roleId = defaults.integer(forKey: "RoleId")
        role = defaults.integer(forKey: "ROLE")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        //GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.newPassword.placeholder = language == "en" ? "New Password" : "كلمة المرور الحالية"
        self.currentPassword.placeholder = language == "en" ? "Current Password" : "كلمة مرور جديدة"
        self.confirmPassword.placeholder = language == "en" ? "Confirm Password" : "تأكيد كلمة المرور"
        if language == "en" {
            self.submit_btn.setTitle("SUBMIT", for: .normal)
        }else if language == "ar" {
            self.submit_btn.setTitle("إرسال", for: .normal)
        }
        if language .isEqual("en") || language .isEqual(""){
            self.newPassword.textAlignment = .left
            self.currentPassword.textAlignment = .left
            self.confirmPassword.textAlignment = .left
        }else if language .isEqual("ar") {
            self.newPassword.textAlignment = .right
            self.currentPassword.textAlignment = .right
            self.confirmPassword.textAlignment = .right
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func subMitBtnAction(_ sender: Any) {
        str_currentPassword = currentPassword.text as NSString?
        str_newPassword = newPassword.text as NSString?
        str_confirmPassword = confirmPassword.text as NSString?
        
        if str_currentPassword .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter current password." : "الرجاء إدخال كلمة المرور الحالية" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        } else if str_newPassword .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter new password." : "الرجاء إدخال كلمة مرور جديدة" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else if  str_newPassword.length < 6 || str_newPassword.length > 15 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Password should be in 6-15 length." : "يجب أن تكون كلمة المرور بطول 6-15" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
        else   if str_confirmPassword .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter confirm password." : "الرجاء إدخال تأكيد كلمة المرور" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
        else if (str_newPassword != str_confirmPassword) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Password are not matched." : "كلمة المرور غير متطابقة" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateChangePassword(Language: self.language, UserId: user_id, OldPassword: str_currentPassword as String?, NewPassword: str_newPassword as String?, RoleId: roleId)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateChangePasswordNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.ChangePasswordAction), name: NSNotification.Name(rawValue: "HostGateChangePasswordNotification"), object: nil)
            }else{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
        }
    }
    
}


//MARK:-DGLoclalization Delegate
extension ChangePasswordViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
