//
//  AddVisitirtypesviewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 15/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class AddVisitirtypesviewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var addtitleLbl: UILabel!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var name_ar_txt: UITextField!
    
    //MARK:- Variables
    var str_name:NSString!
    var str_name_ar:NSString!
    var defaults: UserDefaults!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var typeId:Int!
    var vistorType:String!
    var comtrype:String!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
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
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateaddVisitor(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: nil)
                
                GIFHUD.shared.dismiss()
                
            }
            else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("Addvisitortype"), object: nil)
                
                self.showAlertUpate(message: str_message)
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    func showAlertUpate(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.navigationController?.popViewController(animated: true)
            GIFHUD.shared.dismiss()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func HostGateGetVisitor(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetVisitorType"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                var reponse = NSDictionary()
                reponse = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(reponse)")
                
                self.nameTxt.text = reponse.value(forKey: "type") as? String
                self.name_ar_txt.text = reponse.value(forKey: "type_ar") as? String
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    @objc func HostGateUpdateVisitor(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("Updatevisitortype"), object: nil)
                GIFHUD.shared.dismiss()
                self.showAlertUpate(message: str_message)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        typeId = defaults.integer(forKey: "TYPEID")
        vistorType = defaults.value(forKey: "VISITTYPE") as? String
        comtrype = defaults.value(forKey: "RESCOM") as? String
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        nameTxt.delegate = self
        
        
        if vistorType == "Add" {
            self.addtitleLbl.text = language == "en" ? "Add Visitor Types" : "إضافة أنواع الزوار"
            self.submit_btn.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
        }else {
            self.addtitleLbl.text = language == "en" ? "Edit Visitor Types" : "تحرير أنواع الزوار"
            self.submit_btn.setTitle(language == "en" ? "UPDATE" : "تحديث", for: .normal)
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:10)
            Parsing().HostGateGetVisitorType(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, TypeId: typeId)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetVisitor), name: NSNotification.Name(rawValue: "HostGateGetVisitorType"), object: nil)
        }
        
        //MARK:- language Code Start
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        //GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.nameTxt.placeholder = language == "en" ? "Name(En)" : "الاسم (En)"
        self.name_ar_txt.placeholder = language == "en" ? "Name(Ar)" : "الاسم (ع)"
        if language .isEqual("en") || language .isEqual(""){
            self.nameTxt.textAlignment = .left
            self.name_ar_txt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.nameTxt.textAlignment = .right
            self.name_ar_txt.textAlignment = .right
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 50
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }
        else {
            return true
        }
    }
    
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    @IBAction func submiytBtnActyion(_ sender: Any) {
        
        if vistorType == "Add" {
            str_name = nameTxt.text as NSString?
            str_name_ar = name_ar_txt.text as NSString?
            if str_name .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name(en)." : "من فضلك ادخل الاسم (en)" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_name_ar.isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name(ar)." : "من فضلك ادخل الاسم (ar)" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_name.length < 3 || str_name.length > 50 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Name(en) should be 3 to 50" : "يجب أن يكون الاسم من 3 إلى 50" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                
                if self.comtrype == "Residential Complex"{
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:10)
                    Parsing().HostGateAddVisitorType(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, Type: str_name as String?, CommunityType: 1,type_ar: str_name_ar as String?)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateaddVisitor), name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: nil)
                }else {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:10)
                    Parsing().HostGateAddVisitorType(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, Type: str_name as String?, CommunityType: 2, type_ar: str_name_ar as String?)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateaddVisitor), name: NSNotification.Name(rawValue: "HostGateAddVisitorType"), object: nil)
                }
                
            }
        }else {
            str_name = nameTxt.text as NSString?
            str_name_ar = name_ar_txt.text as NSString?
            if str_name .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name(en)" : "من فضلك ادخل الاسم (en)", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_name_ar.isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name(ar)" : "من فضلك ادخل الاسم (ar)", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_name.length < 3 || str_name.length > 50 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Name should be 3 to 50" : "يجب أن يكون الاسم من 3 إلى 50" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else {
                
                if self.comtrype == "Residential Complex"{
                
//                showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:3)
                    Parsing().HostGateUpdateVisitorType(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, TypeId: typeId, Type: str_name as String?,type_ar: str_name_ar as String?, community_type: 1)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateVisitor), name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: nil)
                }else{
                    
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:3)
                    Parsing().HostGateUpdateVisitorType(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, TypeId: typeId, Type: str_name as String?,type_ar: str_name_ar as String?, community_type: 2)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateVisitor), name: NSNotification.Name(rawValue: "HostGateUpdateVisitorType"), object: nil)
                }
            }
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK:-DGLoclalization Delegate
extension AddVisitirtypesviewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
