//
//  GateVisitorDetailViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 05/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class GateVisitorDetailViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var profileIMage: UIImageView!
    @IBOutlet weak var employee_name: UILabel!
    @IBOutlet weak var buliding_no: UILabel!
    @IBOutlet weak var buildNumber: UILabel!
    @IBOutlet weak var unit_no: UILabel!
    @IBOutlet weak var UnitNumber: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var pincode: UILabel!
    @IBOutlet weak var pincodeLbl: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var check_in: UILabel!
    @IBOutlet weak var checkInLbl: UILabel!
    @IBOutlet weak var check_out: UILabel!
    @IBOutlet weak var checkOutLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var stsLbl: UILabel!
    
    var defaults:UserDefaults!
    var visitorID:Int!
    var updateImage:String!
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    
    @objc func HostGateVisitorDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorDetailNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                let response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                self.updateImage = response.value(forKey: "profile_picture") as? String
                let AddPicture_url1: NSURL = NSURL(string: self.updateImage)!
                self.profileIMage.sd_setImage(with: AddPicture_url1 as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                self.buildNumber.text = response.value(forKey: "building_number") as? String
                self.UnitNumber.text = response.value(forKey: "unit_number") as? String
                self.NameLbl.text = response.value(forKey: "name") as? String
                var count = Int()
                count = response.value(forKey: "count") as! Int
                var countStr = String()
                countStr = String(count)
                self.countLbl.text = countStr
                self.typeLbl.text = response.value(forKey: "type") as? String
                self.pincodeLbl.text = response.value(forKey: "pin_code") as? String
                self.dateTimeLbl.text = response.value(forKey: "date_time") as? String
                self.checkInLbl.text = response.value(forKey: "in_datetime") as? String
                self.checkOutLbl.text = response.value(forKey: "out_datetime") as? String
                self.stsLbl.text = response.value(forKey: "status") as? String
                if self.stsLbl.text == "Active" {
                    self.stsLbl.textColor = UIColor(red: 80/255, green: 155/255, blue: 90/255, alpha: 1.0)
                }else if self.stsLbl.text == "Cancelled" {
                    self.stsLbl.textColor = UIColor.red
                }else if self.stsLbl.text == "Expired" {
                    self.stsLbl.textColor = UIColor.yellow
                }else if self.stsLbl.text == "Completed" {
                    self.stsLbl.textColor = UIColor(red: 56/255, green: 180/255, blue: 56/255, alpha: 1.0)
                }else if self.stsLbl.text == "Pending" {
                    self.stsLbl.textColor = UIColor(red: 228/255, green: 172/255, blue: 88/255, alpha: 1.0)
                }else if self.stsLbl.text == "Upcoming" {
                    self.stsLbl.textColor = UIColor.yellow
                }
                else if self.stsLbl.text == "Past" {
                    self.stsLbl.textColor = UIColor.yellow
                }
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
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        visitorID = defaults.integer(forKey: "VISTORID")
        role = defaults.integer(forKey: "ROLE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        //MARK:- language Code Start
               defaults = UserDefaults.standard
               language = defaults.value(forKey: "Language") as? String
        
        profileIMage.layer.cornerRadius = profileIMage.frame.height/2
        profileIMage.layer.masksToBounds = true
        profileIMage.clipsToBounds = true
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorDetail(Language: language, VisitorId: visitorID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorDetailAction), name: NSNotification.Name(rawValue: "HostGateVisitorDetailNotification"), object: nil)
        
        
       
        
        self.title_lbl.text = language == "en" ? "Visitor Details" : "تفاصيل الزائر"
        self.buliding_no.text = language == "en" ? "Building Number" : "رقم المبنى"
        self.unit_no.text = language == "en" ? "Unit/Floor Number" : "وحدة / رقم الطابق"
        self.name.text = language == "en" ? "Name" : "اسم"
        self.count.text = language == "en" ? "Count" : "العدد"
        self.type.text = language == "en" ? "Type" : "النوع"
        self.pincode.text = language == "en" ? "Pin Code" : "الرقم السري"
        self.date_time.text = language == "en" ? "Date/Time": "تاريخ / وقت"
        self.check_in.text = language == "en" ? "Check-In": "وقت الدخول"
        self.check_out.text = language == "en" ? "Check-Out" : "وقت الخروج"
        self.status.text = language == "en" ? "Status" : "الحالة"
        
       // GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

