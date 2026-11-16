//
//  VisitorCheckOutViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 04/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class VisitorCheckOutViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var update_btn: UIButton!
    
    
    var str_date:NSString!
    var str_time:NSString!
    
    var defaults:UserDefaults!
    var visitorId:Int!
    var Pincode:String!
    
    var datepicker:UIDatePicker! = UIDatePicker()
    var datepicker1:UIDatePicker! = UIDatePicker()
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateCheckOutVisitorAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorCheckOutNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                self.dateTxt.text = ""
                self.timeTxt.text = ""
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.post(name: NSNotification.Name("CheckOut"), object: nil)
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorCheckOutNotification"), object: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
         language = defaults.value(forKey: "Language") as? String
        visitorId = defaults.integer(forKey: "VISTORID")
        Pincode = defaults.value(forKey: "PINCODE") as? String
        role = defaults.integer(forKey: "ROLE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        dateTxt.delegate = self
        timeTxt.delegate = self
        datepicker.datePickerMode = UIDatePicker.Mode.date
        dateTxt.inputView = datepicker
        datepicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        
        datepicker1.datePickerMode = UIDatePicker.Mode.time
        timeTxt.inputView = datepicker1
        datepicker1.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: UIControl.Event.valueChanged)
        
        //MARK:- language Code Start
        
        if language == "en" {
            self.update_btn.setTitle("SUBMIT", for: .normal)
        }else if language == "ar" {
            self.update_btn.setTitle("إرسال", for: .normal)
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
    
    
    //MARK:- language Function
    func decorate() {
        self.title_lbl.text = language == "en" ? "Check-Out" : "الدفع"
        self.dateTxt.placeholder = language == "en" ? "Enter date" : "أدخل التاريخ"
        self.timeTxt.placeholder = language == "en" ? "Enter time" : "أدخل الوقت"
        if language .isEqual("en") || language .isEqual(""){
            self.dateTxt.textAlignment = .left
            self.timeTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.dateTxt.textAlignment = .right
            self.timeTxt.textAlignment = .right
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == dateTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dateString1 = dateFormatter1.string(from: datepicker.date)
            dateTxt.text = dateString1
        }else if textField == timeTxt {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "hh:mm a"
            let dateString1 = dateFormatter1.string(from: datepicker1.date)
            timeTxt.text = dateString1
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
        dateFormatter.dateFormat = "hh:mm"
        let dateString = dateFormatter.string(from: datepicker1.date)
        timeTxt.text = dateString
    }
    
    @IBAction func backbtnaction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        str_date = dateTxt.text as NSString?
        str_time = timeTxt.text as NSString?
        var datetime = String()
        if str_date .isEqual(to: "") || str_time .isEqual(to: "") {
            datetime = ""
        }else {
            datetime = (str_date as String) + (str_time as String)
        }
        
        
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateVisitorCheckOut(Language: language, VisitorId: visitorId, PinCode: Pincode, Out_Datetime: datetime)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorCheckOutNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateCheckOutVisitorAction), name: NSNotification.Name(rawValue: "HostGateVisitorCheckOutNotification"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        
    }
    
}

//MARK:-DGLoclalization Delegate
extension VisitorCheckOutViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
