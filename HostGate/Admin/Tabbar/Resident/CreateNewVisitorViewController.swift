//
//  CreateNewVisitorViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class CreateNewVisitorViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var visitorTypeTxt: UITextField!
    @IBOutlet weak var visitorCountsTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var name_txt_ref: UITextView!
    
    
    var str_type:NSString!
    var str_count:NSString!
    var str_date:NSString!
    var str_time:NSString!
    
    var defaults: UserDefaults!
    var role:Int!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var str:String!
    var communityId:Int!
    var pickerview: UIPickerView! = UIPickerView()
    var tyepArray = NSMutableArray()
    var idarray = NSArray()
    var nameArray = NSArray()
    var visID:Int!
    var visitor_id:Int!
    var datepicker:UIDatePicker! = UIDatePicker()
    var timepicker:UIDatePicker! = UIDatePicker()
    var str_name:NSString!
    let identifierManager = ASIdentifierManager.shared()
       var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateVisitorRecordListByUseridAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorsTypeListbyUserId"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.tyepArray = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.tyepArray))")
                self.nameArray = self.tyepArray.value(forKey: "type") as! NSArray
                self.idarray = self.tyepArray .value(forKey: "visitortype_id") as! NSArray
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    
    @objc func HostGateAddVisitorAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserAddVisitorsRecord"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                self.showAlert(message: str_message)
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("AddVisitorRecord"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserAddVisitorsRecord"), object: nil)
            //                self.removeAllOverlays()
            GIFHUD.shared.dismiss()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func HostGateUpdateVisitorAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserUpdateVisitorsRecord"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.showAlert(message: str_message)
            }
        }
    }
    
    func showAlertUpate(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("UpdateVisitorRecord"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserUpdateVisitorsRecord"), object: nil)
            //                self.removeAllOverlays()
            GIFHUD.shared.dismiss()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func HostGateGetVisitors(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserGetVisitorsRecord"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                
                self.visitorTypeTxt.text = response.value(forKey: "visitor_type") as? String
                self.name_txt_ref.textColor = .black
                self.name_txt_ref.text = response.value(forKey: "name") as? String
                var count = Int()
                count = response.value(forKey: "count") as! Int
                var countstr = String()
                countstr = String(count)
                self.visitorCountsTxt.text =  countstr
                self.dateTxt.text =  response.value(forKey: "date") as? String
                self.timeTxt.text =  response.value(forKey: "time") as? String
                self.visID = response.value(forKey: "visitor_type_id") as? Int
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserGetVisitorsRecord"), object: nil)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set("Remove", forKey: "VISEDIT")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        self.name_txt_ref.layer.cornerRadius = 6
        self.name_txt_ref.clipsToBounds = true
        language = defaults.value(forKey: "Language") as? String
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        communityId = defaults.integer(forKey: "COMNEWID")
        str = defaults.value(forKey: "VISEDIT") as? String
        visitor_id = defaults.integer(forKey: "VISNEWID")
        if identifierManager.isAdvertisingTrackingEnabled {
                   deviceId = identifierManager.advertisingIdentifier.uuidString
               }
        pickerview.delegate = self
        pickerview.dataSource = self
        dateTxt.delegate = self
        timeTxt.delegate = self
        self.name_txt_ref.delegate = self
        self.name_txt_ref.textColor = .lightGray
        visitorCountsTxt.delegate = self
        visitorTypeTxt.inputView = pickerview
        visitorTypeTxt.delegate = self
        datepicker.datePickerMode = UIDatePicker.Mode.date
        dateTxt.inputView = datepicker
        datepicker.minimumDate = Date()
        datepicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        timepicker.datePickerMode = UIDatePicker.Mode.time
        timeTxt.inputView = timepicker
//        timepicker.minimumDate = Date()
        timepicker.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: UIControl.Event.valueChanged)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorsTypeListbyUserId(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, CommunityID: communityId, Role: role)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListByUseridAction), name: NSNotification.Name(rawValue: "HostGateVisitorsTypeListbyUserId"), object: nil)
        
        
        if str == "add" {
            titlelbl.text = language == "en" ? "Add Visitor" : "أضف الزائر"
            self.btnSubmit.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
            
        }else {
            titlelbl.text = language == "en" ? "Edit Visitor" : "تحرير الزائر"
            self.btnSubmit.setTitle(language == "en" ? "UPDATE" : "تحديث", for: .normal)
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateUserGetVisitorsRecord(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, Role: role, Visitor_Id: visitor_id)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserGetVisitorsRecord"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetVisitors), name: NSNotification.Name(rawValue: "HostGateUserGetVisitorsRecord"), object: nil)
        }
        
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
    
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Name/Name's" || textView.text == "الأسم/الأسماء" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = language == "en" ? "Name/Name's" : "الأسم/الأسماء"
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.visitorTypeTxt.placeholder = language == "en" ? "Select visitor type" : "حدد نوع الزائر"
        self.visitorCountsTxt.placeholder = language == "en" ? "Count" : "العدد"
        self.name_txt_ref.text = language == "en" ? "Name/Name's" :  "الأسم/الأسماء"
        self.dateTxt.placeholder = language == "en" ? "Date" : "تاريخ"
        self.timeTxt.placeholder = language == "en" ? "Time" : "زمن"
        if language == "en" {
            self.visitorTypeTxt.textAlignment = .left
            self.name_txt_ref.textAlignment = .left
            self.visitorCountsTxt.textAlignment = .left
            self.dateTxt.textAlignment = .left
            self.timeTxt.textAlignment = .left
        }else if language == "ar" {
            self.visitorTypeTxt.textAlignment = .right
            self.name_txt_ref.textAlignment = .right
            self.visitorCountsTxt.textAlignment = .right
            self.dateTxt.textAlignment = .right
            self.timeTxt.textAlignment = .right
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == nameTxt {
//            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//                guard range.location == 0 else {
//                    return true
//                }
//                let currentString: NSString = (textField.text ?? "") as NSString
//                let newString = currentString.replacingCharacters(in: range, with: string)
//                return  validate(string: newString)
//            }else {
//
//                let maxLength = 55
//                let currentString: NSString = textField.text! as NSString
//                let newString: NSString =
//                    currentString.replacingCharacters(in: range, with: string) as NSString
//                return newString.length <= maxLength
//            }
//
//        }else
        if textField == visitorCountsTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 5
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }
        else {
            return false
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
        if  textField == dateTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dateString1 = dateFormatter1.string(from: datepicker.date)
            dateTxt.text = dateString1
        }else if textField == timeTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm"
            let dateString1 = dateFormatter1.string(from: timepicker.date)
            timeTxt.text = dateString1
        }else if visitorTypeTxt.text == "" {
            self.pickerView(pickerview, didSelectRow: 0, inComponent: 0)
        }
    }
    
    
    
    //MARK:- Date Button Action
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datepicker.date)
        dateTxt.text = dateString
        
    }
    
    //MARK:- Date Button Action
    @objc func handleDatePicker1(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: timepicker.date)
        timeTxt.text = dateString
    }
    
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return nameArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return nameArray[row] as? String
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if nameArray.count == 0 {
            
        }else {
            visitorTypeTxt.text = nameArray[row] as? String
            visID = idarray[row] as? Int
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        if str == "add" {
            str_type = visitorTypeTxt.text as NSString?
            str_count = visitorCountsTxt.text as NSString?
            str_date = dateTxt.text as NSString?
            str_time = timeTxt.text as NSString?
            str_name = name_txt_ref.text as NSString?
            if str_type .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select visitor type" : "يرجى اختيار نوع الزائر" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter visitor count" : "الرجاء إدخال عدد الزوار" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "0"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "00"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "000"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "0000"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "00000"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            else if str_date .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter date" : "يرجى إدخال التاريخ" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_time .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter time" : "يرجى إدخال الوقت" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_name.length < 0 || str_name.length > 255 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Name must be less than 255 characters only." : "يجب أن يكون الاسم أقل من 255 حرفًا فقط." , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if Reachability.isConnectedToNetwork() == true {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:3)
                    Parsing().HostGateUserAddVisitorsRecord(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, CommunityID: communityId, Role: role, Visitor_Type_Id: visID, Name: str_type as String?, Date1: str_date as String?, Time: str_time as String?, Count: str_count as String?, VisName: str_name as String?)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAddVisitorAction), name: NSNotification.Name(rawValue: "HostGateUserAddVisitorsRecord"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            }
        }else {
            str_type = visitorTypeTxt.text as NSString?
            str_count = visitorCountsTxt.text as NSString?
            str_date = dateTxt.text as NSString?
            str_time = timeTxt.text as NSString?
            str_name = name_txt_ref.text as NSString?
            if str_type .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select visitor type" : "يرجى اختيار نوع الزائر" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter visitor count" : "الرجاء إدخال عدد الزوار"  , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "0"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "00"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "000"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "0000"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_count .isEqual(to: "00000"){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid visitor count" : "الرجاء إدخال عدد زوار صالح" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            else if str_date .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter date" : "يرجى إدخال التاريخ" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_time .isEqual(to: ""){
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter time" : "يرجى إدخال الوقت" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }else if str_name.length < 0 || str_name.length > 255 {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Name must be less than 255 characters only." : "يجب أن يكون الاسم أقل من 255 حرفًا فقط." , buttonTitle: language == "en" ? "OK" : "حسنا")
            }else {
                if Reachability.isConnectedToNetwork() == true {
//                    showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:3)
                    Parsing().HostGateUserUpdateVisitorsRecord(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, CommunityID: communityId, Role: role, Visitor_Type_Id: visID, Name: str_type as String?, Date1: str_date as String?, Time: str_time as String?, Count: str_count as String?, Visitor_Id: visitor_id, VisName: str_name as String?)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateVisitorAction), name: NSNotification.Name(rawValue: "HostGateUserUpdateVisitorsRecord"), object: nil)
                }else {
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            }
        }
    }
    
}

//MARK:-DGLoclalization Delegate
extension CreateNewVisitorViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
