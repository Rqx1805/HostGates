//
//  ResetPasswordViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import GiFHUD_Swift

class ResetPasswordViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmpasswordTxt: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    var str_password:NSString!
    var str_ConPassword:NSString!
    var defaults:UserDefaults!
    var userId:Int!
    var roleId:Int!
    
    //MARK:- Update Password WebService
    @objc func UpdatePasswordAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResetPasswordNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResetPasswordNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        userId = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        
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
        self.passwordTxt.placeholder = language == "en" ? "Password" : "كلمه السر"
        self.confirmpasswordTxt.placeholder = language == "en" ? "Confirm password" : "تأكيد كلمة المرور"
        if language == "en" {
            self.submitBtn.setTitle("SUBMIT", for: .normal)
        }else if language == "ar" {
            self.submitBtn.setTitle("إرسال", for: .normal)
        }
        if language .isEqual("en") || language .isEqual(""){
            self.passwordTxt.textAlignment = .left
            self.confirmpasswordTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.passwordTxt.textAlignment = .right
            self.confirmpasswordTxt.textAlignment = .right
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        str_password = passwordTxt.text as NSString?
        str_ConPassword = confirmpasswordTxt.text as NSString?
        if str_password .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please Enter Password." : "من فضلك أدخل كلمة المرور" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else if str_ConPassword .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please Enter Confirm Password." : "الرجاء إدخال تأكيد كلمة المرور" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else if  str_password.length < 6 || str_password.length > 15 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Password should be in 6-15 length." : "يجب أن تكون كلمة المرور بطول 6-15" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
        else if (str_password != str_password) {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Password Are Not Matched." : "كلمة المرور غير متطابقة" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateResetPassword(Langauge: "en", UserId: userId, NewPassword: str_password as String?, RoleId: roleId)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResetPasswordNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.UpdatePasswordAction), name: NSNotification.Name(rawValue: "HostGateResetPasswordNotification"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
        }
    }
}

//MARK:-DGLoclalization Delegate
extension ResetPasswordViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
