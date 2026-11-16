//
//  VerifyViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/08/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import GiFHUD_Swift

class VerifyViewController: UIViewController,VPMOTPViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var OtpView: VPMOTPView!
    @IBOutlet weak var verifyTtlLbl: UILabel!
    @IBOutlet weak var codemailTxt: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var resndlbl: UILabel!
    @IBOutlet weak var otpBtn: UIButton!
    
    var GetotpString = String()
    var GetComeOtp = String()
    var defaults: UserDefaults!
    var user_Id: Int!
    var roleId:Int!
    var ForgotPasswordGet = String()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateVerify(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVerificationNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                self.navigationController?.pushViewController(vc, animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVerificationNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    //MARK:- ForgotPasswordStudent WebService
    @objc func HostGateResendOtp(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
            else{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GIFHUD.shared.setGif(named: "loader.gif")
        GetComeOtp = "00000"
        defaults = UserDefaults.standard
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        //MARK:- OTP View Text   ----- Start
        OtpView.otpFieldsCount = 4
        OtpView.delegate = self
        // Create the UI
        OtpView.initalizeUI()
        //END
        
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
        self.verifyTtlLbl.text = language == "en" ? "Verify OTP" : "تحقق مكتب المدعي العام"
        self.codemailTxt.text = language == "en" ? "Enter the verification code we just sent you on your email." : "أدخل رمز التحقق الذي أرسلناه للتو على بريدك الإلكتروني"
        self.resndlbl.text = language == "en" ? "Resend" : "إعادة إرسال"
        if language == "en" {
            self.verifyBtn.setTitle("VERIFY", for: .normal)
            self.otpBtn.setTitle("OTP", for: .normal)
            
        }else if language == "ar" {
            self.verifyBtn.setTitle("تحقق", for: .normal)
            self.otpBtn.setTitle("مكتب المدعي العام", for: .normal)
        }
        
    }
    
    //MARK:- OTP TextView Delegate  ---- Start
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
    }
    
    func enteredOTP(otpString: String) {
        GetotpString = otpString
        print("OTPString: \(otpString)")
    }
    
    @IBAction func bakBtbaction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func verifyBtnAction(_ sender: Any) {
        if !GetotpString.isEmpty {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGatesVerification(Language: self.language, UserId: user_Id, OTP: GetotpString, RoleId: roleId)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVerificationNotification"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVerify), name: NSNotification.Name(rawValue: "HostGateVerificationNotification"), object: nil)
            }
            else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
        }
        else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter OTP." : "تفضل مكتب المدعي العام" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
    }
    @IBAction func ResendOtpBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateResendotp(Language: self.language, UserId: user_Id, RoleId: roleId)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateResendOtp), name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
        
    }
    
}


//MARK:-DGLoclalization Delegate
extension VerifyViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
