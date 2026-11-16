//
//  UpdatePersonalDetailsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import SDWebImage
import CountryList
import AdSupport
import GiFHUD_Swift

class UpdatePersonalDetailsViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CountryListDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FullNameTxt: UITextField!
    @IBOutlet weak var EmailAddressTxt: UITextField!
    @IBOutlet weak var CounrtyCodeTxt: UITextField!
    @IBOutlet weak var MobileNumberTxt: UITextField!
    @IBOutlet weak var NationIDNumberTxt: UITextField!
    @IBOutlet weak var CountryNameTxt: UITextField!
    @IBOutlet weak var update_btn: UIButton!
    @IBOutlet weak var change_passwordbtn: UIButton!
    
    @IBOutlet weak var updatebusinessDetailBtn: UIButton!
    @IBOutlet weak var linelbl: UILabel!
    @IBOutlet weak var countrycodeViewheightcons: NSLayoutConstraint!
    @IBOutlet weak var mobileNoheightcons: NSLayoutConstraint!
    @IBOutlet weak var nationidViewHightCons: NSLayoutConstraint!
    @IBOutlet weak var countryNameHeightCons: NSLayoutConstraint!
    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var usernameHeightCons: NSLayoutConstraint!
    @IBOutlet weak var uptopCons: NSLayoutConstraint!
    @IBOutlet weak var country_code_top_constriant: NSLayoutConstraint!
    
    var defaults:UserDefaults!
    var user_id:Int!
    var updateImage:String!
    var picker = UIImagePickerController()
    var chosenImage = UIImage()
    var imagedata: Data!
    
    var str_fullname:NSString!
    var str_email:NSString!
    var str_countryCode:NSString!
    var str_phoneNumber:NSString!
    var str_loginusername:NSString!
    var str_NationID:NSString!
    var str_countryName:NSString!
    var countryList = CountryList()
    var Name:String!
    var IdNumber:String!
    var Email:String!
    var CountryCode:String!
    var Phone:String!
    var PhoneNumber:String!
    var str_code = String()
    var str_countryname = String()
    var roleId:Int!
    var user_sts:String!
    var role:Int!
    var comtype:Int!
    var busy:String!
    var adminuserid:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    var deviceTocken = NSString()
    
    //MARK:- Login WebService
    @objc func HostGateGetUserDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                self.FullNameTxt.text = response.value(forKey: "full_name") as? String
                //                if self.user_sts == "1" {
                //                   self.FullNameTxt.text = response.value(forKey: "full_name") as? String
                //
                //                }else if self.user_sts == "2" && self.role == 1 {
                //                    self.FullNameTxt.text = response.value(forKey: "username") as? String
                //                }
                //                else if self.user_sts == "2" && self.role == 2 {
                //                    self.FullNameTxt.text = response.value(forKey: "username") as? String
                //                }
                //                else if self.user_sts == "2" && self.role == 3 {
                //                    self.FullNameTxt.text = response.value(forKey: "username") as? String
                //                }else if self.user_sts == "3" {
                //                      self.FullNameTxt.text = response.value(forKey: "full_name") as? String
                //                }
                
                self.EmailAddressTxt.text = response.value(forKey: "email") as? String
                var code:String!
                code = response.value(forKey: "country_code") as? String
                let decodedString =  code.removingPercentEncoding //Decode for (+)sign
                self.CounrtyCodeTxt.text = decodedString
                self.MobileNumberTxt.text = response.value(forKey: "phone") as? String
                //self.LoginUserNameTxt.text = response.value(forKey: "unique_name") as? String
                self.NationIDNumberTxt.text = response.value(forKey: "id_number") as? String
                self.CountryNameTxt.text = response.value(forKey: "country_id_number") as? String
                self.updateImage = response.value(forKey: "profile_picture") as? String
                
                if self.user_sts == "1" {
                    //self.Name = response.value(forKey: "full_name") as? String
                    
                }else if self.user_sts == "2" && self.role == 1 {
                    
                    //  self.Name = response.value(forKey: "username") as? String
                }else if self.user_sts == "2" && self.role == 2 {
                    
                    //  self.Name = response.value(forKey: "username") as? String
                }
                else if self.user_sts == "2" && self.role == 3 {
                    
                    // self.Name = response.value(forKey: "username") as? String
                }
                
                
                self.IdNumber = response.value(forKey: "id_number") as? String
                self.Email = response.value(forKey: "email") as? String
                var code1:String!
                code1 = response.value(forKey: "country_code") as? String
                let decodedString1 =  code1.removingPercentEncoding //Decode for (+)sign
                self.CountryCode = decodedString1
                self.Phone = response.value(forKey: "phone") as? String
                self.Name = response.value(forKey: "full_name") as? String
                self.userNameTxt.text = response.value(forKey: "username") as? String
                var str:String!
                str = response.value(forKey: "username") as? String
                // USer
                let defaults = UserDefaults.standard
                defaults.set(self.Name, forKey: "Name")
                defaults.set(str, forKey: "USer")
                defaults.set(self.updateImage, forKey: "Image")
                defaults.set(self.IdNumber, forKey: "IDNum")
                defaults.set(self.Email, forKey: "EMAILADDRESS")
                defaults.set(self.Phone, forKey: "PHONENumber")
                defaults.set(self.CountryCode, forKey: "CountryCode")
                defaults.synchronize()
                
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.ProfileImage.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    @objc func HostGateUpdateProfile(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                self.showAlertUpate(message: str_message)
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                
                self.updateImage = response.value(forKey: "profile_picture") as? String
                
                self.Name = response.value(forKey: "full_name") as? String
                self.IdNumber = response.value(forKey: "id_number") as? String
                self.Email = response.value(forKey: "email") as? String
                var code1:String!
                code1 = response.value(forKey: "country_code") as? String
                let decodedString1 =  code1.removingPercentEncoding //Decode for (+)sign
                self.CountryCode = decodedString1
                self.Phone = response.value(forKey: "phone") as? String
                var str:String!
                str = response.value(forKey: "username") as? String
                let defaults = UserDefaults.standard
                defaults.set(self.Name, forKey: "Name")
                defaults.set(str, forKey: "USer")
                defaults.set(self.updateImage, forKey: "Image")
                defaults.set(self.IdNumber, forKey: "IDNum")
                defaults.set(self.Email, forKey: "EMAILADDRESS")
                defaults.set(self.Phone, forKey: "PHONENumber")
                defaults.set(self.CountryCode, forKey: "CountryCode")
                defaults.synchronize()
                
                print("response: \(response)")
                
                
            }
        }
    }
    
    func showAlertUpate(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("MyProfileControllerChosen"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
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
//                  self.removeAllOverlays()
                  self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
              }
              else if status == 1{
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                  self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                  self.removeAllOverlays()
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
         language = defaults.value(forKey: "Language") as? String
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        user_sts = defaults.value(forKey: "User_Status") as? String
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        self.comtype = defaults.integer(forKey: "COMTYPE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        busy = defaults.value(forKey: "BUSI") as? String
        countryList.delegate = self
        CounrtyCodeTxt.delegate = self
        CountryNameTxt.delegate = self
        
        if user_sts == "1" {
            self.countrycodeViewheightcons.constant = 45
            self.mobileNoheightcons.constant = 45
            self.uptopCons.constant = 20
        }else if user_sts == "2" {
            self.countrycodeViewheightcons.constant = 45
            self.mobileNoheightcons.constant = 45
            self.uptopCons.constant = 20
        }else if user_sts == "3" {
            if role == 1 && comtype == 2 {
                self.countrycodeViewheightcons.constant = 45
                self.mobileNoheightcons.constant = 45
                self.uptopCons.constant = 20
            } else if role == 2 && comtype == 1 {
                self.countrycodeViewheightcons.constant = 0
                self.mobileNoheightcons.constant = 0
                self.uptopCons.constant = 20
                self.country_code_top_constriant.constant = -5
            }else if role == 1 && comtype == 1 {
                self.countrycodeViewheightcons.constant = 45
                self.mobileNoheightcons.constant = 45
                self.uptopCons.constant = 20
            }
            else{
                if comtype == 1 {
                    self.countrycodeViewheightcons.constant = 45
                    self.mobileNoheightcons.constant = 45
                    self.uptopCons.constant = 20
                }else if comtype == 2 {
                    self.countrycodeViewheightcons.constant = 0
                    self.mobileNoheightcons.constant = 0
                    
                }else {
                    self.countrycodeViewheightcons.constant = 45
                    self.mobileNoheightcons.constant = 45
                    self.uptopCons.constant = 20
                }
                
            }
        }
        
        if user_sts == "3" && self.comtype == 2 {
            countryNameHeightCons.constant = 0
            nationidViewHightCons.constant = 0
            usernameHeightCons.constant = -10
        }else if user_sts == "3" && self.comtype == 1 {
            countryNameHeightCons.constant = 45
            nationidViewHightCons.constant = 45
        }
        
        
        
        if self.user_sts == "1" {
            if busy == "busines" {
                updatebusinessDetailBtn.isHidden = true
                linelbl.isHidden = true
            }else  if busy == nil {
                updatebusinessDetailBtn.isHidden = true
                linelbl.isHidden = true
            }else {
                updatebusinessDetailBtn.isHidden = false
                linelbl.isHidden = false
            }
            //updatebusinessDetailBtn.isHidden = false
            // linelbl.isHidden = false
            
        }else if self.user_sts == "2" && role == 1 {
            updatebusinessDetailBtn.isHidden = true
            linelbl.isHidden = true
        }
        else if self.user_sts == "2" && role == 2 {
            updatebusinessDetailBtn.isHidden = true
            linelbl.isHidden = true
        }
        else if self.user_sts == "2" && role == 3 {
            if busy == "busines" {
                updatebusinessDetailBtn.isHidden = true
                linelbl.isHidden = true
            }else  if busy == nil {
                updatebusinessDetailBtn.isHidden = true
                linelbl.isHidden = true
            }else {
                updatebusinessDetailBtn.isHidden = false
                linelbl.isHidden = false
            }
        }else if user_sts == "3" {
            updatebusinessDetailBtn.isHidden = true
            linelbl.isHidden = true
        }else if user_sts == "4" {
            updatebusinessDetailBtn.isHidden = true
            linelbl.isHidden = true
        }
        
        ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        ProfileImage.layer.masksToBounds = true
        ProfileImage.clipsToBounds = true
        FullNameTxt.delegate = self
        EmailAddressTxt.delegate = self
        MobileNumberTxt.delegate = self
        NationIDNumberTxt.delegate = self
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateUserDetail(Language: language, user_Id: user_id, RoleId: roleId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetUserDetailAction), name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        
        
        
        
        //MARK:- language Code Start
       
        if language == "en" {
            
            self.change_passwordbtn.setTitle("Change Password", for: .normal)
            self.updatebusinessDetailBtn.setTitle("Update Business Details", for: .normal)
            
        }else if language == "ar" {
            
            self.change_passwordbtn.setTitle("تغيير كلمة السر", for: .normal)
            self.updatebusinessDetailBtn.setTitle("تحديث تفاصيل العمل", for: .normal)
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SelectCountry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("SelectCountry1"), object: nil)
        
       // GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Update Personal Details" : "تحديث التفاصيل الشخصية"
        self.FullNameTxt.placeholder = language == "en" ? "Full name" : "الاسم الكامل"
        self.EmailAddressTxt.placeholder = language == "en" ? "Email" : "البريد الإلكتروني"
        self.MobileNumberTxt.placeholder = language == "en" ? "Mobile Number" : "رقم الهاتف المحمول"
        self.CountryNameTxt.placeholder = language == "en" ? "Country Name" : "اسم الدولة"
        self.NationIDNumberTxt.placeholder = language == "en" ? "Unique ID" : "هوية مميزة";
        self.userNameTxt.placeholder = language == "en" ? "Username" : "اسم المستخدم";
        if language == "en" {
            self.update_btn.setTitle("UPDATE", for: .normal)
        }else if language == "ar" {
            self.update_btn.setTitle("تحديث", for: .normal)
        }
        if language .isEqual("en") || language .isEqual(""){
            self.FullNameTxt.textAlignment = .left
            self.EmailAddressTxt.textAlignment = .left
            self.MobileNumberTxt.textAlignment = .left
            self.CountryNameTxt.textAlignment = .left
            self.NationIDNumberTxt.textAlignment = .left
            self.userNameTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.FullNameTxt.textAlignment = .right
            self.EmailAddressTxt.textAlignment = .right
            self.MobileNumberTxt.textAlignment = .right
            self.CountryNameTxt.textAlignment = .right
            self.NationIDNumberTxt.textAlignment = .right
            self.userNameTxt.textAlignment = .right
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == FullNameTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                 self.view.endEditing(true)
                return  validate(string: newString)
            }else {
                
                let maxLength = 80
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
            
        }
        else if textField == EmailAddressTxt {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }else if textField == MobileNumberTxt {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }else if textField == NationIDNumberTxt{
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
        CountryNameTxt.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        CountryNameTxt.text = name
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.CounrtyCodeTxt {
            let navController = UINavigationController(rootViewController: self.countryList)
            self.present(navController, animated: true, completion: nil)
            self.view.endEditing(true)
        }
        else if textField == self.CountryNameTxt {
            self.countryNameOnly()
            self.view.endEditing(true)
        }
    }
    
    func selectedCountry(country: Country) {
        self.CounrtyCodeTxt.text = "\("+")\(country.phoneExtension)"
        str_code = "+\(country.phoneExtension)"
        str_countryname = country.name!
        self.CountryNameTxt.text = str_countryname
        print(country.phoneExtension)
        
    }
    
    @IBAction func backBtnaction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("MyProfileControllerChosen"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateBtnAction(_ sender: Any) {
        if role == 1 && comtype == 2 {
            str_fullname = FullNameTxt.text as NSString?
            str_email = EmailAddressTxt.text as NSString?
            str_countryCode = CounrtyCodeTxt.text as NSString?
            str_phoneNumber = MobileNumberTxt.text as NSString?
            if CounrtyCodeTxt.text == "" {
                CounrtyCodeTxt.text = "+20"
            }else {
                
            }
            let encoded__Question = self.CounrtyCodeTxt.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
            if str_fullname .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter full name." : "الرجاء إدخال الاسم الكامل" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_fullname.length > 80 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Max length should be 80 characters." : "يجب أن يكون الحد الأقصى للطول 80 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_phoneNumber .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: language == "en" ? "OK" : "حسنا")
            } else if str_phoneNumber.length < 7 || str_phoneNumber.length > 15 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Phone number should be in 7-15 digits." : "يجب أن يكون رقم الهاتف في 7-15 أرقام" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        let data = UpdateModel()
                        
                        if imagedata == nil {
                            let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                            let testImage = NSData(contentsOf: AddPicture_url as URL)
                            data.profile_picture = testImage!
                        }
                        else {
                            data.profile_picture = imagedata as NSData
                        }
                        data.userID = user_id
                        data.FullName = str_fullname as String
                        data.Email  = str_email as String
                        data.CountryCode = encoded__Question!
                        data.PhoneNumber = str_phoneNumber as String
                        //                        data.CountryIDNuumber = str_countryName as String
                        //                        data.IDNumber = str_NationID as String
                        data.Language = language
                        data.RoleId = roleId
                        
                        Parsing().HostGatesUpdateProfile(data: data)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateProfile), name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }else if self.role == 1 && comtype == 1 {
            str_fullname = FullNameTxt.text as NSString?
            str_email = EmailAddressTxt.text as NSString?
            str_countryCode = CounrtyCodeTxt.text as NSString?
            str_phoneNumber = MobileNumberTxt.text as NSString?
            str_NationID = NationIDNumberTxt.text as NSString?
            str_countryName = CountryNameTxt.text as NSString?
            if CounrtyCodeTxt.text == "" {
                CounrtyCodeTxt.text = "+20"
            }else {
                
            }
            let encoded__Question = self.CounrtyCodeTxt.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
            if str_fullname .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter full name." : "الرجاء إدخال الاسم الكامل" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_fullname.length > 80 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Max length should be 80 characters." : "يجب أن يكون الحد الأقصى للطول 80 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
                //        else  if str_countryCode .isEqual(to: "") {
                //            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter Country Code" , buttonTitle: "OK")
                //        }
            else  if str_phoneNumber .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: language == "en" ? "OK" : "حسنا")
            } else if str_phoneNumber.length < 7 || str_phoneNumber.length > 15 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Phone number should be in 7-15 digits." : "" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_countryName .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter Country name." : "يجب أن يكون رقم الهاتف في 7-15 أرقام", buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_NationID .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter nation ID number." : "الرجاء إدخال رقم هوية الأمة" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        let data = UpdateModel()
                        
                        if imagedata == nil {
                            let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                            let testImage = NSData(contentsOf: AddPicture_url as URL)
                            data.profile_picture = testImage!
                        }
                        else {
                            data.profile_picture = imagedata as NSData
                        }
                        data.userID = user_id
                        data.FullName = str_fullname as String
                        data.Email  = str_email as String
                        data.CountryCode = encoded__Question!
                        data.PhoneNumber = str_phoneNumber as String
                        data.CountryIDNuumber = str_countryName as String
                        data.IDNumber = str_NationID as String
                        data.Language = language
                        data.RoleId = roleId
                        
                        Parsing().HostGatesUpdateProfile(data: data)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateProfile), name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }else if self.role == 2 && comtype == 1 {
            str_fullname = FullNameTxt.text as NSString?
            str_email = EmailAddressTxt.text as NSString?
            str_countryCode = CounrtyCodeTxt.text as NSString?
            str_phoneNumber = MobileNumberTxt.text as NSString?
            str_NationID = NationIDNumberTxt.text as NSString?
            str_countryName = CountryNameTxt.text as NSString?
            if CounrtyCodeTxt.text == "" {
                CounrtyCodeTxt.text = "+20"
            }else {
                
            }
            let encoded__Question = self.CounrtyCodeTxt.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
            if str_fullname .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter full name." : "الرجاء إدخال الاسم الكامل" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_fullname.length > 80 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Max length should be 80 characters." : "يجب أن يكون الحد الأقصى للطول 80 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
                //        else  if str_countryCode .isEqual(to: "") {
                //            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter Country Code" , buttonTitle: "OK")
                //        }
                //            else  if str_phoneNumber .isEqual(to: "") {
                //                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter Mobile Number" , buttonTitle: "OK")
                //            } else if str_phoneNumber.length < 7 || str_phoneNumber.length > 15 {
                //                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Phone Number should be in 7-15 digits" , buttonTitle: "OK")
                //            }
            else  if str_countryName .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter country name." : "الرجاء إدخال اسم البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else  if str_NationID .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter nation ID number." : "الرجاء إدخال رقم هوية الأمة" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        let data = UpdateModel()
                        
                        if imagedata == nil {
                            let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                            let testImage = NSData(contentsOf: AddPicture_url as URL)
                            data.profile_picture = testImage!
                        }
                        else {
                            data.profile_picture = imagedata as NSData
                        }
                        data.userID = user_id
                        data.FullName = str_fullname as String
                        data.Email  = str_email as String
                        data.CountryCode = encoded__Question!
                        data.PhoneNumber = str_phoneNumber as String
                        data.CountryIDNuumber = str_countryName as String
                        data.IDNumber = str_NationID as String
                        data.Language = language
                        data.RoleId = roleId
                        
                        Parsing().HostGatesUpdateProfile(data: data)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateProfile), name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }
        else {
            str_fullname = FullNameTxt.text as NSString?
            str_email = EmailAddressTxt.text as NSString?
            str_countryCode = CounrtyCodeTxt.text as NSString?
            str_phoneNumber = MobileNumberTxt.text as NSString?
            str_NationID = NationIDNumberTxt.text as NSString?
            str_countryName = CountryNameTxt.text as NSString?
            if CounrtyCodeTxt.text == "" {
                CounrtyCodeTxt.text = "+20"
            }else {
                
            }
            let encoded__Question = self.CounrtyCodeTxt.text!.addingPercentEncoding(withAllowedCharacters:.rfc3986Unreserved)//Encode for (+)sign
            if str_fullname .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter full name." : "الرجاء إدخال الاسم الكامل" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else if str_fullname.length > 80 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Max length should be 80 characters." : "يجب أن يكون الحد الأقصى للطول 80 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_email .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter email." : "الرجاء إدخال البريد الإلكتروني" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
                //        else  if str_countryCode .isEqual(to: "") {
                //            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"Please Enter Country Code" , buttonTitle: "OK")
                //        }
            else  if str_phoneNumber .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter mobile number." : "الرجاء إدخال رقم الجوال" , buttonTitle: language == "en" ? "OK" : "حسنا")
            } else if str_phoneNumber.length < 7 || str_phoneNumber.length > 15 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Phone number should be in 7-15 digits." : "يجب أن يكون رقم الهاتف في 7-15 أرقام" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
            else  if str_countryName .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter country name." : "الرجاء إدخال اسم البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else  if str_NationID .isEqual(to: "") {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter nation ID number." : "الرجاء إدخال رقم هوية الأمة" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if isValidEmail(str_email as String){
                    if Reachability.isConnectedToNetwork() == true {
//                        showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        let data = UpdateModel()
                        
                        if imagedata == nil {
                            let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                            let testImage = NSData(contentsOf: AddPicture_url as URL)
                            data.profile_picture = testImage!
                        }
                        else {
                            data.profile_picture = imagedata as NSData
                        }
                        data.userID = user_id
                        data.FullName = str_fullname as String
                        data.Email  = str_email as String
                        data.CountryCode = encoded__Question!
                        data.PhoneNumber = str_phoneNumber as String
                        data.CountryIDNuumber = str_countryName as String
                        data.IDNumber = str_NationID as String
                        data.Language = language
                        data.RoleId = roleId
                        
                        Parsing().HostGatesUpdateProfile(data: data)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateProfile), name: NSNotification.Name(rawValue: "HostGatesUpdateProfile"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not vailable!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
                    }
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:  language == "en" ? "Please enter valid email ID." : "الرجاء إدخال البريد الإلكتروني الصحيح" , buttonTitle: language == "en" ? "OK" : "حسنا")
                }
            }
        }
        
    }
    @IBAction func ImageUploadBtnAction(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: language == "en" ? "Choose Image" : "اختر صورة", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
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
    
    @IBAction func changePaswordBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        ProfileImage.image = chosenImage
        ProfileImage.image = self.resizeImage(chosenImage)
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
    
    @IBAction func updateBusinessProflleBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateBusinessDetailsViewController") as! UpdateBusinessDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
}

//MARK:-DGLoclalization Delegate
extension UpdatePersonalDetailsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
