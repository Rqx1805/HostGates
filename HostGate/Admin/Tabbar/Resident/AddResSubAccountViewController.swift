//
//  AddResSubAccountViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CountryList
import AdSupport
import GiFHUD_Swift

class AddResSubAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CountryListDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nationalityLbl: UITextField!
    @IBOutlet weak var nationalIdNumber: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passviewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countrycodetxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var password_main_view: UIView!
    
    var str_name:NSString!
    var str_nationality:NSString!
    var str_nationid:NSString!
    var str_email:NSString!
    var str_username:NSString!
    var str_password:NSString!
    
    var updateImage:String!
    var picker = UIImagePickerController()
    var chosenImage = UIImage()
    var imagedata: Data!
    
    var countryList = CountryList()
    var defaults:UserDefaults!
    var str:String!
    var user_id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var communityID:Int!
    var subAccountId:Int!
    var str_countrycode:NSString!
    var str_mobile:NSString!
    var role:Int!
      let identifierManager = ASIdentifierManager.shared()
      var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateSubAccounts(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesAddSubAccount"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name("AddSubAccount"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesAddSubAccount"), object: nil)
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                self.showAlertAdd(message: str_message)
            }
        }
    }
    
    func showAlertAdd(message: String) {
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
    
    @objc func HostGateUpdateAccounts(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateSubAccount"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name("UpdateSubAccount"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateSubAccount"), object: nil)
                 GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                self.showAlertUpdate(message: str_message)
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
    
    @objc func HostGateGetSubAccounts(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetSubaccount"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                self.emailTxt.isUserInteractionEnabled = false
                self.usernameTxt.isUserInteractionEnabled = false
                self.updateImage = response.value(forKey: "profile_picture") as? String
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.profileImageview.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                self.nameTxt.text = response.value(forKey: "name") as? String
                self.nationalityLbl.text =  response.value(forKey: "country_id_number") as? String
                self.nationalIdNumber.text =  response.value(forKey: "id_number") as? String
                self.emailTxt.text =  response.value(forKey: "email") as? String
                self.countrycodetxt.text = response.value(forKey: "country_code") as? String
                self.mobileTxt.text = response.value(forKey: "phone") as? String
                self.usernameTxt.text =  response.value(forKey: "unique_name") as? String
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetSubaccount"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    
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
                
             }
             else if status == 1{
                 NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                 self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                 self.removeAllOverlays()
            
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
        language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        str = defaults.value(forKey: "SUBEDIT") as? String
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        subAccountId = defaults.integer(forKey: "SUBID")
        communityID = defaults.integer(forKey: "COMNEWID")
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        if str == "add" {
            usernameTxt.isUserInteractionEnabled = true
            passviewHeightCons.constant = 45
            self.password_main_view.isHidden = false
            titleLbl.text = language == "en" ? "Add Sub Account" : "إضافة حساب فرعي"
            self.submitbtn.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
        }else {
            usernameTxt.isUserInteractionEnabled = true
            passviewHeightCons.constant = 0
            self.password_main_view.isHidden = true
            titleLbl.text = language == "en" ? "Edit Sub Account" : "تحرير الحساب الفرعي"
            self.submitbtn.setTitle(language == "en" ? "UPDATE" : "تحديث", for: .normal)
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:15)
            Parsing().HostGateGetSubaccount(Language: language, UserId: user_id, RoleId: roleId, AdminUserid: adminuserid, SubAccountID: subAccountId)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetSubaccount"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetSubAccounts), name: NSNotification.Name(rawValue: "HostGateGetSubaccount"), object: nil)
        }
        nameTxt.delegate = self
        nationalIdNumber.delegate = self
        emailTxt.delegate = self
        usernameTxt.delegate = self
        passwordTxt.delegate = self
        countrycodetxt.delegate = self
        mobileTxt.delegate = self
        profileImageview.layer.cornerRadius = profileImageview.frame.height/2
        profileImageview.layer.masksToBounds = true
        profileImageview.clipsToBounds = true
        
        countryList.delegate = self
        nationalityLbl.delegate = self
        
        //MARK:- language Code Start
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        if language == "en" {
            self.nameTxt.textAlignment = .left
            self.nationalityLbl.textAlignment = .left
            self.nationalIdNumber.textAlignment = .left
            self.emailTxt.textAlignment = .left
            self.mobileTxt.textAlignment = .left
            self.usernameTxt.textAlignment = .left
            self.passwordTxt.textAlignment = .left
        }else if language == "ar" {
            self.nameTxt.textAlignment = .right
            self.nationalityLbl.textAlignment = .right
            self.nationalIdNumber.textAlignment = .right
            self.mobileTxt.textAlignment = .right
            self.usernameTxt.textAlignment = .right
            self.passwordTxt.textAlignment = .right
            self.emailTxt.textAlignment = .right
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SelectCountry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("SelectCountry1"), object: nil)
        
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.nameTxt.placeholder = language == "en" ? "Full Name" : "الاسم الكامل"
        self.nationalityLbl.placeholder = language == "en" ? "Select Nationality" : "اختر الجنسية"
        self.nationalIdNumber.placeholder = language == "en" ? "National Id / Passport Number" : "رقم الهوية الوطنية / جواز السفر"
        self.emailTxt.placeholder = language == "en" ? "Email" : "البريد الإلكتروني"
        self.mobileTxt.placeholder = language == "en" ? "Mobile Number" : "رقم الهاتف المحمول"
        self.usernameTxt.placeholder = language == "en" ? "Username" : "اسم المستخدم";
        self.passwordTxt.placeholder = language == "en" ? "Password" : "كلمه السر";
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
                
                let maxLength = 55
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }else if textField == nationalIdNumber {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 30
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }
        else if textField == emailTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 60
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }   else if textField == usernameTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 30
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }   else if textField == passwordTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 16
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        } else if textField == mobileTxt {
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
    
    func countryNameOnly(){
        let fv = storyboard?.instantiateViewController(withIdentifier: "CountrySearchViewController")as! CountrySearchViewController
        self.navigationController?.present(fv, animated: true, completion: nil)
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        nationalityLbl.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        nationalityLbl.text = name
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == nationalityLbl {
            self.countryNameOnly()
            self.view.endEditing(true)
        }else if textField == countrycodetxt {
            let navController = UINavigationController(rootViewController: countryList)
            self.present(navController, animated: true, completion: nil)
            self.view.endEditing(true)
        }else {
            
        }
    }
    func selectedCountry(country: Country) {
        // self.countryTxt.text = "\("+")\(country.phoneExtension)"
        //  str_code = "+\(country.phoneExtension)"
        str_nationality = country.name! as NSString
        str_countrycode = "+\(country.phoneExtension)" as NSString
        self.nationalityLbl.text = str_nationality as String?
        self.countrycodetxt.text = str_countrycode as String?
        print(country.phoneExtension)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        GIFHUD.shared.show(withOverlay: true, duration:15)
        if str == "add" {
            str_name = nameTxt.text as NSString?
            str_nationality = nationalityLbl.text as NSString?
            str_nationid = nationalIdNumber.text as NSString?
            str_email = emailTxt.text as NSString?
            str_countrycode = countrycodetxt.text as NSString?
            str_mobile = mobileTxt.text as NSString?
            str_username = usernameTxt.text as NSString?
            str_password = passwordTxt.text as NSString?
            
            
            if str_name .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter full name." : "الرجاء إدخال الاسم الكامل" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_nationality .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select nationality." : "الرجاء اختيار الجنسية" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_nationid .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter National ID / Passport Number." : "الرجاء إدخال رقم الهوية / جواز السفر الوطني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_email .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا" )
            }else if str_countrycode .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter countrycode." : "الرجاء إدخال رمز البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_mobile .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_mobile.length < 7 || str_mobile.length > 15 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Mobile number should be 7-15 digits." : "يجب أن يكون رقم الجوال من 7 إلى 15 رقمًا.", buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else if str_username .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter username." : "الرجاء إدخال اسم المستخدم" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_password .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter password." : "الرجاء إدخال كلمة المرور" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_password.length < 6 || str_password.length > 16{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Password must be 6-16 characters only." : "يجب أن تكون كلمة المرور من 6 إلى 16 حرفًا فقط.", buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if isValidEmail(str_email as String){
//                    showWaitOverlay()
                    
                    let data = AddSubaccountsModel()
                    if imagedata == nil {
                    }
                    else {
                        data.profile_picture = imagedata as NSData
                    }
                    data.UserId = user_id
                    data.AdminUserId = adminuserid
                    data.CommunityID = communityID
                    data.RoleId = roleId
                    data.Name = str_name as String
                    data.Countrycode = str_countrycode as String
                    data.Mobilenumber = str_mobile as String
                    data.Country_Id_Number  = str_nationality as String
                    data.Id_Number = str_nationid as String
                    data.Email = str_email as String
                    data.Password = str_password as String
                    data.Unique_Name = str_username as String
                    data.Language = language
                    Parsing().HostGatesAddSubAccount(data: data)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesAddSubAccount"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubAccounts), name: NSNotification.Name(rawValue: "HostGatesAddSubAccount"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please Enter Correct Email Id" : "الرجاء إدخال معرف البريد الإلكتروني الصحيح" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }else {
            str_name = nameTxt.text as NSString?
            str_nationality = nationalityLbl.text as NSString?
            str_nationid = nationalIdNumber.text as NSString?
            str_countrycode = countrycodetxt.text as NSString?
            str_mobile = mobileTxt.text as NSString?
            str_email = emailTxt.text as NSString?
            
            if str_name .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter full name." : "الرجاء إدخال الاسم الكامل" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_nationality .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select nationality." : "الرجاء اختيار الجنسية" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_nationid .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter National ID / Passport Number." : "الرجاء إدخال رقم الهوية / جواز السفر الوطني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_email .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_countrycode .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter countrycode." : "الرجاء إدخال رمز البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_mobile .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_mobile.length < 7 || str_mobile.length > 15 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Mobile number must be 7-15 digits." : "يجب أن يكون رقم الجوال من 7 إلى 15 رقمًا.", buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else {
//                showWaitOverlay()
                
                let data = UpdateSubAccountModel()
                if imagedata == nil {
                    let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                    let testImage = NSData(contentsOf: AddPicture_url as URL)
                    data.profile_picture = testImage!
                }
                else {
                    data.profile_picture = imagedata as NSData
                }
                data.UserId = user_id
                data.AdminUserId = adminuserid
                data.CommunityID = communityID
                data.RoleId = roleId
                data.Countrycode = str_countrycode as String
                data.Mobilenumber = str_mobile as String
                data.Name = str_name as String
                data.Country_Id_Number  = str_nationality as String
                data.Id_Number = str_nationid as String
                data.Email = str_email as String
                data.SubAccounbtID = subAccountId
                data.Language = language
                Parsing().HostGatesUpdateSubAccount(data: data)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateSubAccount"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateAccounts), name: NSNotification.Name(rawValue: "HostGatesUpdateSubAccount"), object: nil)
            }
        }
    }
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @IBAction func UploadImageBtn(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: language == "en" ?  "Choose Image" : "اختر صورة", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: language == "en" ? "Camera" : "الة تصوير", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: language == "en" ? "Gallery" : "صالة عرض", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: language == "en" ? "Cancel" : "إلغاء", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func openCamera() {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.camera
        present(picker, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        profileImageview.image = chosenImage
        profileImageview.image = self.resizeImage(chosenImage)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
        let dateExtension = formatter.string(from: date)
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
        print(paths)
        
        imagedata = chosenImage.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imagedata, attributes: nil)
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func resizeImage(_ image:UIImage) -> UIImage
    {
        let actualHeight = Int(image.size.height);
        let actualWidth = Int(image.size.width);
        let compressionQuality:CGFloat = 0.3;//50 percent compression
        
        let newsizeWidth = CGFloat( actualWidth ) * CGFloat(compressionQuality)
        let newsizeHeight = CGFloat( actualHeight ) * CGFloat(compressionQuality)
        let newSize = CGSize(width: newsizeWidth , height: newsizeHeight);
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize);
        image.draw(in: CGRect(x: 0, y: 0 , width: newSize.width , height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return compressedImage!
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:-DGLoclalization Delegate
extension AddResSubAccountViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}

