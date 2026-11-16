//
//  AddAdminAccountsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CountryList
import AdSupport
import GiFHUD_Swift

class AddAdminAccountsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,CountryListDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtUniqueName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtCountryname: UITextField!
    @IBOutlet weak var txtPassportNo: UITextField!
    @IBOutlet weak var txtAssignRole: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var password_main_view: UIView!
    
    //MARK:- Variable
    
    var countryList = CountryList()
    var AssignRolePickerView: UIPickerView = UIPickerView()
    var userID = Int()
    var user_status = String()
    var str_UniqueName = String()
    var str_Username = String()
    var str_EmailAddress = String()
    var str_MobileNo = String()
    var str_CountryCode = String()
    var str_Countryname = String()
    var str_PassportNo = String()
    var str_AssignRole = [String]()
    var str_AssignRoleType = String()
    var str_Password = String()
    var defaults:UserDefaults!
    var deviceToken:String!
    var roleId:Int!
    var str:String!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    @IBOutlet weak var passwordHeihtCons: NSLayoutConstraint!
    var AddStaffFlag = Bool()
    
    var adminuserid:Int!
    var staff_id = String()
    var str1 = String()
    var strroleType:String!
    var rolety:String!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    //MARK:- Login WebService
      @objc func HostGateAccountStatusAction(_ notification: Notification) {
          let status = (notification.userInfo?["status"] as? Int)!
          let str_message = (notification.userInfo?["message"] as? String)!
          
          DispatchQueue.main.async() {
              
              if status == 0{
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                  self.removeAllOverlays()
                  self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
              }
              else if status == 1{
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                  self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                  self.removeAllOverlays()
                GIFHUD.shared.dismiss()
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
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        str = defaults.value(forKey: "Staff") as? String
        language = defaults.value(forKey: "Language") as? String
        
        if str == "Addstaff" {
            self.password_main_view.isHidden = false
            passwordHeihtCons.constant = 45
            self.titleLbl.text = language == "en" ? "Add Admin Account" : "إضافة حساب المسؤول"
            self.submit_btn.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
            self.txtUsername.isEnabled = true
        }else {
            self.password_main_view.isHidden = true
            self.titleLbl.text = language == "en" ? "Edit Admin Account" : "تحرير حساب المسؤول"
            self.submit_btn.setTitle(language == "en" ? "UPDATE" : "تحديث", for: .normal)
            self.txtUsername.isEnabled = false
            passwordHeihtCons.constant = 0
        }
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
         role = defaults.integer(forKey: "ROLE")
        
        // Do any additional setup after loading the view.
        countryList.delegate = self
        txtCountryname.delegate = self
        txtCountryCode.delegate = self
        txtUniqueName.delegate = self
        txtUsername.delegate = self
        txtEmailAddress.delegate = self
        txtPassportNo.delegate = self
        txtPassword.delegate = self
        txtMobileNo.delegate = self
        userID  = defaults.value(forKey: "UserIDGet") as! Int
        deviceToken =  defaults.value(forKey: "Devicetoken") as? String
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        AssignRolePickerView.delegate = self
        AssignRolePickerView.dataSource = self
        txtAssignRole.inputView = AssignRolePickerView
        
        if AddStaffFlag == true{
            
        }else{
            self.getStaffData_API()
        }
        
        //MARK:- language Code Start
        
        let one = language == "en" ? "Technical" : "تقني"
        let two = language == "en" ? "Financial" : "الأمور المالية"
        let three = language == "en" ? "Global" : "عالمي"
        
        str_AssignRole = [one, two, three]
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SelectCountry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("SelectCountry1"), object: nil)
        
        //GIFHUD.shared.show(withOverlay: true, duration:2)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: userID, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
    }
    
    //MARK:- language Function
    func decorate() {
        self.txtUniqueName.placeholder = language == "en" ? "Name" : "اسم"
        self.txtEmailAddress.placeholder = language == "en" ? "Email" : "البريد الإلكتروني"
        self.txtMobileNo.placeholder = language == "en" ? "Mobile Number" : "رقم الهاتف المحمول"
        self.txtCountryname.placeholder = language == "en" ? "Select Nationality" : "اختر الجنسية"
        self.txtPassportNo.placeholder = language == "en" ? "National ID/Passport Number" : "الرقم القومي / رقم جواز السفر"
        self.txtAssignRole.placeholder = language == "en" ? "Select Role" : "حدد الدور"
        self.txtUsername.placeholder = language == "en" ? "Username" : "اسم المستخدم";
        self.txtPassword.placeholder = language == "en" ? "Password" : "كلمه السر";
        if language .isEqual("en") || language .isEqual(""){
            self.txtUniqueName.textAlignment = .left
            self.txtEmailAddress.textAlignment = .left
            self.txtMobileNo.textAlignment = .left
            self.txtCountryname.textAlignment = .left
            self.txtPassportNo.textAlignment = .left
            self.txtAssignRole.textAlignment = .left
            self.txtUsername.textAlignment = .left
            self.txtPassword.textAlignment = .left
        }else if language .isEqual("ar") {
            self.txtUniqueName.textAlignment = .right
            self.txtEmailAddress.textAlignment = .right
            self.txtMobileNo.textAlignment = .right
            self.txtCountryname.textAlignment = .right
            self.txtPassportNo.textAlignment = .right
            self.txtAssignRole.textAlignment = .right
            self.txtUsername.textAlignment = .right
            self.txtPassword.textAlignment = .right
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtUniqueName {
            
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
        else if textField == txtUsername {
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
        else if textField == txtEmailAddress {
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
        }else if textField == txtMobileNo {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 15
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }
            
        else if textField == txtPassportNo {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 24
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }
        else if textField == txtPassword {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if txtAssignRole.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @objc func HostGateAddStaffAccountAction(_ notification: Notification) {
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        if status == 1{
            self.navigationController?.popViewController(animated: true)
        } else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddStaffNotification"), object: nil)
//        self.removeAllOverlays()
        GIFHUD.shared.dismiss()
    }
    
    //MARK:- IBAction
    @IBAction func backbtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getStaffData_API(){
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.staff_id), forKey: "staff_id" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getStaffData"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    let data = DataManager.getVal(responseData?.object(forKey: "data")) as! NSDictionary
                    let country_code = DataManager.getVal(data["country_code"]) as! String
                    let country_id_number = DataManager.getVal(data["country_id_number"]) as! String
                    let email = DataManager.getVal(data["email"]) as! String
                    let id_number = DataManager.getVal(data["id_number"]) as! String
                    let phone = DataManager.getVal(data["phone"]) as! String
                    self.str_AssignRoleType = (DataManager.getVal(data["role"]) as? String)!
                    let unique_name = DataManager.getVal(data["username"]) as! String
                    let username = DataManager.getVal(data["unique_name"]) as! String
                    
                    self.txtUniqueName.text = unique_name
                    let decodedString = country_code.removingPercentEncoding //Decode for (+)sign
                    self.txtCountryCode.text = decodedString
                    self.txtCountryname.text = country_id_number
                    self.txtEmailAddress.text = email
                    self.txtMobileNo.text = phone
                    self.txtUsername.text = username
                    self.txtPassportNo.text = id_number
                    
                    if self.str_AssignRoleType == "1" {
                        self.txtAssignRole.text = "Technical"
                    }else if self.str_AssignRoleType == "2"{
                        self.txtAssignRole.text = "Financial"
                    }else{
                        self.txtAssignRole.text = "Global"
                    }
                    
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            })
        }
    }
    
    
    
    //MARK:- API CALLING
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if user_status == "1" || user_status == "" {
            if self.AddStaffFlag == true {
                str_UniqueName = txtUniqueName.text ?? ""
                str_Username = txtUsername.text ?? ""
                str_EmailAddress = txtEmailAddress.text ?? ""
                str_MobileNo = txtMobileNo.text ?? ""
                str_CountryCode = txtCountryCode.text ?? ""
                str_Countryname = txtCountryname.text ?? ""
                str_PassportNo = txtPassportNo.text ?? ""
                strroleType = txtAssignRole.text ?? ""
                str_Password = txtPassword.text ?? ""
                
                if str_UniqueName.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name." : "من فضلك ادخل الاسم" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
//                    else if txtUniqueName.text!.count < 2 ||   txtUniqueName.text!.count > 50 {
//                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Name should be a 2 to 50" : "يجب أن يكون الاسم 2 لى 50" , buttonTitle: language == "en" ? "OK" : "حسنا")
//                }
                    else if str_EmailAddress.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if isValidEmail(str_EmailAddress) == false{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid email." : "الرجاء إدخال بريد إلكتروني صحيح" , buttonTitle: language == "en" ? "OK" : "حسنا")
                    return
                }else if str_CountryCode.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select country code." : "يرجى اختيار رمز البلد.", buttonTitle: "OK")
                }else if str_MobileNo.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if txtMobileNo.text!.count < 7 ||   txtMobileNo.text!.count > 15 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Mobile number must be 7-15 digit only." : "يجب أن يكون رقم الجوال من 7 إلى 15 رقمًا فقط." , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if str_Countryname.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter country name." : "الرجاء إدخال اسم البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if str_PassportNo.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter National ID / Passport Number." : "الرجاء إدخال الرقم القومي / رقم جواز السفر." , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if txtPassportNo.text!.count < 3 ||   txtPassportNo.text!.count > 24 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Passport number must be 3-21 characters only." : "يجب أن يكون رقم جواز السفر من 3 إلى 21 حرفًا فقط." , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                else if strroleType.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select role." : "يرجى اختيار الدور" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                else if str_Username.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter user name." : "الرجاء إدخال اسم المستخدم" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if txtUsername.text!.count < 3 ||   txtUsername.text!.count > 50 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "User name must be 3-50 characters only." : "يجب أن يكون اسم المستخدم 3-50 حرفًا فقط." , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                    
                    
                else if str_Password.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter password." : "من فضلك أدخل كلمة المرور" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if txtPassword.text!.count < 6 ||   txtPassword.text!.count > 16 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Password must be 6 to 16 characters" : "يجب أن تكون كلمة المرور من 6 إلى 16 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                else {
                    
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:25)
                    if txtCountryCode.text == "" {
                        txtCountryCode.text = "+20"
                    }else {
                        
                    }
                    let encoded__Question = self.txtCountryCode.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
                    let parameterDictionary = NSMutableDictionary()
                    parameterDictionary.setObject(DataManager.getVal(self.userID), forKey: "user_id" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.str_UniqueName), forKey: "username" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtUsername.text!), forKey: "unique_name" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtEmailAddress.text!), forKey: "email" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtMobileNo.text!), forKey: "phone" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(encoded__Question), forKey: "country_code" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtCountryname.text!), forKey: "country_id_number" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtPassportNo.text!), forKey: "id_number" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.str_AssignRoleType), forKey: "role" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal("en"), forKey: "language" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal("2"), forKey: "device_type" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.deviceToken), forKey: "device_id" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.roleId), forKey: "role_id" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.adminuserid), forKey: "admin_user_id" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.str_Password), forKey: "password" as NSCopying)
                    print(parameterDictionary)
                    
                    let methodName = "addStaff"
                    
                    DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                        
                        DispatchQueue.main.async(execute: {
                            
                            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                            
                            if status == "1" {
                                 NotificationCenter.default.post(name: NSNotification.Name("AddAdminAccount"), object: nil)
                                GIFHUD.shared.dismiss()
                                GIFHUD.shared.dismiss()
                                    self.showAlertUpdate(message: message)
                            }else{
                                GIFHUD.shared.dismiss()
                                GIFHUD.shared.dismiss()
                                     SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                            }
                        })
                        GIFHUD.shared.dismiss()
                    }
                    
                    //                    if Reachability.isConnectedToNetwork() == true {
                    //                        showWaitOverlay()
                    //
                    // Parsing().HostGateAddStaff(UniqueName: str_UniqueName, UserId: userID , Username: str_Username, Email: str_EmailAddress, Password: str_Password, CountryCode: str_CountryCode, CountryName: str_Countryname, PhoneNo: str_MobileNo, Role_Id: str_AssignRoleType, Language: "en", Passport_Number: str_PassportNo, DeviceType: "2", Device_ID: deviceToken as String?, RoleId: roleId, AdminuserId: adminuserid)
                    //
                    //                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddStaffNotification"), object: nil)
                    //                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAddStaffAccountAction), name: NSNotification.Name(rawValue: "HostGateAddStaffNotification"), object: nil)
                    //                    }else {
                    //                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Internet Connection not Available!" , buttonTitle: "OK")
                    //                    }
                }
                
                
            }else {
                str_UniqueName = txtUniqueName.text ?? ""
                str_Username = txtUsername.text ?? ""
                str_EmailAddress = txtEmailAddress.text ?? ""
                str_MobileNo = txtMobileNo.text ?? ""
                str_CountryCode = txtCountryCode.text ?? ""
                str_Countryname = txtCountryname.text ?? ""
                str_PassportNo = txtPassportNo.text ?? ""
                // str_AssignRoleType = txtAssignRole.text ?? ""
                str_Password = txtPassword.text ?? ""
                if str_UniqueName.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name!" : "من فضلك ادخل الاسم" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if txtUniqueName.text!.count < 2 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Name should be minimum 2 characters." : "يجب أن يكون الاسم 2 أحرف على الأقل." , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if str_EmailAddress.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email!" : "الرجاء إدخال البريد الإلكتروني!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if isValidEmail(str_EmailAddress) == false{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid email!" : "الرجاء إدخال بريد إلكتروني صحيح!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                    return
                } else if str_CountryCode.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select country code!" : "يرجى اختيار رمز البلد!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if str_MobileNo.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number!" : "الرجاء إدخال رقم الجوال!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if txtMobileNo.text!.count < 7 ||   txtMobileNo.text!.count > 15 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Mobile number should be 7 to 15 digit" : "يجب أن يكون رقم الجوال من 7 إلى 15 رقمًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if str_Countryname.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter country name!" : "الرجاء إدخال اسم البلد!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if str_PassportNo.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter passport number!" : "الرجاء إدخال رقم جواز السفر" , buttonTitle: language == "en" ? "OK" : "حسنا")
                } else if txtPassportNo.text!.count < 3 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Passport number should be minimum 3 characters." : "يجب أن يكون رقم جواز السفر 3 أحرف على الأقل." , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                else if str_AssignRoleType.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select role!" : "يرجى اختيار الدور!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                else if str_Username.isEqual(""){
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter user name!" : "الرجاء إدخال اسم المستخدم!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }else if txtUsername.text!.count < 3 {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "User name should be minimum 3 characters." : "يجب أن يكون اسم المستخدم 3 أحرف على الأقل." , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
                else {
                    
                    
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:25)
                    let encoded__Question = self.txtCountryCode.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
                    let parameterDictionary = NSMutableDictionary()
                    parameterDictionary.setObject(DataManager.getVal(self.userID), forKey: "user_id" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.str_UniqueName), forKey: "username" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.staff_id), forKey: "staff_id" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtUsername.text!), forKey: "unique_name" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtEmailAddress.text!), forKey: "email" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtMobileNo.text!), forKey: "phone" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(encoded__Question), forKey: "country_code" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtCountryname.text!), forKey: "country_id_number" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.txtPassportNo.text!), forKey: "id_number" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal(self.str_AssignRoleType), forKey: "role" as NSCopying)
                    parameterDictionary.setObject(DataManager.getVal("en"), forKey: "language" as NSCopying)
                    print(parameterDictionary)
                    
                    let methodName = "updateStaff"
                    
                    DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                        
                        DispatchQueue.main.async(execute: {
                            
                            let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                            let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                            
                            if status == "1" {
                                NotificationCenter.default.post(name: NSNotification.Name("UpdateAdminAccount"), object: nil)
                                GIFHUD.shared.dismiss()
                                GIFHUD.shared.dismiss()
                                    self.showAlertUpdate(message: message)
                            }else{
                                GIFHUD.shared.dismiss()
                                GIFHUD.shared.dismiss()
                                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                                
                            }
                        })
                        GIFHUD.shared.dismiss()
                    }
                }
            }
            
        }else if user_status == "2"{
            
        }else {
            
        }
        
    }
    
    func showAlertUpdate(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return str_AssignRole.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return str_AssignRole[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            txtAssignRole.text = str_AssignRole[row]
            str_AssignRoleType = "1"
        } else if row == 1 {
            txtAssignRole.text = str_AssignRole[row]
            str_AssignRoleType = "2"
        } else {
            txtAssignRole.text = str_AssignRole[row]
            str_AssignRoleType = "3"
        }
    }
    
    func countryNameOnly(){
        let fv = storyboard?.instantiateViewController(withIdentifier: "CountrySearchViewController")as! CountrySearchViewController
        self.navigationController?.present(fv, animated: true, completion: nil)
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        txtCountryname.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        txtCountryname.text = name
        
    }
    
    //MARK:- Textfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtAssignRole{
            //                 self.pickerView(AssignRolePickerView, titleForRow: 0, forComponent: 0)
        } else if textField == txtCountryCode {
            let navController = UINavigationController(rootViewController: countryList)
            self.present(navController, animated: true, completion: nil)
            self.view.endEditing(true)
        }else if textField == txtCountryname{
            self.countryNameOnly()
            self.view.endEditing(true)
        }
    }
    
    //MARK:- CountryListDelegate
    
    func selectedCountry(country: Country) {
        str_Countryname = (country.name! as NSString) as String
        self.txtCountryname.text = str_Countryname as String?
        self.txtCountryCode.text = "+\(country.phoneExtension)"
    }
}

//MARK:-DGLoclalization Delegate
extension AddAdminAccountsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}

