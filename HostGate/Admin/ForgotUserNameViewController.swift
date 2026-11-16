//
//  ForgotUserNameViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 24/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import GiFHUD_Swift

class ForgotUserNameViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //MARK:- IBOutlet
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var selectloginTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var communityTxt: UITextField!
    @IBOutlet weak var communityHeightCons: NSLayoutConstraint!
    @IBOutlet weak var countryHeightCons: NSLayoutConstraint!
    @IBOutlet weak var emailviewTopCons: NSLayoutConstraint!
    @IBOutlet weak var forgotUserandPassWordLbl: UILabel!
    @IBOutlet weak var resetTxt: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var bankNBtn: UIButton!
    @IBOutlet weak var select_Country_view: UIView!
    @IBOutlet weak var community_view: UIView!
    
    var ChangeString = String()
    var Typestr:String!
    var defaults:UserDefaults!
    var Email:String!
    var str_email:NSString!
    var user_id:Int!
    var roleId:Int!
    var SuperAdmin = ["Business Owner","Admin","User"]
    var SuperAdminPickerView: UIPickerView = UIPickerView()
    var CountryPickerView: UIPickerView = UIPickerView()
    var usertype:NSString!
    var countryArray = NSMutableArray()
    var countryName = NSArray()
    var name:String!
    var user_status:String!
    var str_country:NSString!
    var str_community:NSString!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateForgotPassword(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                
                self.user_id = response.value(forKey: "user_id") as? Int
                
                
                
                if self.Typestr ==  "1" {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                }else {
                    let deafults = UserDefaults.standard
                    deafults.set(self.user_id, forKey: "UserIDGet")
                    deafults.synchronize()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                }
                
                
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
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
                self.countryName = self.countryArray.value(forKey: "name") as! NSArray
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        // roleId = defaults.integer(forKey: "RoleId")
        language = defaults.value(forKey: "Language") as? String
        SuperAdminPickerView.delegate = self
        SuperAdminPickerView.dataSource = self
        selectloginTxt.inputView = SuperAdminPickerView
        selectloginTxt.delegate = self
        countryTxt.delegate = self
        countryHeightCons.constant = 0
        communityHeightCons.constant = 0
        self.select_Country_view.isHidden = true
        self.community_view.isHidden = true
        emailviewTopCons.constant = -15
        
        
        if language == "en"{
            self.SuperAdmin = ["Business Owner","Admin","User"]
        }else{
            self.SuperAdmin = ["صاحب العمل","مسؤول","مستخدم"]
        }
        
        CountryPickerView.delegate = self
        CountryPickerView.dataSource = self
        countryTxt.inputView = CountryPickerView
        
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
        
        countryTxt.inputAccessoryView = toolBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("ForgotSelectCountry"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("ForgotSelectCountry1"), object: nil)
        
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().GetCountryList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetCountryList), name: NSNotification.Name(rawValue: "GetCountryListNotification"), object: nil)
        
        //MARK:- language Code Start
        if language == "en" {
            self.continueBtn.setTitle("SEND", for: .normal)
            self.bankNBtn.setTitle("Back to Login", for: .normal)
        }else if language == "ar" {
            self.continueBtn.setTitle("إرسال", for: .normal)
            self.bankNBtn.setTitle("العودة إلى تسجيل الدخول", for: .normal)
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    //MARK:- language Function
    func decorate() {
        self.forgotUserandPassWordLbl.text = language == "en" ? "Forgot Username & Password" : "هل نسيت كلمة المرور؟";
//        self.resetTxt.text = language == "en" ? "We will send a code on your registered email." : "سنرسل رمز على بريدك الإلكتروني المسجل."
        self.usernameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
        self.passwordLbl.text = language == "en" ? "Password" : "كلمه السر"
        self.selectloginTxt.placeholder = language == "en" ? "Select User Type" : "حدد نوع المستخدم"
        self.countryTxt.placeholder = language == "en" ? "Select Country" : "حدد الدولة"
        self.communityTxt.placeholder = language == "en" ? "Community unique name" : "الاسم المميز للمجتمع"
        self.emailTxt.placeholder = language == "en" ? "Email" : "البريد الإلكتروني"
        if language .isEqual("en") || language .isEqual(""){
            self.selectloginTxt.textAlignment = .left
            self.countryTxt.textAlignment = .left
            self.communityTxt.textAlignment = .left
            self.emailTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.selectloginTxt.textAlignment = .right
            self.countryTxt.textAlignment = .right
            self.communityTxt.textAlignment = .right
            self.emailTxt.textAlignment = .right
        }
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        name = defaults.value(forKey: "COUNTRYNAME") as? String
        countryTxt.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        name = defaults.value(forKey: "COUNTRYNAME") as? String
        countryTxt.text = name
        
    }
    //Copy Code for single textfiled
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == selectloginTxt{
           return false //prevents editing
        }else if textField == countryTxt{
            return false
        }
        
        return true
        
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
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == SuperAdminPickerView {
            return SuperAdmin.count
        }else {
            return countryName.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == SuperAdminPickerView {
            return SuperAdmin[row]
        }else {
            return countryName[row] as? String
        }
        
    }
    
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == SuperAdminPickerView {
            if row == 0 {
                selectloginTxt.text = SuperAdmin[row]
                roleId = 2
                countryHeightCons.constant = 0
                communityHeightCons.constant = 0
                self.select_Country_view.isHidden = true
                self.community_view.isHidden = true
                emailviewTopCons.constant = -15
                user_status = "1"
            }else if row == 1 {
                selectloginTxt.text = SuperAdmin[row]
                roleId = 3
                countryHeightCons.constant = 0
                communityHeightCons.constant = 0
                self.select_Country_view.isHidden = true
                self.community_view.isHidden = true
                emailviewTopCons.constant = -15
                user_status = "2"
            }else {
                selectloginTxt.text = SuperAdmin[row]
                roleId = 4
                self.select_Country_view.isHidden = false
                self.community_view.isHidden = false
                countryHeightCons.constant = 45
                communityHeightCons.constant = 45
                emailviewTopCons.constant = 15
                user_status = "3"
            }
        }else {
            countryTxt.text = countryName[row] as? String
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if selectloginTxt.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    @IBAction func backBtnaction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func NextBtnAction(_ sender: Any) {
        if user_status == "1" || user_status == "" {
            str_email = emailTxt.text as NSString?
            usertype = selectloginTxt.text as NSString?
            if Typestr == nil {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select username/password." : "يرجى اختيار اسم المستخدم / كلمة المرور." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if usertype .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            } else if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        Parsing().HostGateForgotUserNamePassword(Language: self.language, Email: str_email as String?, Type: Typestr, RoleId: roleId, Country: "", Community: "")
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateForgotPassword), name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            }
        }else if user_status == "2" {
            str_email = emailTxt.text as NSString?
            usertype = selectloginTxt.text as NSString?
             if Typestr == nil {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select username/password." : "يرجى اختيار اسم المستخدم / كلمة المرور." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if usertype .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            } else if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        Parsing().HostGateForgotUserNamePassword(Language: self.language, Email: str_email as String?, Type: Typestr, RoleId: roleId, Country: "", Community: "")
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateForgotPassword), name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                        
                        
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            }
        }else {
            str_email = emailTxt.text as NSString?
            usertype = selectloginTxt.text as NSString?
            str_country = countryTxt.text as NSString?
            str_community = communityTxt.text as NSString?
             if Typestr == nil {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select username/password." : "يرجى اختيار اسم المستخدم / كلمة المرور." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if usertype .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select user type." : "يرجى اختيار نوع المستخدم" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
             } else if str_country .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please select country" : "يرجى اختيار البلد" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
             }else if str_community .isEqual(to: "") {
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter community" : "الرجاء إدخال المجتمع" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
             }else if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
             }
            else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        Parsing().HostGateForgotUserNamePassword(Language: self.language, Email: str_email as String?, Type: Typestr, RoleId: roleId, Country: str_country as String?, Community: str_community as String?)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateForgotPassword), name: NSNotification.Name(rawValue: "HostGateForgotUsernamePassword"), object: nil)
                        
                        
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            }
        }
        
    }
    @IBAction func usernameBtn(_ sender: Any) {
        usernameBtn.setImage(UIImage(named: "radio_fill"), for: .normal)
        passwordBtn.setImage(UIImage(named: "radio"), for: .normal)
        Typestr = "1"
        
    }
    @IBAction func passwordBtn(_ sender: Any) {
        
        passwordBtn.setImage(UIImage(named: "radio_fill"), for: .normal)
        usernameBtn.setImage(UIImage(named: "radio"), for: .normal)
        Typestr = "2"
        
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK:-DGLoclalization Delegate
extension ForgotUserNameViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
