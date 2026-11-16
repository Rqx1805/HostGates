//
//  AdminLoginViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift
import SafariServices

class AdminLoginViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,SFSafariViewControllerDelegate {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var CommunityView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var passwordview: UIView!
    
    @IBOutlet weak var admintxt: UITextField!
    
    @IBOutlet weak var countrytxt: UITextField!
    @IBOutlet weak var communitytxt: UITextField!
    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var adminviewheightConstarint: NSLayoutConstraint!
    @IBOutlet weak var countryviewheightconstarint: NSLayoutConstraint!
    @IBOutlet weak var communityviewheilgytconstraint: NSLayoutConstraint!
    @IBOutlet weak var usernametopview: NSLayoutConstraint!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var remeberMeLbl: UILabel!
    @IBOutlet weak var restrationBtn: UIButton!
    @IBOutlet weak var forgotuserPassword: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    var str_username:NSString!
    var str_password:NSString!
    var str_country: NSString!
    var str_community: NSString!
    var SuperAdmin = ["Business Owner","Admin","User","Gate"]
    var ChangeString = String()
    var SuperAdminPickerView: UIPickerView = UIPickerView()
    var CountryPickerView: UIPickerView = UIPickerView()
    var user_status:String!
    var str_selUser:NSString!
    var defaults:UserDefaults!
    var deviceTocken:NSString!
    var UserIDGet: Int!
    var rememberMe: Bool = false
    var str_email:String!
    var string = String()
    var roleId:Int!
    var AdminUserId:Int!
    var role:Int!
    var usests:String!
    var countryArray = NSMutableArray()
    var countryname = NSArray()
    var name:String!
    var commnityId:Int!
    var communityuType:Int!
    var username:String!
    var str:String!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    //MARK:- Login WebService
    @objc func HostGateLoginAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                let verified_status = response.value(forKey: "verified_status") as? Int
                
