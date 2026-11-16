//
//  RESQRCODEViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 13/01/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class RESQRCODEViewController: UIViewController {
    
    @IBOutlet weak var passcardview: UIView!
    @IBOutlet weak var qrimage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var req_main_view: UIView!
    
    var comType:Int!
    var user_id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var communityID:Int!
    var updateImage:String!
    var titlel:String!
    var user_sts = String()
    var defaults: UserDefaults!
    var role:Int!
    
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
                self.req_main_view.isHidden = false
                let response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(String(describing: response))")
                self.updateImage = response.value(forKey: "qrcode") as? String
                let AddPicture_url1: NSURL = NSURL(string: self.updateImage)!
                self.qrimage.sd_setImage(with: AddPicture_url1 as URL?, placeholderImage: UIImage(named: "load_logo"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                }
                var colorcode = String()
                colorcode = response.value(forKey: "color_code") as! String
                self.passcardview.backgroundColor = self.hexStringToUIColor(hex: colorcode)
                self.nameLbl.text = response.value(forKey: "name") as? String
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
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        self.req_main_view.isHidden = true
        defaults = UserDefaults.standard
       let language = defaults.value(forKey: "Language") as? String
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        self.comType = defaults.integer(forKey: "COMTYPE")
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        communityID = defaults.integer(forKey: "COMNEWID")
        passcardview.layer.cornerRadius =  5
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:20)
        Parsing().HostGateUserHostPass(Language: language, UserId: user_id, RoleId: roleId, AdminUserid: adminuserid, Role: role, Community_Id: communityID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateHostPassAction), name: NSNotification.Name(rawValue: "HostGateUserHostPass"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
