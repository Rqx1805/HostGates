//
//  ProperPassview.swift
//  HostGate
//
//  Created by tarun-mac-6 on 02/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import GiFHUD_Swift

class ProperPassview: UIView {
    
    @IBOutlet weak var passcardview: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var empNumberLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var buildingNoLbl: UILabel!
    @IBOutlet weak var UnitNumberLbl: UILabel!
    @IBOutlet weak var officeNoLbl: UILabel!
    
    @IBOutlet weak var bldNumLbl: UILabel!
    @IBOutlet weak var UnitIDnoLbl: UILabel!
    @IBOutlet weak var nationalIDLbl: UILabel!
    @IBOutlet weak var nationalityLbl: UILabel!
    @IBOutlet weak var flUnNOLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var ofNoLbl: UILabel!
    @IBOutlet weak var lineLbl2: UILabel!
    @IBOutlet weak var comtitleLbl: UILabel!
    @IBOutlet weak var hot_pass: UILabel!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    
    var user_id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var communityID:Int!
    var updateImage:String!
    var role:Int!
    var defaults:UserDefaults!
    var comType:Int!
    var buttonCancelHandler : (() -> Void)?
    class func intitiateFromNib() -> ProperPassview {
        let View1 = UINib.init(nibName: "ProperPassview", bundle: nil).instantiate(withOwner: self, options: nil).first as! ProperPassview
        return View1
    }
    
    
    
    @objc func HostGateHostPassAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.buttonCancelHandler?()
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserHostPass"), object: nil)
            }else{
                let response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                
                if self.comType == 1 {
                    self.bldNumLbl.text = self.language == "en" ? "Building Number" : "رقم المبنى"
                    self.UnitIDnoLbl.text = self.language == "en" ? "Unit/Floor Number" : "وحدة / رقم الطابق"
                    self.nationalIDLbl.text = self.language == "en" ? "National ID / Passport Number" : "رقم الهوية الوطنية / جواز السفر";
                    self.nationalityLbl.text = self.language == "en" ? "Nationality" : "جنسية"
                    self.UnitNumberLbl.isHidden = true
                    self.officeNoLbl.isHidden = true
                    self.flUnNOLbl.isHidden = true
                    self.lineLbl.isHidden = true
                    self.ofNoLbl.isHidden = true
                    self.lineLbl2.isHidden = true
                    self.updateImage = response.value(forKey: "profile_picture") as? String
                    let AddPicture_url1: NSURL = NSURL(string: self.updateImage)!
                    self.profileImageView.sd_setImage(with: AddPicture_url1 as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                        
                    }
                    
                    self.empNameLbl.text = response.value(forKey: "name") as? String
                    self.empNumberLbl.text = response.value(forKey: "building_number") as? String
                    self.departmentLbl.text = response.value(forKey: "unit_number") as? String
                    self.titleLbl.text = response.value(forKey: "national_id") as? String
                    self.buildingNoLbl.text = response.value(forKey: "country_id_number") as? String
                    self.comtitleLbl.text = response.value(forKey: "community_name") as? String
                    var colorcode = String()
                    colorcode = response.value(forKey: "color_code") as! String
                    self.passcardview.backgroundColor = self.hexStringToUIColor(hex: colorcode)
                }else {
                    self.updateImage = response.value(forKey: "profile_picture") as? String
                    let AddPicture_url1: NSURL = NSURL(string: self.updateImage)!
                    self.profileImageView.sd_setImage(with: AddPicture_url1 as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                        
                    }
                    
                    self.empNameLbl.text = response.value(forKey: "name") as? String
                    self.empNumberLbl.text = response.value(forKey: "employee_number") as? String
                    self.departmentLbl.text = response.value(forKey: "department") as? String
                    self.titleLbl.text = response.value(forKey: "title") as? String
                    self.buildingNoLbl.text = response.value(forKey: "building_number") as? String
                    self.UnitNumberLbl.text = response.value(forKey: "unit_number") as? String
                    self.officeNoLbl.text = response.value(forKey: "office_number") as? String
                    self.comtitleLbl.text = response.value(forKey: "community_name") as? String
                    var colorcode = String()
                    colorcode = response.value(forKey: "color_code") as! String
                    self.passcardview.backgroundColor = self.hexStringToUIColor(hex: colorcode)
                }
                
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        role = defaults.integer(forKey: "PERROLEID")
        adminuserid = defaults.integer(forKey: "PERNEWUSER")
        roleId = defaults.integer(forKey: "PERUSERID")
        comType = defaults.integer(forKey: "COMTYPE")
        user_id = defaults.integer(forKey: "PERID")
        communityID = defaults.integer(forKey: "COMNEWID")
        
        //MARK:- language Code Start
               defaults = UserDefaults.standard
               language = defaults.value(forKey: "Language") as? String
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        passcardview.layer.cornerRadius =  5
        
        
        Parsing().HostGateUserHostPass(Language: language, UserId: user_id, RoleId: roleId, AdminUserid: adminuserid, Role: role, Community_Id: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateHostPassAction), name: NSNotification.Name(rawValue: "HostGateUserHostPass"), object: nil)
        
       
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    
    //MARK:- language Function
    func decorate() {
        
        self.hot_pass.text = self.language == "en" ? "Pass Card" : "بطاقة مرور"
        self.bldNumLbl.text = self.language == "en" ? "Employee Number" : "رقم الموظف"
        self.UnitIDnoLbl.text = self.language == "en" ? "Department" : "قسم"
        self.nationalIDLbl.text = self.language == "en" ? "Title" : "عنوان"
        self.nationalityLbl.text = self.language == "en" ? "Building Number" : "رقم المبنى"
        self.flUnNOLbl.text = self.language == "en" ? "Floor/Unit Number" : "رقم الطابق / الوحدة"
        self.ofNoLbl.text = self.language == "en" ? "Office Number" : "رقم المكتب"
    }
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
}

//MARK:-DGLoclalization Delegate
extension ProperPassview:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}




