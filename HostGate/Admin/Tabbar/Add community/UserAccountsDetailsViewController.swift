//
//  UserAccountsDetailsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class UserAccountsDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlet
    @IBOutlet weak var subAccountTableview: UITableView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var owner_name: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var phonelbl: UILabel!
    @IBOutlet weak var assign_gatelbl: UILabel!
    @IBOutlet weak var assign_gate: UILabel!
    @IBOutlet weak var unit_numberlbl: UILabel!
    @IBOutlet weak var unit_number: UILabel!
    @IBOutlet weak var buliding_numberlbl: UILabel!
    @IBOutlet weak var buliding_number: UILabel!
    @IBOutlet weak var sub_acccountt: UILabel!
    
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    var dGlocale = DGLocalization()
    var referseControl = UIRefreshControl()
    var noDataLabel = UILabel()
    var community_type:String!
    var responseDict = NSDictionary()
    var response = NSMutableArray()
    var property_id = String()
    var str = String()
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var UserId:Int!
    var deviceTocken = NSString()
    
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
               }
               else if status == 1{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                   self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                   self.removeAllOverlays()
                
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
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        UserId = defaults.integer(forKey: "UserIDGet")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        self.dataNotFound()
        community_type = defaults.value(forKey: "community_type") as? String
        if community_type == "Residential Complex" || community_type == "مجمع سكني"{
            
        }else{
            self.subAccountTableview.isHidden = true
            self.sub_acccountt.isHidden = true
            self.noDataLabel.isHidden = true
        }
        community_type = community_type == "Residential Complex" ? "1" : "2"
        self.titlelbl.text = defaults.value(forKey: "community_name") as? String
        
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        debugPrint(property_id)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().UserAccountDetailsList(PropertyId: property_id, CommunityType: community_type)
        NotificationCenter.default.addObserver(self, selector: #selector(self.UserAccountDetailsList), name: NSNotification.Name(rawValue: "UserAccountDetailsList"), object: nil)
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: UserId, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
    }
    
    //MARK:- language Function
       func decorate() {
           self.assign_gatelbl.text = language == "en" ? "Assigned gates count" : "عدد البوابات المخصصة"
           self.unit_numberlbl.text = language == "en" ? "Unit/Floor No." : "وحدة / رقم الطابق"
           self.buliding_numberlbl.text = self.language == "en" ? "Building Number" : "رقم المبنى"
           self.sub_acccountt.text = language == "en" ? "Sub Account" : "حساب فرعي"
       }
    
    @objc func UserAccountDetailsList(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.noDataLabel.isHidden = false
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UserAccountDetailsList"), object: nil)
                self.response.removeAllObjects()
                self.subAccountTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                self.responseDict = (notification.userInfo?["data"] as? NSMutableDictionary)!
                self.response = (notification.userInfo?["data_list"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.noDataLabel.isHidden = self.response.count == 0 ? false : true
                self.owner_name.text = self.responseDict.value(forKey: "name") as? String
                let country_code = self.responseDict.value(forKey: "country_code") as? String
                let decodedString = country_code?.removingPercentEncoding //Decode for (+)sign
                self.phonelbl.text = decodedString! + "-" + (self.responseDict.value(forKey: "phone") as? String)!
                self.emaillbl.text = self.responseDict.value(forKey: "email") as? String
                self.unit_number.text = self.responseDict.value(forKey: "unit_number") as? String
                self.buliding_number.text = self.responseDict.value(forKey: "building_number") as? String
                let array = self.responseDict.value(forKey: "gate_ids") as! NSArray
                self.assign_gate.text = String(describing: array.count)  // "\(array?.count == 0 ? 0 : array!.count)"
                self.subAccountTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    func dataNotFound(){
           noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.subAccountTableview.bounds.size.width, height: self.subAccountTableview.bounds.size.height))
           noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
           noDataLabel.textColor     = UIColor.white
           noDataLabel.textAlignment = .center
           self.subAccountTableview.backgroundView  = noDataLabel
           self.subAccountTableview.separatorStyle  = .none
       }
    
    
    //MARK:- IBAction
    @IBAction func baclBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        let community_type = DataManager.getVal(Config().AppUserDefaults.value(forKey: "community_type")) as! String
        let property_id = String(describing: self.responseDict.value(forKey: "property_id")!)
        let EditAndUpdateApiFlag = true
        
        if community_type == "Residential Complex"{
            self.str = "edit"
            let defaults = UserDefaults.standard
            defaults.set(self.str, forKey: "RES")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddEmployeeAccountViewController") as! AddEmployeeAccountViewController
            vc.property_id = property_id
            
            vc.EditAndUpdateApiFlag = EditAndUpdateApiFlag
            navigationController?.pushViewController(vc, animated: true)
        }else{
            self.str = "edit"
            let defaults = UserDefaults.standard
            defaults.set(self.str, forKey: "COR")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddCommunityUserAccountVC") as! AddCommunityUserAccountVC
            vc.property_id = property_id
            vc.EditAndUpdateApiFlag = EditAndUpdateApiFlag
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK:- TableView Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubAccountsCell
        
        cell.name_lbl.text = self.language == "en" ? "Name" : "اسم"
        cell.emailLbl.text = self.language == "en" ? "Email" : "البريد الإلكتروني"
        cell.id_no.text = self.language == "en" ? "Id Number" : "رقم الهوية"
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.name.text = dict.value(forKey: "name") as? String
        cell.emial.text = dict.value(forKey: "email") as? String
        cell.Id_No.text = dict.value(forKey: "id_number") as? String
        
        return cell
    }
    
}

//MARK:-DGLoclalization Delegate
extension UserAccountsDetailsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
