//
//  EditCommunityViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 17/09/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import CountryList
import AdSupport
import GiFHUD_Swift

class EditCommunityViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CountryListDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //MARK:- IBOutlet
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var CommunitytitleTxt: UITextField!
    @IBOutlet weak var communityUniqueTxt: UITextField!
    @IBOutlet weak var communityTypeTxt: UITextField!
    @IBOutlet weak var communityAddressTxt: UITextField!
    @IBOutlet weak var CountryTxt: UITextField!
    @IBOutlet weak var update_btnRef: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var select_type_txt_drop_down_image: UIButton!
    
    var roleId:Int!
    var defaults:UserDefaults!
    var Community_id:Int!
    var updateImage:String!
    var picker = UIImagePickerController()
    var chosenImage = UIImage()
    var imagedata: Data!
    
    var str_CommunityTitle:NSString!
    var str_CommunityName:NSString!
    var str_CommunityType:NSString!
    var str_CommunityAddress:NSString!
    var countryList = CountryList()
    var str_country:NSString!
    var CommunityType = ["Residential Complex","Corporate office"]
    var str_community = String()
    var CommunityTypePickerView: UIPickerView = UIPickerView()
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var adminuserid:Int!
    var userid:Int!
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateupdateCommunity(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateCommunity"), object: nil)
//                self.removeAllOverlays()
                 GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                self.showAlertUpate(message: str_message)
            }
        }
    }
    
    func showAlertUpate(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("UpdateCommunityControllerChosen"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateCommunity"), object: nil)
            //                self.removeAllOverlays()
            
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
    
    //MARK:- Login WebService
    @objc func HostGateGetCommunityDataAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetCommunityData"), object: nil)
//                self.removeAllOverlays()
                 GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                self.CommunitytitleTxt.text = response.value(forKey: "title") as? String
                self.communityUniqueTxt.text = response.value(forKey: "unique_name") as? String
                var Type = Int()
                Type = (response.value(forKey: "type") as? Int)!
                if Type == 1 {
                    self.communityTypeTxt.text = self.language == "en" ? "Residential Complex" : "مجمع سكني"
                }else {
                    self.communityTypeTxt.text = self.language == "en" ? "Corporate office" : "مكتب الشركة"
                }
                
                self.communityAddressTxt.text = response.value(forKey: "address") as? String
                self.CountryTxt.text = response.value(forKey: "country") as? String
                
                self.updateImage = response.value(forKey: "logo") as? String
                
                let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                self.profileImageview.sd_setImage(with: AddPicture_url as URL?, placeholderImage: UIImage(named: "ProfileImage"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetCommunityData"), object: nil)
//                self.removeAllOverlays()
                 GIFHUD.shared.dismiss()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        Community_id = defaults.integer(forKey: "CommunityID")
        language = defaults.value(forKey: "Language") as? String
        countryList.delegate = self
        CountryTxt.delegate = self
        self.communityUniqueTxt.isEnabled = false
        roleId = defaults.integer(forKey: "RoleId")
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        userid = defaults.integer(forKey: "UserIDGet")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        CommunitytitleTxt.delegate = self
        communityUniqueTxt.delegate = self
        communityAddressTxt.delegate = self
        
        CommunityTypePickerView.delegate = self
        CommunityTypePickerView.dataSource = self
//        communityTypeTxt.inputView = CommunityTypePickerView
        
        profileImageview.layer.cornerRadius = profileImageview.frame.height/2
        profileImageview.layer.masksToBounds = true
        profileImageview.clipsToBounds = true
        
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGetCommunityData(Language: self.language, CommunityId: Community_id, RoleId: roleId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetCommunityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetCommunityDataAction), name: NSNotification.Name(rawValue: "HostGateGetCommunityData"), object: nil)
        
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("SelectCountry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("SelectCountry1"), object: nil)
        
        //GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: userid, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.titleLbl.text = language == "en" ? "Edit Community" : "تحرير المجتمع"
        self.CommunitytitleTxt.placeholder = language == "en" ? "Title" : "عنوان"
        self.communityUniqueTxt.placeholder = language == "en" ? "Unique Name" : "اسم فريد"
        self.communityTypeTxt.placeholder = language == "en" ? "Select Type" : "اختر صنف"
        self.communityAddressTxt.placeholder = language == "en" ? "Address" : "عنوان"
        self.CountryTxt.placeholder = language == "en" ? "Select Country" : "حدد الدولة"
        if language == "en" {
            self.update_btnRef.setTitle("UPDATE", for: .normal)
        }else if language == "ar" {
            self.update_btnRef.setTitle("تحديث", for: .normal)
        }
        if language .isEqual("en") || language .isEqual(""){
            self.CommunitytitleTxt.textAlignment = .left
            self.communityUniqueTxt.textAlignment = .left
            self.communityTypeTxt.textAlignment = .left
            self.communityAddressTxt.textAlignment = .left
            self.CountryTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.CommunitytitleTxt.textAlignment = .right
            self.communityUniqueTxt.textAlignment = .right
            self.communityTypeTxt.textAlignment = .right
            self.communityAddressTxt.textAlignment = .right
            self.CountryTxt.textAlignment = .right
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == CommunitytitleTxt {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }else if textField == communityUniqueTxt {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }else if textField == communityAddressTxt {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
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
    
    func countryNameOnly(){
        let fv = storyboard?.instantiateViewController(withIdentifier: "CountrySearchViewController")as! CountrySearchViewController
        self.navigationController?.present(fv, animated: true, completion: nil)
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        CountryTxt.text = name
        
    }
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        let name = defaults.value(forKey: "COUNTRYNAME") as? String
        CountryTxt.text = name
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == CountryTxt {
            self.countryNameOnly()
            self.view.endEditing(true)
        }else {
            
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if communityUniqueTxt.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    func selectedCountry(country: Country) {
        // self.countryTxt.text = "\("+")\(country.phoneExtension)"
        //  str_code = "+\(country.phoneExtension)"
        str_country = country.name! as NSString
        self.CountryTxt.text = str_country as String?
        print(country.phoneExtension)
        
    }
    
    // returns the # of rows in each component..
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return CommunityType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CommunityType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if row == 0 {
            communityTypeTxt.text = CommunityType[row]
            str_community = "1"
        }else {
            communityTypeTxt.text = CommunityType[row]
            str_community = "2"
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func CmaeraBtnAction(_ sender: Any) {
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
    
    @IBAction func updateBtnAction(_ sender: Any) {
        str_CommunityTitle = CommunitytitleTxt.text as NSString?
        str_CommunityName = communityUniqueTxt.text as NSString?
        str_CommunityType = communityTypeTxt.text as NSString?
        str_CommunityAddress = communityAddressTxt.text as NSString?
        str_country = CountryTxt.text as NSString?
        
        if str_CommunityTitle .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter title." : "الرجاء إدخال العنوان." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else if str_CommunityTitle.length < 3 || str_CommunityTitle.length > 55 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Title must be in 3-55 characters only." : "يجب أن يكون العنوان في 3-55 حرفًا فقط." , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_CommunityName .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter unique name." : "الرجاء إدخال اسم فريد" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else if str_CommunityName.length < 3 || str_CommunityName.length > 55 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Unique name must be in 3-55 characters only." : "يجب أن يكون الاسم الفريد من 3 إلى 55 حرفًا فقط.", buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_CommunityType .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter type." : "الرجاء إدخال النوع." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else  if str_CommunityAddress .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter address." : "من فضلك ادخل العنوان", buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else  if str_country .isEqual(to: "") {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter country." : "الرجاء إدخال البلد.", buttonTitle: self.language == "en" ? "OK" : "حسنا")
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:25)
                let data = UpdateCommunityModel()
                
                if imagedata == nil {
                    let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
                    let testImage = NSData(contentsOf: AddPicture_url as URL)
                    data.profile_picture = testImage!
                }
                else {
                    data.profile_picture = imagedata as NSData
                }
                data.CommunityID = Community_id
                data.CommunityTitle = str_CommunityTitle as String
                data.CommunityUniqueName  = str_CommunityName as String
                var str = 0
                if communityTypeTxt.text == "Corporate office"{
                    str = 2
                }else{
                    str = 1
                }
                data.CommunityType = str
                data.CommunityAddress = str_CommunityAddress as String
                data.Country = str_country as String
                data.Language = language
                // data.RoleId = roleId
                Parsing().HostGatesUpdateCommunity(data: data)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesUpdateCommunity"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateupdateCommunity), name: NSNotification.Name(rawValue: "HostGatesUpdateCommunity"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
        }
        
        
        
        //        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnaction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK:-DGLoclalization Delegate
extension EditCommunityViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
