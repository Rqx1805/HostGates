//
//  AddEmployeeAccountViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CountryList
import AdSupport
import GiFHUD_Swift

class AddEmployeeAccountViewController: UIViewController,UITextFieldDelegate,CountryListDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var BuildingNumberTxtField: UITextField!
    @IBOutlet weak var UnitNumberTxtField: UITextField!
    @IBOutlet weak var UniqueNameTxtField: UITextField!
    @IBOutlet weak var IdNumberTxtField: UITextField!
    @IBOutlet weak var AssignGateTxtField: UITextField!
    @IBOutlet weak var NationalityTxtField: UITextField!
    @IBOutlet weak var EmailtxtField: UITextField!
    @IBOutlet weak var CountryCodeTxtField: UITextField!
    @IBOutlet weak var MobileNumberTxtField: UITextField!
    @IBOutlet weak var UsernametxtField: UITextField!
    @IBOutlet weak var PasswordTxtField: UITextField!
    @IBOutlet weak var passwordFiledHeightCons: NSLayoutConstraint!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var password_main_view: UIView!
    
    var roleId:Int!
    var adminuserid:Int!
    @IBOutlet weak var titleLbl: UILabel!
    // @IBOutlet weak var countryNameTxt: UITextField!
    var property_id = String()
    var community_type = String()
    var EditAndUpdateApiFlag = Bool()
    var IDarray:NSMutableArray!
    var countylist = CountryList()
    var str_Countryname:NSString!
    var defaults:UserDefaults!
    var str:String!
    var gate_ids = NSMutableArray()
    var slests:String!
    var selectAllSts:String!
    var newgt:String!
    var sendArr = [String]()
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var UserId:Int!
    var deviceTocken = NSString()
    
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
//                self.removeAllOverlays()
                self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        self.AssignGateTxtField.delegate = self
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        
        str = defaults.value(forKey: "RES") as? String
        slests = defaults.value(forKey: "SelSts") as? String
        if str == "res" {
            titleLbl.text = language == "en" ? "Add Residential Account" : "إضافة حساب سكني"
            self.submit_btn.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
            self.passwordFiledHeightCons.constant = 45
            self.password_main_view.isHidden = false
            self.UniqueNameTxtField.isUserInteractionEnabled = true
        }else {
            titleLbl.text = language == "en" ? "Edit Residential Account" : "تحرير حساب سكني"
            self.submit_btn.setTitle(language == "en" ? "UPDATE" : "تحديث", for: .normal)
            self.passwordFiledHeightCons.constant = 0
            self.password_main_view.isHidden = true
            self.UniqueNameTxtField.isUserInteractionEnabled = false
        }
        
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        defaults.removeObject(forKey: "NEWA")
        role = defaults.integer(forKey: "ROLE")
        UserId = defaults.integer(forKey: "UserIDGet")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        countylist.delegate = self
        CountryCodeTxtField.delegate = self
        BuildingNumberTxtField.delegate = self
        UnitNumberTxtField.delegate = self
        UniqueNameTxtField.delegate = self
        IdNumberTxtField.delegate = self
        NationalityTxtField.delegate = self
        EmailtxtField.delegate = self
        MobileNumberTxtField.delegate = self
        UsernametxtField.delegate = self
        PasswordTxtField.delegate = self
        let community_type = DataManager.getVal(Config().AppUserDefaults.value(forKey: "community_type")) as! String
        
        if community_type == "Residential Complex"{
            self.community_type = "1"
        }else{
            self.community_type = "2"
        }
        if EditAndUpdateApiFlag == true{
            self.getPropertyData_API()
        }else{
            
        }
        
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SelectCountry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("SelectCountry1"), object: nil)
        
       // GIFHUD.shared.show(withOverlay: true, duration:1)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: UserId, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.BuildingNumberTxtField.placeholder = self.language == "en" ? "Building Number" : "رقم المبنى"
        self.UnitNumberTxtField.placeholder = language == "en" ? "Unit/Floor Number" : "وحدة / رقم الطابق"
        self.AssignGateTxtField.placeholder = self.language == "en" ? "Assign Gate Account" : "تعيين حساب البوابة"
        self.UsernametxtField.placeholder = language == "en" ? "Owner Name" : "اسم المالك"
        self.NationalityTxtField.placeholder = language == "en" ? "Select Nationality" : "اختر الجنسية"
        self.IdNumberTxtField.placeholder = language == "en" ? "Unique Id" : "هوية مميزة";
        self.EmailtxtField.placeholder = language == "en" ? "Email" : "البريد الإلكتروني"
        self.MobileNumberTxtField.placeholder = language == "en" ? "Mobile Number" : "رقم الهاتف المحمول"
        self.UniqueNameTxtField.placeholder = self.language == "en" ? "Username" : "اسم المستخدم"
        self.PasswordTxtField.placeholder = language == "en" ? "Password" : "كلمه السر";
        if language .isEqual("en") || language .isEqual(""){
            self.BuildingNumberTxtField.textAlignment = .left
            self.UnitNumberTxtField.textAlignment = .left
            self.AssignGateTxtField.textAlignment = .left
            self.UsernametxtField.textAlignment = .left
            self.NationalityTxtField.textAlignment = .left
            self.IdNumberTxtField.textAlignment = .left
            self.EmailtxtField.textAlignment = .left
            self.MobileNumberTxtField.textAlignment = .left
            self.UniqueNameTxtField.textAlignment = .left
            self.PasswordTxtField.textAlignment = .left
        }else if language .isEqual("ar") {
            self.BuildingNumberTxtField.textAlignment = .right
            self.UnitNumberTxtField.textAlignment = .right
            self.AssignGateTxtField.textAlignment = .right
            self.UsernametxtField.textAlignment = .right
            self.NationalityTxtField.textAlignment = .right
            self.IdNumberTxtField.textAlignment = .right
            self.EmailtxtField.textAlignment = .right
            self.MobileNumberTxtField.textAlignment = .right
            self.UniqueNameTxtField.textAlignment = .right
            self.PasswordTxtField.textAlignment = .right
        }
        
    }
    
    func countryNameOnly(){
        let fv = storyboard?.instantiateViewController(withIdentifier: "CountrySearchViewController")as! CountrySearchViewController
        self.navigationController?.present(fv, animated: true, completion: nil)
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        NationalityTxtField.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        NationalityTxtField.text = name
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == CountryCodeTxtField {
            let navController = UINavigationController(rootViewController: countylist)
            self.present(navController, animated: true, completion: nil)
            self.view.endEditing(true)
        }else if textField == NationalityTxtField {
            self.countryNameOnly()
            self.view.endEditing(true)
        }else {
            
        }
    }
    
    //MARK:- CountryListDelegate
    
    func selectedCountry(country: Country) {
        str_Countryname = (country.name! as NSString) as NSString
        self.NationalityTxtField.text = str_Countryname as String?
        self.CountryCodeTxtField.text = "+\(country.phoneExtension)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == BuildingNumberTxtField {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 255
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        } else if textField == UnitNumberTxtField {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 255
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
        }
        else if textField == UniqueNameTxtField {
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
        else if textField == NationalityTxtField {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }
        else if textField == IdNumberTxtField {
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
        else if textField == EmailtxtField {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }else if textField == MobileNumberTxtField {
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
        else if textField == UsernametxtField {
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
        }else if textField == self.AssignGateTxtField{
            return false
        }else {
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        
        if EditAndUpdateApiFlag == true{
            if ValidationClass().ValidateResidentialComplexForm1(self){
                self.newgt = defaults.value(forKey: "NEWA") as? String
                var jsonArray:String!
                if self.newgt == "gate" {
                    jsonArray = self.JSONStringify(value: self.IDarray as AnyObject)
                    print(jsonArray!)
                }else {
                    jsonArray = self.JSONStringify(value: self.gate_ids as AnyObject)
                    print(jsonArray!)
                }
                
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:20)
                let encoded__Question = self.CountryCodeTxtField.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.property_id), forKey: "property_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.BuildingNumberTxtField.text!), forKey: "building_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UnitNumberTxtField.text!), forKey: "unit_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(jsonArray), forKey: "gate_ids" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UsernametxtField.text!), forKey: "name" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.IdNumberTxtField.text!), forKey: "id_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.NationalityTxtField.text!), forKey: "country_id_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.EmailtxtField.text!), forKey: "email" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(encoded__Question), forKey: "country_code" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.MobileNumberTxtField.text!), forKey: "phone" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.slests), forKey: "select_all_gate_status" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(""), forKey: "language" as NSCopying)
                print(parameterDictionary)
                
                let methodname = "updateProperty"
                DataManager.getAPIResponse(parameterDictionary,methodName: methodname, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            GIFHUD.shared.dismiss()
                            self.showAlertUpdate(message: message)
                        }else{
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                        }
//                        self.removeAllOverlays()
                        GIFHUD.shared.dismiss()
                    })
                }
                
            }
            
        }else{
            if ValidationClass().ValidateResidentialComplexForm(self){
                
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:20)
                
                let jsonArray = self.JSONStringify(value: self.IDarray as AnyObject)
                print(jsonArray)
                
                let UserIDGet = DataManager.getVal(Config().AppUserDefaults.value(forKey: "UserIDGet")) as! String
                let CommunityID = DataManager.getVal(Config().AppUserDefaults.value(forKey: "CommunityID")) as! String
                if CountryCodeTxtField.text == "" {
                    CountryCodeTxtField.text = "+20"
                }else {
                    
                }
                let encoded__Question = self.CountryCodeTxtField.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
                
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(UserIDGet), forKey: "user_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(CommunityID), forKey: "community_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.roleId), forKey: "role_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.adminuserid), forKey: "admin_user_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UniqueNameTxtField.text!), forKey: "unique_name" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.PasswordTxtField.text), forKey: "password" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.BuildingNumberTxtField.text!), forKey: "building_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UnitNumberTxtField.text!), forKey: "unit_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(jsonArray), forKey: "gate_ids" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UsernametxtField.text!), forKey: "name" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.IdNumberTxtField.text!), forKey: "id_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.NationalityTxtField.text!), forKey: "country_id_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.EmailtxtField.text!), forKey: "email" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(encoded__Question), forKey: "country_code" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.MobileNumberTxtField.text!), forKey: "phone" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.slests), forKey: "select_all_gate_status" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal("en"), forKey: "language" as NSCopying)
                print(parameterDictionary)
                
                
                let methodname = "addProperty"
                DataManager.getAPIResponse(parameterDictionary,methodName: methodname, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            GIFHUD.shared.dismiss()
                            self.showAlertUpdate(message: message)
                        }else{
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                        }
//                        self.removeAllOverlays()
                        GIFHUD.shared.dismiss()
                    })
                }
                
            }
            
        }
        
        
        
    }
    
    func showAlertUpdate(message: String) {
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
    
    func getPropertyData_API(){
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.property_id), forKey: "property_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.community_type), forKey: "community_type" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getPropertyData"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    let data = DataManager.getVal(responseData?.object(forKey: "data")) as! NSDictionary
                    self.gate_ids = DataManager.getVal(data["gate_ids"]) as! NSMutableArray
                    let building_number = DataManager.getVal(data["building_number"]) as! String
                    let unit_number = DataManager.getVal(data["unit_number"]) as! String
                    let unique_name = DataManager.getVal(data["unique_name"]) as! String
                    let id_number = DataManager.getVal(data["id_number"]) as! String
                    // let nationality = DataManager.getVal(data["nationality"]) as! String
                    let email = DataManager.getVal(data["email"]) as! String
                    let country_code = DataManager.getVal(data["country_code"]) as! String
                    let phone = DataManager.getVal(data["phone"]) as! String
                    let name = DataManager.getVal(data["name"]) as! String
                    let countryName = DataManager.getVal(data["country_id_number"]) as! String
                    self.selectAllSts = DataManager.getVal(data["select_all_gate_status"]) as? String
                    
                    self.BuildingNumberTxtField.text = building_number
                    self.UnitNumberTxtField.text = unit_number
                    self.UniqueNameTxtField.text = unique_name
                    self.IdNumberTxtField.text = id_number
                    self.NationalityTxtField.text = countryName
                    self.EmailtxtField.text = email
                    // self.countryNameTxt.text = countryName
                    let decodedString = country_code.removingPercentEncoding //Decode for (+)sign
                    self.CountryCodeTxtField.text =  decodedString
                    self.MobileNumberTxtField.text = phone
                    self.UsernametxtField.text = name
                    
                    if self.gate_ids.count == 0{
                        self.AssignGateTxtField.text = "0 Selected"
                    }else if self.gate_ids.count == 1{
                        self.AssignGateTxtField.text = "1 Selected"
                    }else if self.gate_ids.count == 2{
                        self.AssignGateTxtField.text = "2 Selected"
                    }else if self.gate_ids.count == 3{
                        self.AssignGateTxtField.text = "3 Selected"
                    }else if self.gate_ids.count == 4{
                        self.AssignGateTxtField.text = "4 Selected"
                    }else if self.gate_ids.count == 5{
                        self.AssignGateTxtField.text = "5 Selected"
                    }else if self.gate_ids.count == 6{
                        self.AssignGateTxtField.text = "6 Selected"
                    }else if self.gate_ids.count == 7{
                        self.AssignGateTxtField.text = "7 Selected"
                    }else if self.gate_ids.count == 8{
                        self.AssignGateTxtField.text = "8 Selected"
                    }else if self.gate_ids.count == 9{
                        self.AssignGateTxtField.text = "9 Selected"
                    }else{
                        self.AssignGateTxtField.text = "10 Selected"
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
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == AssignGateTxtField{
            //            self.view.endEditing(true)
            let defaults = UserDefaults.standard
            defaults.set(self.selectAllSts, forKey: "SELSTS")
            self.sendArr.removeAll()
            for i in 0..<gate_ids.count{
                self.sendArr.append(self.gate_ids[i] as! String)
                print(self.sendArr)
            }
            defaults.set(self.sendArr, forKey: "IDar")
            defaults.synchronize()
            let nextview = AssignGate.intitiateFromNib()
            
            let model = BackModel()
            
            nextview.buttonCheckAllHandler = {
                
            }
            
            nextview.buttonAssignHandler = {
                
                self.IDarray = nextview.select_type_array
                self.gate_ids.removeAllObjects()
                for i in 0..<nextview.select_type_array.count{
                    self.gate_ids.add(nextview.select_type_array[i])
                    print(self.gate_ids)
                }
                
                if nextview.select_type_array.count == 0{
                    self.AssignGateTxtField.text = "0 Selected"
                }else if nextview.select_type_array.count == 1{
                    self.AssignGateTxtField.text = "1 Selected"
                }else if nextview.select_type_array.count == 2{
                    self.AssignGateTxtField.text = "2 Selected"
                }else if nextview.select_type_array.count == 3{
                    self.AssignGateTxtField.text = "3 Selected"
                }else if nextview.select_type_array.count == 4{
                    self.AssignGateTxtField.text = "4 Selected"
                }else if nextview.select_type_array.count == 5{
                    self.AssignGateTxtField.text = "5 Selected"
                }else if nextview.select_type_array.count == 6{
                    self.AssignGateTxtField.text = "6 Selected"
                }else if nextview.select_type_array.count == 7{
                    self.AssignGateTxtField.text = "7 Selected"
                }else if nextview.select_type_array.count == 8{
                    self.AssignGateTxtField.text = "8 Selected"
                }else if nextview.select_type_array.count == 9{
                    self.AssignGateTxtField.text = "9 Selected"
                }else{
                    self.AssignGateTxtField.text = "10 Selected"
                }
                model.closewithAnimation()
            }
            nextview.buttonCrossHandler = {
                model.closewithAnimation()
            }
            model.show(view: nextview)
            return false
            
        }else{
            return true
        }
        
    }
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
        
    }
    
}
extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}


//MARK:-DGLoclalization Delegate
extension AddEmployeeAccountViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}


