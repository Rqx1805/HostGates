//
//  AddGateAccountsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class AddGateAccountsViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
   
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var GatenumbertxtField: UITextField!
    @IBOutlet weak var GateNameTxtField: UITextField!
    @IBOutlet weak var UserNameTxtField: UITextField!
    @IBOutlet weak var PasswordTxtField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var passwordHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var password_main_view: UIView!
    
    
    
    var DeivcePickerView: UIPickerView = UIPickerView()
    var DeivcePickerView1: UIPickerView = UIPickerView()
    var DeivcePickerView2: UIPickerView = UIPickerView()
    var DeivcePickerView3: UIPickerView = UIPickerView()
    var gate_id = String()
    var AddCommunityFlag = Bool()
    var defaults:UserDefaults!
    var str:String!
    var roleId:Int!
    var adminuserid:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var user_Id:Int!
    var role:Int!
    var deviceTocken = NSString()
    var deviceType:NSArray!
    var IdArray:NSArray!
    var id:Int!
    var id1:Int!
    var id2:Int!
    var id3:Int!
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    var deviceid1:String!
    var deviceid2:String!
    var deviceid3:String!
    var deviceid4:String!

    @IBOutlet weak var device1Txt: UITextField!
    @IBOutlet weak var device1macaddressTxt: UITextField!
    
    @IBOutlet weak var device2Txt: UITextField!
    @IBOutlet weak var device2macaddressTxt: UITextField!
    
    @IBOutlet weak var device3Txt: UITextField!
    @IBOutlet weak var device3macaddressTxt: UITextField!
    @IBOutlet weak var device4Txt: UITextField!
    @IBOutlet weak var device4macaddressTxt: UITextField!
    //MARK:- Login WebService
       @objc func HostGateAccountStatusAction(_ notification: Notification) {
           let status = (notification.userInfo?["status"] as? Int)!
           let str_message = (notification.userInfo?["message"] as? String)!
           
           DispatchQueue.main.async() {
               
               if status == 0{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                   self.removeAllOverlays()
                   self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
               }
               else if status == 1{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                   self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                   self.removeAllOverlays()
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
            
            GIFHUD.shared.dismiss()
            GIFHUD.shared.dismiss()
           }
       }
    
    
     @objc func HostGateDeviceListAction(_ notification: Notification) {
               let status = (notification.userInfo?["status"] as? Int)!
               let str_message = (notification.userInfo?["message"] as? String)!
               
               DispatchQueue.main.async() {
                   
                   if status == 0{
                       
                   }
                   else {
                    var deviceArray = NSMutableArray()
                    deviceArray = (notification.userInfo?["data"] as? NSMutableArray)!
                    print("response: \(deviceArray)")
                    self.deviceType = deviceArray.value(forKey: "name") as? NSArray
                    self.IdArray = deviceArray.value(forKey: "id") as? NSArray
                   }
             
               }
           }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        str = defaults.value(forKey: "Gate") as? String
        adminuserid = defaults.integer(forKey: "AdminUserId")
        user_Id = defaults.integer(forKey: "UserIDGet")
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        DeivcePickerView.delegate = self
        DeivcePickerView.dataSource = self
        device1Txt.inputView = DeivcePickerView
        
        device1Txt.delegate = self
        
        
        DeivcePickerView1.delegate = self
        DeivcePickerView1.dataSource = self
        device2Txt.inputView = DeivcePickerView1
       
        device2Txt.delegate = self
        
        DeivcePickerView2.delegate = self
        DeivcePickerView2.dataSource = self
        device3Txt.inputView = DeivcePickerView2
        
        device3Txt.delegate = self
        
        DeivcePickerView3.delegate = self
        DeivcePickerView3.dataSource = self
        device4Txt.inputView = DeivcePickerView3
        
        device4Txt.delegate = self
        
        device1macaddressTxt.delegate = self
        device2macaddressTxt.delegate = self
        device3macaddressTxt.delegate = self
        device4macaddressTxt.delegate = self
        
        if str == "Addgate" {
            self.titleLbl.text = language == "en" ? "Add Gate Account" : "إضافة حساب البوابة"
            self.submit_btn.setTitle(language == "en" ? "SUBMIT" : "إرسال", for: .normal)
            //self.password_main_view.isHidden = false
           // self.passwordHeightConstarints.constant = 45
//            self.UserNameTxtField.isUserInteractionEnabled = true
//            self.device1Txt.isUserInteractionEnabled = true
//            self.device2Txt.isUserInteractionEnabled = true
//            self.device3Txt.isUserInteractionEnabled = true
//            self.device4Txt.isUserInteractionEnabled = true
//            self.device1macaddressTxt.isUserInteractionEnabled = true
//            self.device2macaddressTxt.isUserInteractionEnabled = true
//            self.device3macaddressTxt.isUserInteractionEnabled = true
//            self.device4macaddressTxt.isUserInteractionEnabled = true
        }else {
            self.titleLbl.text = language == "en" ? "Edit Gate Account" : "تحرير حساب البوابة"
            self.submit_btn.setTitle(language == "en" ? "UPDATE" : "تحديث", for: .normal)
            //self.password_main_view.isHidden = true
           // self.passwordHeightConstarints.constant = 0
//            self.UserNameTxtField.isUserInteractionEnabled = false
//            self.device1Txt.isUserInteractionEnabled = false
//            self.device2Txt.isUserInteractionEnabled = false
//            self.device3Txt.isUserInteractionEnabled = false
//            self.device4Txt.isUserInteractionEnabled = false
//            self.device1macaddressTxt.isUserInteractionEnabled = false
//            self.device2macaddressTxt.isUserInteractionEnabled = false
//            self.device3macaddressTxt.isUserInteractionEnabled = false
//            self.device4macaddressTxt.isUserInteractionEnabled = false
        }
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        
        GatenumbertxtField.delegate = self
        GateNameTxtField.delegate = self
        UserNameTxtField.delegate = self
        PasswordTxtField.delegate = self
        
        if self.AddCommunityFlag == true{
            self.getDATA_API()
        }else{
            
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        //GIFHUD.shared.show(withOverlay: true, duration:1)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
                       NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                       NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
        
        Parsing().GetDeviceList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDeviceListAction), name: NSNotification.Name(rawValue: "GetDeviceList"), object: nil)
    }
    
    
    
    // PickerView Delegate.....
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     // returns the # of rows in each component..
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
         
             return deviceType.count
         
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return deviceType[row] as? String
     }
     
    
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
     {
        if pickerView == DeivcePickerView {
            device1Txt.text = deviceType[row] as? String
            id = IdArray[row] as? Int
        }else if  pickerView == DeivcePickerView1 {
            device2Txt.text = deviceType[row] as? String
            id1 = IdArray[row] as? Int
        }else if  pickerView == DeivcePickerView2 {
           device3Txt.text = deviceType[row] as? String
           id2 = IdArray[row] as? Int
        }else if  pickerView == DeivcePickerView3 {
            device4Txt.text = deviceType[row] as? String
            id3 = IdArray[row] as? Int
        }
        
     }
     
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         
         return true
     }
     
    
    //MARK:- language Function
    func decorate() {
       // self.GatenumbertxtField.placeholder = language == "en" ?  "Gate Number" : "رقم البوابة"
      //  self.GateNameTxtField.placeholder = language == "en" ? "Gate Name" : "اسم البوابة"
      //  self.UserNameTxtField.placeholder = language == "en" ? "Username" : "اسم المستخدم";
      //  self.PasswordTxtField.placeholder = language == "en" ? "Password" : "كلمه السر";
//        self.device1Txt.placeholder = language == "en" ? "Device1" : "الجهاز 1";
//        self.device2Txt.placeholder = language == "en" ? "Device2" : "الجهاز 2";
//        self.device3Txt.placeholder = language == "en" ? "Device3" : "الجهاز 3";
//        self.device4Txt.placeholder = language == "en" ? "Device4" : "الجهاز 4";
//
//
//        self.device1macaddressTxt.placeholder = language == "en" ? "Device 1 mac address" : "عنوان جهاز 1 ماك";
//        self.device2macaddressTxt.placeholder = language == "en" ? "Device 2 mac address" : "عنوان جهاز 2 ماك";
//        self.device3macaddressTxt.placeholder = language == "en" ? "Device 3 mac address" : "عنوان جهاز 3 ماك";
//        self.device4macaddressTxt.placeholder = language == "en" ? "Device 4 mac address" : "عنوان جهاز 4 ماك";
        
        
        if language .isEqual("en") || language .isEqual(""){
//            self.GatenumbertxtField.textAlignment = .left
//            self.GateNameTxtField.textAlignment = .left
//            self.UserNameTxtField.textAlignment = .left
//            self.PasswordTxtField.textAlignment = .left
//            self.device1Txt.textAlignment = .left
//            self.device2Txt.textAlignment = .left
//            self.device3Txt.textAlignment = .left
//            self.device4Txt.textAlignment = .left
//
//            self.device1macaddressTxt.textAlignment = .left
//            self.device2macaddressTxt.textAlignment = .left
//            self.device3macaddressTxt.textAlignment = .left
//            self.device4macaddressTxt.textAlignment = .left
          
        }else if language .isEqual("ar") {
//            self.GatenumbertxtField.textAlignment = .right
//            self.GateNameTxtField.textAlignment = .right
//            self.UserNameTxtField.textAlignment = .right
//            self.PasswordTxtField.textAlignment = .right
//            self.device1Txt.textAlignment = .right
//            self.device2Txt.textAlignment = .right
//            self.device3Txt.textAlignment = .right
//            self.device4Txt.textAlignment = .right
//            self.device1macaddressTxt.textAlignment = .right
//            self.device2macaddressTxt.textAlignment = .right
//            self.device3macaddressTxt.textAlignment = .right
//            self.device4macaddressTxt.textAlignment = .right
           
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == GatenumbertxtField {
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
        else if textField == GateNameTxtField {
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
        else if textField == UserNameTxtField {
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
        else if textField == PasswordTxtField {
            guard range.location == 0 else {
                return true
            }
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }else if textField == device1macaddressTxt {
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
        }else if textField == device2macaddressTxt {
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
        }else if textField == device3macaddressTxt {
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
        }else if textField == device4macaddressTxt {
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
    
    func getDATA_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:20)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(gate_id), forKey: "gate_id" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getGateData"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    let data = DataManager.getVal(responseData?.object(forKey: "data")) as! NSDictionary
                    let gate_name = DataManager.getVal(data["gate_name"]) as! String
                    let gate_number = DataManager.getVal(data["gate_number"]) as! String
                    let unique_name = DataManager.getVal(data["unique_name"]) as! String
                    let password = DataManager.getVal(data["password"]) as! String
                    let devicedata = DataManager.getVal(responseData?.object(forKey: "deviceData")) as! NSMutableArray
                   
                
                    let device1 = DataManager.getVal(data["scanner_device_id_1"]) as! String
                    let device2 = DataManager.getVal(data["scanner_device_id_2"]) as! String
                    let device3 = DataManager.getVal(data["scanner_device_id_3"]) as! String
                    let device4 = DataManager.getVal(data["scanner_device_id_4"]) as! String
                    
                    
                    self.deviceid1 = DataManager.getVal(data["scanner_device_id_1"]) as? String
                    self.deviceid2 = DataManager.getVal(data["scanner_device_id_2"]) as? String
                    self.deviceid3 = DataManager.getVal(data["scanner_device_id_3"]) as? String
                    self.deviceid4 = DataManager.getVal(data["scanner_device_id_4"]) as? String
                    
                    var idnew:String!
                    var idnew1:Int!
                    for i in 0..<devicedata.count {
                       var dict = NSDictionary()
                       dict = devicedata.object(at: i) as! NSDictionary
                       idnew = dict.value(forKey: "name") as? String
                       idnew1 = dict.value(forKey: "id") as? Int
                        let id1 = String(idnew1)
                        if device1 == id1 {
                          self.device1Txt.text = idnew
                        }else if device2 == id1 {
                             self.device2Txt.text = idnew
                        }else if device3 == id1 {
                             self.device3Txt.text = idnew
                        }else if device4 == id1 {
                             self.device4Txt.text = idnew
                        }
                    }
                    
                   
                    
                    let macaddress1 = DataManager.getVal(data["mac_address_1"]) as! String
                    let macaddress2 = DataManager.getVal(data["mac_address_2"]) as! String
                    let macaddress3 = DataManager.getVal(data["mac_address_3"]) as! String
                    let macaddress4 = DataManager.getVal(data["mac_address_4"]) as! String
                    
                    
                    self.GateNameTxtField.text = gate_name
                    self.GatenumbertxtField.text = gate_number
                    self.UserNameTxtField.text = unique_name
                    self.PasswordTxtField.text = password
//                    self.device1Txt.text = device1
//                    self.device2Txt.text = device2
//                    self.device3Txt.text = device3
//                    self.device4Txt.text = device4
                    self.device1macaddressTxt.text = macaddress1
                    self.device2macaddressTxt.text = macaddress2
                    self.device3macaddressTxt.text = macaddress3
                    self.device4macaddressTxt.text = macaddress4
                    GIFHUD.shared.dismiss()
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            })
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        
        if self.AddCommunityFlag == true{
            if ValidationClass().ValidateAddgateAccountForm1(self){
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:20)
                let parameterDictionary = NSMutableDictionary()
                parameterDictionary.setObject(DataManager.getVal(self.gate_id), forKey: "gate_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.GatenumbertxtField.text!), forKey: "gate_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.GateNameTxtField.text!), forKey: "gate_name" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UserNameTxtField.text!), forKey: "unique_name" as NSCopying)
                 parameterDictionary.setObject(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password" as NSCopying)
               
                if self.id == nil {
                    parameterDictionary.setObject(DataManager.getVal(self.deviceid1), forKey: "scanner_device_id_1" as NSCopying)
                }else {
                    parameterDictionary.setObject(DataManager.getVal(self.id), forKey: "scanner_device_id_1" as NSCopying)
                }
                if self.id1 == nil {
                  parameterDictionary.setObject(DataManager.getVal(self.deviceid2), forKey: "scanner_device_id_2" as NSCopying)

                }else {
                   parameterDictionary.setObject(DataManager.getVal(self.id1), forKey: "scanner_device_id_2" as NSCopying)
                }
                if self.id2 == nil {
                  parameterDictionary.setObject(DataManager.getVal(self.deviceid3), forKey: "scanner_device_id_3" as NSCopying)
                }else {
                   parameterDictionary.setObject(DataManager.getVal(self.id2), forKey: "scanner_device_id_3" as NSCopying)
                }
                if self.id3 == nil {
                   parameterDictionary.setObject(DataManager.getVal(self.deviceid4), forKey: "scanner_device_id_4" as NSCopying)
                }else {
                    parameterDictionary.setObject(DataManager.getVal(self.id3), forKey: "scanner_device_id_4" as NSCopying)
                }
               
                parameterDictionary.setObject(DataManager.getVal(self.device1macaddressTxt.text), forKey: "mac_address_1" as NSCopying)
                                              
                parameterDictionary.setObject(DataManager.getVal(self.device2macaddressTxt.text), forKey: "mac_address_2" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.device3macaddressTxt.text), forKey: "mac_address_3" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.device4macaddressTxt.text), forKey: "mac_address_4" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal("en"), forKey: "language" as NSCopying)
                print(parameterDictionary)
                
                let methodName = "updateGate"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            GIFHUD.shared.dismiss()
                            self.showAlertUpate(message: message)
                        }else{
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                        }
//                        self.removeAllOverlays()
                        GIFHUD.shared.dismiss()
                    })
                }
            }
        }else{
            if ValidationClass().ValidateAddgateAccountForm(self){
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:20)
                let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "UserIDGet")) as! String
                let CommunityID = DataManager.getVal(Config().AppUserDefaults.value(forKey: "CommunityID")) as! String
                let parameterDictionary = NSMutableDictionary()
                
                parameterDictionary.setObject(DataManager.getVal(user_id), forKey: "user_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(CommunityID), forKey: "community_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.roleId), forKey: "role_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.adminuserid), forKey: "admin_user_id" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.UserNameTxtField.text!), forKey: "unique_name" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.GatenumbertxtField.text!), forKey: "gate_number" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.GateNameTxtField.text!), forKey: "gate_name" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password" as NSCopying)
                
                 parameterDictionary.setObject(DataManager.getVal(self.id), forKey: "scanner_device_id_1" as NSCopying)
                
                 parameterDictionary.setObject(DataManager.getVal(self.id1), forKey: "scanner_device_id_2" as NSCopying)
                 parameterDictionary.setObject(DataManager.getVal(self.id2), forKey: "scanner_device_id_3" as NSCopying)
                 parameterDictionary.setObject(DataManager.getVal(self.id3), forKey: "scanner_device_id_4" as NSCopying)
                
                
                parameterDictionary.setObject(DataManager.getVal(self.device1macaddressTxt.text), forKey: "mac_address_1" as NSCopying)
                               
                parameterDictionary.setObject(DataManager.getVal(self.device2macaddressTxt.text), forKey: "mac_address_2" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.device3macaddressTxt.text), forKey: "mac_address_3" as NSCopying)
                parameterDictionary.setObject(DataManager.getVal(self.device4macaddressTxt.text), forKey: "mac_address_4" as NSCopying)
            
                
                parameterDictionary.setObject(DataManager.getVal(""), forKey: "language" as NSCopying)
                print(parameterDictionary)
                
                let methodName = "addGate"
                
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            GIFHUD.shared.dismiss()
                            self.showAlertUpate(message: message)
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
    
}

//MARK:-DGLoclalization Delegate
extension AddGateAccountsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