                if verified_status == 2{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }else{
                    self.UserIDGet = response.value(forKey: "user_id") as? Int
                    self.role = response.value(forKey: "role") as? Int
                    self.str_email = response.value(forKey: "email") as? String
                    self.roleId = response.value(forKey: "role_id") as? Int
                    self.AdminUserId = response.value(forKey: "admin_user_id") as? Int
                    self.commnityId = response.value(forKey: "community_id") as? Int
                    self.communityuType = response.value(forKey: "community_type") as? Int
                    self.username = response.value(forKey: "username") as? String
                    //\\ self.admintxt.text = "Admin"
                    let deafults = UserDefaults.standard
                    deafults.set(self.UserIDGet, forKey: "UserIDGet")
                    deafults.set(self.AdminUserId, forKey: "AdminUserId")
                    deafults.set(self.roleId, forKey: "RoleId")
                    deafults.set(self.str_email, forKey: "Email")
                    deafults.set(self.admintxt.text, forKey: "Role")
                    deafults.set(self.role, forKey: "ROLE")
                    deafults.synchronize()
//                    self.removeAllOverlays()
                    GIFHUD.shared.dismiss()
                    GIFHUD.shared.dismiss()
                    
                    if self.user_status == "1" || self.user_status == "" {
                        if self.rememberMe == true{
                            self.admintxt.text = "Business Owner"
                            let defaults = UserDefaults.standard
                            deafults.set("yes", forKey: "isRemember")
                            defaults.set(self.usernametxt.text!, forKey: "user_email")
                            defaults.set(self.passwordtxt.text!, forKey: "user_password")
                            deafults.set(self.admintxt.text, forKey: "Role")
                            
                        }else{
                            deafults.set("no", forKey: "isRemember")
                            
                        }
                        
                        let deafults = UserDefaults.standard
                        deafults.set("1", forKey: "Logoutstatus")
                        deafults.set(self.roleId, forKey: "RoleId")
                        deafults.synchronize()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")
                        self.navigationController?.pushViewController(vc!, animated: true)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                    }
                    else if self.user_status == "2" {
                        if self.role == 1 {
                            if self.rememberMe == true{
                                self.admintxt.text = "Admin"
                                let defaults = UserDefaults.standard
                                deafults.set("yes", forKey: "isRemember")
                                defaults.set(self.usernametxt.text!, forKey: "user_email1")
                                defaults.set(self.passwordtxt.text!, forKey: "user_password1")
                                deafults.set(self.admintxt.text, forKey: "Role")
                                
                            }else{
                                deafults.set("no", forKey: "isRemember")
                                
                            }
                            let deafults = UserDefaults.standard
                            deafults.set("1", forKey: "Logoutstatus")
                            deafults.set(self.roleId, forKey: "RoleId")
                            deafults.synchronize()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                            self.navigationController?.pushViewController(vc, animated: true)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                        }else if self.role == 2 {
                            if self.rememberMe == true{
                                self.admintxt.text = "Admin"
                                let defaults = UserDefaults.standard
                                deafults.set("yes", forKey: "isRemember")
                                defaults.set(self.usernametxt.text!, forKey: "user_email1")
                                defaults.set(self.passwordtxt.text!, forKey: "user_password1")
                                deafults.set(self.admintxt.text, forKey: "Role")
                                
                            }else{
                                deafults.set("no", forKey: "isRemember")
                                
                            }
                            let deafults = UserDefaults.standard
                            deafults.set("1", forKey: "Logoutstatus")
                            deafults.set(self.roleId, forKey: "RoleId")
                            deafults.synchronize()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinDashboardViewController") as! FinDashboardViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                        }else {
                            if self.rememberMe == true{
                                self.admintxt.text = "Admin"
                                let defaults = UserDefaults.standard
                                deafults.set("yes", forKey: "isRemember")
                                defaults.set(self.usernametxt.text!, forKey: "user_email1")
                                defaults.set(self.passwordtxt.text!, forKey: "user_password1")
                                deafults.set(self.admintxt.text, forKey: "Role")
                                
                            }else{
                                deafults.set("no", forKey: "isRemember")
                                
                            }
                            let deafults = UserDefaults.standard
                            deafults.set("1", forKey: "Logoutstatus")
                            deafults.set(self.roleId, forKey: "RoleId")
                            deafults.synchronize()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")
                            self.navigationController?.pushViewController(vc!, animated: true)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                        }
                        
                    }else if self.user_status == "3" {
                        if self.rememberMe == true{
                            self.admintxt.text = "User"
                            let defaults = UserDefaults.standard
                            deafults.set("yes", forKey: "isRemember")
                            defaults.set(self.usernametxt.text!, forKey: "user_email2")
                            defaults.set(self.passwordtxt.text!, forKey: "user_password2")
                            defaults.set(self.countrytxt.text!, forKey: "Country")
                            defaults.set(self.communitytxt.text!, forKey: "Community")
                            deafults.set(self.admintxt.text, forKey: "Role")
                            
                        }else{
                            deafults.set("no", forKey: "isRemember")
                            
                        }
                        let deafults = UserDefaults.standard
                        deafults.set("1", forKey: "Logoutstatus")
                        deafults.set(self.roleId, forKey: "RoleId")
                        deafults.set( self.commnityId, forKey: "COMNEWID")
                        deafults.set( self.communityuType, forKey: "COMTYPE")
                        deafults.synchronize()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserLoginNotification"), object: nil)
                    }
                    else if self.user_status == "4" {
                        if self.rememberMe == true{
                            self.admintxt.text = "Gate"
                            let defaults = UserDefaults.standard
                            deafults.set("yes", forKey: "isRemember")
                            defaults.set(self.usernametxt.text!, forKey: "user_email3")
                            defaults.set(self.passwordtxt.text!, forKey: "user_password3")
                            defaults.set(self.countrytxt.text!, forKey: "Country1")
                            defaults.set(self.communitytxt.text!, forKey: "Community1")
                            deafults.set(self.admintxt.text, forKey: "Role")
                            
                        }else{
                            deafults.set("no", forKey: "isRemember")
                            
                        }
                        let deafults = UserDefaults.standard
                        deafults.set("1", forKey: "Logoutstatus")
                        deafults.set(self.roleId, forKey: "RoleId")
                        deafults.set( self.commnityId, forKey: "COMNEWID")
                        deafults.set(self.username, forKey: "Name")
                        deafults.set( self.communityuType, forKey: "COMTYPE")
                        deafults.synchronize()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GateHomeViewController") as! GateHomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGteLoginNotification"), object: nil)
                        
                    }
                }
                
                
            }
        }
    }
    
    
    //MARK:- Login WebService
    @objc func HostGateGetCountryList(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                self.countryArray.removeAllObjects()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.countryArray = (notification.userInfo?["country"] as? NSMutableArray)!
                print("response: \(String(describing: self.countryArray))")
                self.countryname = self.countryArray.value(forKey: "name") as! NSArray
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
         language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as? NSString
        user_status = defaults.value(forKey: "User_Status") as? String

        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
            
        }
        
        if language == "en"{
            self.SuperAdmin = ["Business Owner","Admin","User","Gate"]
        }else{
            self.SuperAdmin = ["صاحب العمل","مسؤول","مستخدم","بوابة"]
        }
        
        if let is_remember = defaults.value(forKey: "isRemember") as? String{
            
            if is_remember == "yes"{
                str = defaults.value(forKey: "Role") as? String
                
                if str == "Business Owner" {
                    self.countryView.isHidden = true
                    countryviewheightconstarint.constant = 0
                    communityviewheilgytconstraint.constant = 0
                    usernametopview.constant = -10
                    let user_email = defaults.value(forKey: "user_email")
                    let user_password = defaults.value(forKey: "user_password")
                    
                    self.usernametxt.text = user_email as? String
                    self.passwordtxt.text = user_password as? String
                    self.admintxt.text = language == "en" ? defaults.value(forKey: "Role") as! String : "صاحب العمل"
                }else if  str == "Admin"{
                    self.countryView.isHidden = true
                    countryviewheightconstarint.constant = 0
                    communityviewheilgytconstraint.constant = 0
                    usernametopview.constant = -10
                    let user_email1 = defaults.value(forKey: "user_email1")
                    let user_password1 = defaults.value(forKey: "user_password1")
                    
                    self.usernametxt.text = user_email1 as? String
                    self.passwordtxt.text = user_password1 as? String
                    self.admintxt.text = language == "en" ? defaults.value(forKey: "Role") as! String : "مشرف"
                }else if str == "User" {
                    countryviewheightconstarint.constant = 45
                    communityviewheilgytconstraint.constant = 45
                    usernametopview.constant = 10
                    
                    let user_email1 = defaults.value(forKey: "user_email2")
                    let user_password1 = defaults.value(forKey: "user_password2")
                    let Country = defaults.value(forKey: "Country")
                    let Community = defaults.value(forKey: "Community")
                    
                    self.usernametxt.text = user_email1 as? String
                    self.passwordtxt.text = user_password1 as? String
                    self.countrytxt.text = Country as? String
                    self.communitytxt.text = Community as? String
                    self.admintxt.text = language == "en" ? defaults.value(forKey: "Role") as! String : "المستعمل"
                }else {
                    countryviewheightconstarint.constant = 45
                    communityviewheilgytconstraint.constant = 45
                    usernametopview.constant = 10
                    
                    let user_email1 = defaults.value(forKey: "user_email3")
                    let user_password1 = defaults.value(forKey: "user_password3")
                    let Country = defaults.value(forKey: "Country1")
                    let Community = defaults.value(forKey: "Community1")
                    
                    self.usernametxt.text = user_email1 as? String
                    self.passwordtxt.text = user_password1 as? String
                    self.countrytxt.text = Country as? String
                    self.communitytxt.text = Community as? String
                    self.admintxt.text = language == "en" ? defaults.value(forKey: "Role") as! String : "بوابة"
                }
                
                
                
                self.checkBtn.isSelected = true
                checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
                self.rememberMe = true
            }
            
        }
        SuperAdminPickerView.delegate = self
        SuperAdminPickerView.dataSource = self
        admintxt.inputView = SuperAdminPickerView
        
        CountryPickerView.delegate = self
        CountryPickerView.dataSource = self
        countrytxt.inputView = CountryPickerView
        
        
        admintxt.delegate = self
        countrytxt.delegate = self
        passwordtxt.delegate = self
        
        if user_status == "1" {
            self.countryView.isHidden = true
            countryviewheightconstarint.constant = 0
            communityviewheilgytconstraint.constant = 0
            usernametopview.constant = -10
        }else if user_status == "2"{
            self.countryView.isHidden = true
            countryviewheightconstarint.constant = 0
            communityviewheilgytconstraint.constant = 0
            usernametopview.constant = -10
        }else if user_status == "3" {
            countryviewheightconstarint.constant = 45
            communityviewheilgytconstraint.constant = 45
            usernametopview.constant = 10
        }else if user_status == "4" {
            countryviewheightconstarint.constant = 45
            communityviewheilgytconstraint.constant = 45
            usernametopview.constant = 10
        }else {
            countryviewheightconstarint.constant = 0
            communityviewheilgytconstraint.constant = 0
            usernametopview.constant = -10
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Search", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.SearchPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        countrytxt.inputAccessoryView = toolBar
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SelectCountry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("SelectCountry1"), object: nil)
        
        
        Parsing().GetCountryList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetCountryList), name: NSNotification.Name(rawValue: "GetCountryListNotification"), object: nil)
        
        //MARK:- language Code Start
        
        if language == "en" {
            self.restrationBtn.setTitle("Registration", for: .normal)
            self.loginBtn.setTitle("LOGIN", for: .normal)
            self.forgotuserPassword.setTitle("Forgot Username/Password?", for: .normal)
        }else if language == "ar" {
            self.restrationBtn.setTitle("التسجيل", for: .normal)
            self.loginBtn.setTitle("تسجيل الدخول", for: .normal)
            self.forgotuserPassword.setTitle("نسيت اسم المستخدم / كلمة المرور؟", for: .normal)
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    
    
    //MARK:- language Function
    func decorate() {
        self.loginLbl.text = language == "en" ? "Login" : "تسجيل الدخول"
        if language .isEqual("en") || language .isEqual(""){
            self.admintxt.textAlignment = .left
            self.countrytxt.textAlignment = .left
            self.communitytxt.textAlignment = .left
            self.usernametxt.textAlignment = .left
            self.passwordtxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.admintxt.textAlignment = .right
            self.countrytxt.textAlignment = .right
            self.communitytxt.textAlignment = .right
            self.usernametxt.textAlignment = .right
            self.passwordtxt.textAlignment = .right
        }
        self.admintxt.placeholder = language == "en" ? "Select User Type" : "حدد نوع المستخدم"
        self.countrytxt.placeholder = language == "en" ? "Select Country" : "حدد الدولة"
        self.communitytxt.placeholder = language == "en" ? "Community unique name" : "الاسم المميز للمجتمع"
        self.usernametxt.placeholder = language == "en" ? "Username" : "اسم المستخدم"
        self.passwordtxt.placeholder = language == "en" ? "Password" : "كلمه السر"
        self.remeberMeLbl.text = language == "en" ? "Remember Me" : "تذكرنى"
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        name = defaults.value(forKey: "COUNTRYNAME") as? String
        countrytxt.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        name = defaults.value(forKey: "COUNTRYNAME") as? String
        countrytxt.text = name
        
    }
    
    @objc func donePicker (sender:UIBarButtonItem)
    {
        self.view.endEditing(true)
        // Put something here
    }
    
    @objc func SearchPicker (sender:UIBarButtonItem)
    {
        let fv = storyboard?.instantiateViewController(withIdentifier: "CountrySearchViewController")as! CountrySearchViewController
        self.navigationController?.present(fv, animated: true, completion: nil)
        // Put something here
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == admintxt{
            if admintxt.text == "" {
                self.pickerView(SuperAdminPickerView, didSelectRow: 0, inComponent: 0)
            }else if admintxt.text == "Business Owner" {
                self.pickerView(SuperAdminPickerView, didSelectRow: 0, inComponent: 0)
            }else {
                
            }
            
        }
    }
    
    
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == SuperAdminPickerView{
            return SuperAdmin.count
        }else{
            return countryname.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == SuperAdminPickerView {
            return SuperAdmin[row]
        }else {
            return countryname[row] as? String
        }
    }
    
   
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == SuperAdminPickerView {
            if row == 0 {
                countryviewheightconstarint.constant = 0
                countryView.isHidden = true
                communityviewheilgytconstraint.constant = 0
                usernametopview.constant = -10
                admintxt.text =  SuperAdmin[row]
                user_status = "1"
                
                let user_email = defaults.value(forKey: "user_email")
                let user_password = defaults.value(forKey: "user_password")
                
                self.usernametxt.text = user_email as? String
                self.passwordtxt.text = user_password as? String
                string = "Business Owner"
                let defaults = UserDefaults.standard
                defaults.set(user_status, forKey: "User_Status")
                defaults.set(string, forKey: "Role")
                defaults.synchronize()
            }else if row == 1 {
                countryviewheightconstarint.constant = 0
                countryView.isHidden = true
                communityviewheilgytconstraint.constant = 0
                usernametopview.constant = -10
                admintxt.text = SuperAdmin[row]
                // usernametxt.text = ""
                // passwordtxt.text = ""
                user_status = "2"
                string = "Admin"
                let user_email = defaults.value(forKey: "user_email1")
                let user_password = defaults.value(forKey: "user_password1")
                
                self.usernametxt.text = user_email as? String
                self.passwordtxt.text = user_password as? String
                let defaults = UserDefaults.standard
                defaults.set(user_status, forKey: "User_Status")
                defaults.set(string, forKey: "Role")
                defaults.synchronize()
            }else if row == 2 {
                countryviewheightconstarint.constant = 45
                countryView.isHidden = false
                communityviewheilgytconstraint.constant = 45
                usernametopview.constant = 10
                admintxt.text =  SuperAdmin[row]
                user_status = "3"
                
                let user_email = defaults.value(forKey: "user_email2")
                let user_password = defaults.value(forKey: "user_password2")
                let Country = defaults.value(forKey: "Country")
                let Community = defaults.value(forKey: "Community")
                
                self.usernametxt.text = user_email as? String
                self.passwordtxt.text = user_password as? String
                self.countrytxt.text = Country as? String
                self.communitytxt.text = Community as? String
                string = "User"
                let defaults = UserDefaults.standard
                defaults.set(user_status, forKey: "User_Status")
                defaults.set(string, forKey: "Role")
                defaults.synchronize()
                
                //                usernametxt.text = ""
                //                passwordtxt.text = ""
                //
                
            }else {
                countryviewheightconstarint.constant = 45
                countryView.isHidden = false
                communityviewheilgytconstraint.constant = 45
                usernametopview.constant = 10
                admintxt.text =  SuperAdmin[row]
                // usernametxt.text = ""
                // passwordtxt.text = ""
                let user_email = defaults.value(forKey: "user_email3")
                let user_password = defaults.value(forKey: "user_password3")
                let Country = defaults.value(forKey: "Country1")
                let Community = defaults.value(forKey: "Community1")
                
                self.usernametxt.text = user_email as? String
                self.passwordtxt.text = user_password as? String
                self.countrytxt.text = Country as? String
                self.communitytxt.text = Community as? String
                
                user_status = "4"
                string = "Gate"
                let defaults = UserDefaults.standard
                defaults.set(user_status, forKey: "User_Status")
                defaults.set(string, forKey: "Role")
                defaults.synchronize()
            }
        }else {
            //  let fv = storyboard?.instantiateViewController(withIdentifier: "CountrySearchViewController")as! CountrySearchViewController
            
            // fv.name = countryname[row] as? String
            
            // self.navigationController?.present(fv, animated: true, completion: nil)
            countrytxt.text = countryname[row] as? String
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    @IBAction func ownerBtnAction(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.openURL(NSURL(string: "http://turnx.co/")! as URL)
        }
    }
    
    //Copy Code for single textfiled
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == admintxt{
            return false //prevents editing\
        }else if textField == countrytxt{
            return false
        }
        return true
    }
    
    
    @IBAction func forgotpasswordBtnAction(_ sender: Any) {
        if #available(iOS 10.0, *) {
            // check if website exists
             guard let url = URL(string: "https://hostgates.co/users/signup") else {
                 return
             }

             let safariVC = SFSafariViewController(url: url)
             safariVC.delegate = self
             present(safariVC, animated: true, completion: nil)
           // UIApplication.shared.openURL(NSURL(string: "https://hostgates.co/users/signup")! as URL)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotUsernameBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotUserNameViewController") as! ForgotUserNameViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtbAction(_ sender: Any) {
        if user_status == "1" {
            self.defaults.set("Empty", forKey: "Check_User_For_Support_Condition_1")
            str_selUser = admintxt.text as NSString?
            str_username = usernametxt.text as NSString?
            str_password = passwordtxt.text as NSString?
            if str_selUser .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم." , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_username .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_password .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if Reachability.isConnectedToNetwork() == true {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:15)
                    Parsing().HostGateLogin(Language: self.language, Username: str_username as String?, Password: str_password as String?, Role_Id: 2, DeviceType: "2", Device_ID:deviceId, device_id: deviceTocken)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLoginAction), name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }else if user_status == "2" {
            self.defaults.set("Admin", forKey: "Check_User_For_Support_Condition_1")
            str_selUser = admintxt.text as NSString?
            str_username = usernametxt.text as NSString?
            str_password = passwordtxt.text as NSString?
            if str_selUser .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم.", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_username .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_password .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور"  , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if Reachability.isConnectedToNetwork() == true {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:15)
                    Parsing().HostGateLogin(Language: self.language, Username: str_username as String?, Password: str_password as String?, Role_Id: 3, DeviceType: "2", Device_ID: deviceId, device_id: deviceTocken)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLoginAction), name: NSNotification.Name(rawValue: "HostGateLoginNotification"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }else if user_status == "3"  {
            self.defaults.set("User", forKey: "Check_User_For_Support_Condition_1")
            str_selUser = admintxt.text as NSString?
            str_username = usernametxt.text as NSString?
            str_password = passwordtxt.text as NSString?
            str_country = countrytxt.text as NSString?
            str_community = communitytxt.text as NSString?
            
            if str_selUser .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم.", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_country .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select country." : "يرجى اختيار البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_community .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter community." : "يرجى إدخال المجتمع" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else if str_username .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_password .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else {
                if Reachability.isConnectedToNetwork() == true {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:15)
                    Parsing().HostGateUserLogin(Language: self.language, Country: str_country as String?, Community: str_community as String?, Username: str_username as String?, Password: str_password as String?, Role_Id: 4, DeviceType: "2", Device_ID: deviceId, device_id: deviceTocken)
                    //  HostGateLogin(Language: "en", Username: str_username as String?, Password: str_password as String?, Role_Id: 3, DeviceType: "2", Device_ID: deviceTocken as String?)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserLoginNotification"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLoginAction), name: NSNotification.Name(rawValue: "HostGateUserLoginNotification"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
            
        }else if user_status == "4" {
            self.defaults.set("Empty", forKey: "Check_User_For_Support_Condition_1")
            str_selUser = admintxt.text as NSString?
            str_username = usernametxt.text as NSString?
            str_password = passwordtxt.text as NSString?
            str_country = countrytxt.text as NSString?
            str_community = communitytxt.text as NSString?
            
            if str_selUser .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم.", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_country .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select country." : "يرجى اختيار البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_community .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter community." : "يرجى إدخال المجتمع" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else if str_username .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_password .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else {
                if Reachability.isConnectedToNetwork() == true {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:15)
                    Parsing().HostGateGteLogin(Language: self.language, Country: str_country as String?, Community: str_community as String?, Username: str_username as String?, Password: str_password as String?, Role_Id: 5, DeviceType: "2", Device_ID: deviceId, device_id: deviceTocken)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGteLoginNotification"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLoginAction), name: NSNotification.Name(rawValue: "HostGateGteLoginNotification"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }
    }
    @IBAction func rememberBtnAction(_ sender: UIButton) {
        if sender.isSelected == true {
            self.rememberMe = false
            sender.isSelected = false
            checkBtn.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
            if str == "Business Owner" {
                defaults.set("", forKey: "user_email")
                defaults.set("", forKey: "user_password")
            }else if str == "Admin"{
                defaults.set("", forKey: "user_email1")
                defaults.set("", forKey: "user_password1")
            }else if str == "User"{
                defaults.set("", forKey: "user_email2")
                defaults.set("", forKey: "user_password2")
                defaults.set("", forKey: "Country")
                defaults.set("", forKey: "Community")
            }else{
                defaults.set("", forKey: "user_email3")
                defaults.set("", forKey: "user_password3")
                defaults.set("", forKey: "Country1")
                defaults.set("", forKey: "Community1")
            }
        }else{
            checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
            self.rememberMe = true
            sender.isSelected = true
            
        }
    }
}

//MARK:-DGLoclalization Delegate
extension AdminLoginViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}



//extension UITextField {
//
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return false
//    }
//}
