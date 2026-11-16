
//
//  GateProfileDetailVC.swift
//  HostGate
//
//  Created by Vipul on 04/04/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import GiFHUD_Swift

class GateProfileDetailVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var title_lbl_ref: UILabel!
    @IBOutlet weak var community_txt_ref: UITextField!
    @IBOutlet weak var gate_no_txt_ref: UITextField!
    @IBOutlet weak var gate_name_txt_ref: UITextField!
    @IBOutlet weak var username_txt_ref: UITextField!
    
    //MARK:- Variables
    var defaults:UserDefaults!
    var user_id:Int!
    var language:String!
    var roleId:Int!
    
    //MARK:- LIfe view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        
        self.languageChange()
        
        GIFHUD.shared.show(withOverlay: true, duration:2)
        Parsing().HostGateUserDetail(Language: self.language, user_Id: self.user_id, RoleId: self.roleId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetUserDetailAction), name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
    }
    
    //MARK:- IBAction
    @IBAction func back_bnt_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Private function
    func languageChange(){
        self.title_lbl_ref.text = language == "en" ? "Update Personal Details" : "تحديث التفاصيل الشخصية"
        self.gate_no_txt_ref.placeholder = language == "en" ? "Gate Number" : "رقم البوابة"
        self.gate_name_txt_ref.placeholder = language == "en" ? "Gate Name" : "اسم البوابة"
        self.community_txt_ref.placeholder = language == "en" ? "Community" : "تواصل اجتماعي"
        self.username_txt_ref.placeholder = language == "en" ? "Username" : "اسم المستخدم"
    }
    
    //MARK:- detail web service
    @objc func HostGateGetUserDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
                //                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                self.community_txt_ref.isUserInteractionEnabled = false
                self.gate_name_txt_ref.isUserInteractionEnabled = false
                self.gate_no_txt_ref.isUserInteractionEnabled = false
                self.username_txt_ref.isUserInteractionEnabled = false
                self.community_txt_ref.text = self.defaults.value(forKey: "CommunityForGateProfile") as? String ?? ""
                self.gate_name_txt_ref.text = response.value(forKey: "gate_name") as? String ?? ""
                self.gate_no_txt_ref.text = response.value(forKey: "gate_number") as? String ?? ""
                self.username_txt_ref.text = response.value(forKey: "username") as? String ?? ""
                GIFHUD.shared.dismiss()
            }
        }
    }
}
