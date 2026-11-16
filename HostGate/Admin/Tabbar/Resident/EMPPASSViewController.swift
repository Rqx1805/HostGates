//
//  EMPPASSViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 13/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class EMPPASSViewController: UIViewController {
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user_sts = String()
    var defaults: UserDefaults!
    var role:Int!
    
    //MARK:- IBOutlet
    @IBOutlet weak var emplyoeeNo: UILabel!
    @IBOutlet weak var empNoLbl: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var Titlelbl: UILabel!
    @IBOutlet weak var bulidingno: UILabel!
    @IBOutlet weak var buildNoLbl: UILabel!
    @IBOutlet weak var floor_unitno: UILabel!
    @IBOutlet weak var unitNoLbl: UILabel!
    @IBOutlet weak var officeNo: UILabel!
    @IBOutlet weak var officeNoLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var passcardView: UIView!
    @IBOutlet weak var tlLbl: UILabel!
    
    
    var comType:Int!
    var user_id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var communityID:Int!
    var updateImage:String!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateHostPassAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserHostPass"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                let response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                self.updateImage = response.value(forKey: "profile_picture") as? String
                let AddPicture_url1: NSURL = NSURL(string: self.updateImage)!
                self.profileImage.sd_setImage(with: AddPicture_url1 as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                self.empNameLbl.text = response.value(forKey: "name") as? String
                self.empNoLbl.text = response.value(forKey: "employee_number") as? String
                self.departmentLbl.text = response.value(forKey: "department") as? String
                self.Titlelbl.text = response.value(forKey: "title") as? String
                self.buildNoLbl.text = response.value(forKey: "building_number") as? String
                self.unitNoLbl.text = response.value(forKey: "unit_number") as? String
                self.officeNoLbl.text = response.value(forKey: "office_number") as? String
                self.tlLbl.text = response.value(forKey: "title") as? String
                var colorcode = String()
                colorcode = response.value(forKey: "color_code") as! String
                self.passcardView.backgroundColor = self.hexStringToUIColor(hex: colorcode)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
                GIFHUD.shared.dismiss()
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
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
        language = defaults.value(forKey: "Language") as? String
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        self.comType = defaults.integer(forKey: "COMTYPE")
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        communityID = defaults.integer(forKey: "COMNEWID")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
        passcardView.layer.cornerRadius =  5
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateUserHostPass(Language: language, UserId: user_id, RoleId: roleId, AdminUserid: adminuserid, Role: role, Community_Id: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateHostPassAction), name: NSNotification.Name(rawValue: "HostGateUserHostPass"), object: nil)
        
      
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
       
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.emplyoeeNo.text = language == "en" ? "Employee Number" : "رقم الموظف"
        self.bulidingno.text = language == "en" ? "Building Number" : "رقم المبنى"
        self.floor_unitno.text = language == "en" ? "Unit/Floor Number" : "وحدة / رقم الطابق"
        self.officeNo.text = language == "en" ? "Office Number" : "رقم المكتب"
        self.department.text = language == "en" ? "Department" : "قسم"
        self.titleLbl.text = language == "en" ? "Title" : "عنوان"
        
    }
    
    
}


//MARK:-DGLoclalization Delegate
extension EMPPASSViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
