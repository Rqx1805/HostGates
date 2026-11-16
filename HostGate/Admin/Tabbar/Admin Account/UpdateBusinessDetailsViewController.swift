//
//  UpdateBusinessDetailsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CountryList
import AdSupport
import GiFHUD_Swift

class UpdateBusinessDetailsViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CountryListDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var businessNametxt: UITextField!
    @IBOutlet weak var businessregTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var dateformatTxt: UITextField!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    
    
    //MARK:- Variables
    var defaults:UserDefaults!
    var user_id:Int!
    var updateImage:String!
    var picker = UIImagePickerController()
    var chosenImage = UIImage()
    var imagedata: Data!
    
    var str_Businessname:NSString!
    var str_businessreg:NSString!
    var str_address:NSString!
    var str_city:NSString!
    var str_state:NSString!
    var str_country:NSString!
    var str_dateFormat:NSString!
    var countryList = CountryList()
    var Name = String()
    var Address = String()
    var roleId:Int!
    var adminuserid:Int!
    var datePickerView  : UIDatePicker = UIDatePicker()
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateUpdateProfile(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateBusinessDetail"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                
                self.updateImage = response.value(forKey: "logo") as? String
                self.Name = (response.value(forKey: "name") as? String)!
                self.Address = (response.value(forKey: "address") as? String)!
                //
                
                let defaults = UserDefaults.standard
                defaults.set(self.updateImage, forKey: "BusinessImage")
                defaults.set(self.Name, forKey: "BusinessName")
                defaults.set(self.Address, forKey: "BusinessAddress")
                defaults.synchronize()
                GIFHUD.shared.dismiss()
                self.showAlertUpateProfile(message: str_message)
            }
        }
    }
    
    func showAlertUpateProfile(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            
            //print("response: \(response)")
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("MyBusinessProfileControllerChosen"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateBusinessDetail"), object: nil)
            //                self.removeAllOverlays()
            GIFHUD.shared.dismiss()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Login WebService
    @objc func HostGateGetUserDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                self.businessNametxt.text = response.value(forKey: "name") as? String
                self.businessregTxt.text = response.value(forKey: "registration_number") as? String
                self.addressTxt.text = response.value(forKey: "address") as? String
                self.cityTxt.text = response.value(forKey: "city") as? String
                self.stateTxt.text = response.value(forKey: "state") as? String
                self.countryTxt.text = response.value(forKey: "country") as? String
                self.dateformatTxt.text = response.value(forKey: "date_format") as? String
                self.updateImage = response.value(forKey: "logo") as? String
                
                
                self.Name = (response.value(forKey: "name") as? String)!
                self.Address = (response.value(forKey: "address") as? String)!
                
                
                let defaults = UserDefaults.standard
                defaults.set(self.Name, forKey: "BusinessName")
                defaults.set(self.updateImage, forKey: "BusinessImage")
                defaults.set(self.Address, forKey: "BusinessAddress")
                defaults.synchronize()
                
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.profileImageView.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
//                self.removeAllOverlays()
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
//                     self.removeAllOverlays()
                     self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                    GIFHUD.shared.dismiss()
                 }
                 else if status == 1{
                     NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                     SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                     self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                     self.removeAllOverlays()
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
        self.countryTxt.delegate = self
        self.dateformatTxt.delegate = self
        defaults = UserDefaults.standard
         language = defaults.value(forKey: "Language") as? String
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        countryList.delegate = self
        countryTxt.delegate = self
        
        businessNametxt.delegate = self
        businessregTxt.delegate = self
        addressTxt.delegate = self
        cityTxt.delegate = self
        stateTxt.delegate = self
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        dateformatTxt.inputView = datePickerView
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGetBusinessDetail(Language: language, UserId: user_id, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetUserDetailAction), name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
        
    
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
       // GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Update Business Details" : "تحديث تفاصيل العمل"
        self.businessNametxt.placeholder = language == "en" ? "Name" : "اسم"
        self.businessregTxt.placeholder = language == "en" ? "Business/Registration Number" : "رقم العمل / التسجيل"
        self.addressTxt.placeholder = language == "en" ? "Address" : "عنوان"
        self.cityTxt.placeholder = language == "en" ? "City" : "مدينة"
        self.stateTxt.placeholder = language == "en" ? "State" : "حالة"
        self.countryTxt.placeholder = language == "en" ? "Select Country" : "حدد الدولة"
        self.dateformatTxt.placeholder = language == "en" ? "Date Format" : "صيغة التاريخ"
        if language == "en" {
            self.submit_btn.setTitle("SUBMIT", for: .normal)
        }else if language == "ar" {
            self.submit_btn.setTitle("إرسال", for: .normal)
        }
        if language .isEqual("en") || language .isEqual(""){
            self.businessNametxt.textAlignment = .left
            self.businessregTxt.textAlignment = .left
            self.addressTxt.textAlignment = .left
            self.cityTxt.textAlignment = .left
            self.stateTxt.textAlignment = .left
            self.countryTxt.textAlignment = .left
            self.dateformatTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.businessNametxt.textAlignment = .right
            self.businessregTxt.textAlignment = .right
            self.addressTxt.textAlignment = .right
            self.cityTxt.textAlignment = .right
            self.stateTxt.textAlignment = .right
            self.countryTxt.textAlignment = .right
            self.dateformatTxt.textAlignment = .right
        }
    }
    
    
    //MARK:- Date Button Action
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateformatTxt.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == businessNametxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 80
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }else  if textField == businessregTxt {
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
            
        }else if textField == addressTxt {
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
            
        }else if textField == cityTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 80
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        } else if textField == stateTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 80
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }else if textField == self.countryTxt{
            return false
        }else if textField ==  self.dateformatTxt{
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == countryTxt {
            let navController = UINavigationController(rootViewController: countryList)
            self.present(navController, animated: true, completion: nil)
        }
        else {
            
        }
    }
    func selectedCountry(country: Country) {
        // self.countryTxt.text = "\("+")\(country.phoneExtension)"
        //  str_code = "+\(country.phoneExtension)"
        str_country = country.name! as NSString
        self.countryTxt.text = str_country as String?
        print(country.phoneExtension)
        
    }
    
    
    @IBAction func cameraBtnAction(_ sender: Any) {
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
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        profileImageView.image = chosenImage
        profileImageView.image = self.resizeImage(chosenImage)
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtbAction(_ sender: Any) {
        
        str_Businessname = businessNametxt.text as NSString?
        str_businessreg = businessregTxt.text as NSString?
        str_address = addressTxt.text as NSString?
        str_city = cityTxt.text as NSString?
        str_state = stateTxt.text as NSString?
        str_country = countryTxt.text as NSString?
        str_dateFormat = dateformatTxt.text as NSString?
        if str_Businessname .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter name." : "يرجى إدخال الاسم." , buttonTitle: language == "en" ? "OK" : "حسنا")
        } else if str_Businessname.length > 80 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Max length should be 80 characters." : "يجب أن يكون الحد الأقصى للطول 80 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else  if str_businessreg .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Minimum registration should be 3 characters." : "يجب أن يكون الحد الأدنى للتسجيل 3 أحرف" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if str_businessreg.length < 3 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Minimum registration number should be 3 characters." : "يجب أن يكون الحد الأدنى لرقم التسجيل 3 أحرف" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_address .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter address." : "الرجاء إدخال العنوان" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_city .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter city." : "من فضلك ادخل المدينة" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_state .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter state." : "الرجاء إدخال الدولة" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_country .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter country." : "الرجاء إدخال البلد" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_dateFormat .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter date format." : "يرجى إدخال تنسيق التاريخ" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:15)
                let data = BusinessDataModel()
                
                if imagedata == nil {
                    let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                    let testImage = NSData(contentsOf: AddPicture_url as URL)
                    data.profile_picture = testImage!
                }
                else {
                    data.profile_picture = imagedata as NSData
                }
                data.userID = user_id
                data.BusinessName = str_Businessname as String
                data.BusinessRegNumber  = str_businessreg as String
                data.Address = str_address as String
                data.City = str_city as String
                data.State = str_state as String
                data.Country = str_country as String
                data.DateFormat = str_dateFormat as String
                data.Langauge = "en"
                data.RoleId = roleId
                data.AdminUserID = adminuserid
                Parsing().HostGatesBusienssDetailProfile(data: data)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateBusinessDetail"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateProfile), name: NSNotification.Name(rawValue: "HostGatesUpdateBusinessDetail"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
            }
        }
        
    }
    
    
}

//MARK:-DGLoclalization Delegate
extension UpdateBusinessDetailsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}

