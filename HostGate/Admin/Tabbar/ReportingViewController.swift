//
//  ReportingViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class ReportingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var language:String!
    
    var str_ticketnumber:NSString!
    var str_subject:NSString!
    var str_reason:NSString!
    var roleId:Int!
    var user_Id:Int!
    var randomString:String!
     var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    var referseControl = UIRefreshControl()
    
    @IBOutlet weak var tlCom: UILabel!
    @IBOutlet weak var tlUser: UILabel!
    @IBOutlet weak var tlAdmin: UILabel!
    @IBOutlet weak var tlgates: UILabel!
    @IBOutlet weak var tlSubUser: UILabel!
    @IBOutlet weak var tlPurAcc: UILabel!
    @IBOutlet weak var tlAssAcc: UILabel!
    @IBOutlet weak var comTableview: UITableView!
    @IBOutlet var reporting_Main_View: UIView!
    @IBOutlet weak var tilte_lbl: UILabel!
    @IBOutlet weak var communities: UILabel!
    
    @IBOutlet weak var tl_com_lb: UILabel!
    @IBOutlet weak var tl_user_lb: UILabel!
    @IBOutlet weak var tl_gate_lb: UILabel!
    @IBOutlet weak var tl_admins_lb: UILabel!
    @IBOutlet weak var tl_sub_user_lb: UILabel!
    @IBOutlet weak var tl_pur_ac_lb: UILabel!
    @IBOutlet weak var tl_asi_ac_lb: UILabel!
    @IBOutlet weak var tl_visit_rec: UILabel!
    
    var adminuserid:Int!
    var response = NSMutableArray()
    //MARK:- ForgotPasswordStudent WebService
    @objc func HostGateReporting(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        DispatchQueue.main.async() {
            
            if status == 0{
                self.dataNotFound()
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
                GIFHUD.shared.dismiss()
                
            } else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                
                var tl_com = Int()
                tl_com = response.value(forKey: "total_community") as! Int
                var tl = String()
                tl = String(tl_com)
                
                var tl_s = Int()
                tl_s = response.value(forKey: "total_staff") as! Int
                var tls = String()
                tls = String(tl_s)
                
                var tl_res = Int()
                tl_res = response.value(forKey: "total_users") as! Int
                var tlres = String()
                tlres = String(tl_res)
                
                var tl_gate = Int()
                tl_gate = response.value(forKey: "total_gate") as! Int
                var tlgt = String()
                tlgt = String(tl_gate)
                
                var tl_gateassacc = Int()
                tl_gateassacc = response.value(forKey: "total_assigned_account") as! Int
                var tlAssAc = String()
                tlAssAc = String(tl_gateassacc)
                
                var tl_Puracc = Int()
                tl_Puracc = response.value(forKey: "total_purchased_account") as! Int
                var tlPerAc = String()
                tlPerAc = String(tl_Puracc)
                
                var tl_SubUSer = Int()
                tl_SubUSer = response.value(forKey: "total_subusers") as! Int
                var tlsubuser = String()
                tlsubuser = String(tl_SubUSer)
                
                self.tlCom.text = tl
                self.tlAdmin.text = tls
                self.tlUser.text = tlres
                self.tlgates.text = tlgt
                self.tlSubUser.text = tlsubuser
                self.tlPurAcc.text = tlPerAc
                self.tlAssAcc.text = tlAssAc
                
                self.response = response.value(forKey: "community_list") as! NSMutableArray
                self.comTableview.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
                
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
                self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
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
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        language = defaults.value(forKey: "Language") as? String
        adminuserid = defaults.integer(forKey: "AdminUserId")
        self.role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
              deviceId = identifierManager.advertisingIdentifier.uuidString
          }
        
        //MARK:- language Code Start
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self
            decorate()
        }
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        comTableview.addSubview(referseControl)
        
        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateReporting(Language: language, UserID: user_Id, RoleID: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReporting), name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
    }
    
    @objc func refresh(sender:AnyObject) {
        comTableview.reloadData()
        referseControl.endRefreshing()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateReporting(Language: language, UserID: user_Id, RoleID: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReporting), name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
        // Code to refresh table view
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.tl_com_lb.text = language == "en" ? "Total Communities" : "مجموع المجتمعات"
        self.tl_user_lb.text = language == "en" ? "Total Users" : "مجموع المستخدمين"
        self.tl_gate_lb.text = language == "en" ? "Total Gates" : "مجموع البوابات"
        self.tl_admins_lb.text = language == "en" ? "Total Administrators" : "مجموع المسؤولين"
        self.tl_sub_user_lb.text = language == "en" ? "Total Subusers" : "مجموع المستخدمين الفرعيين"
        self.tl_pur_ac_lb.text = language == "en" ? "Total Purchased Accounts" : "إجمالي الحسابات المشتراة"
        self.tl_asi_ac_lb.text = language == "en" ? "Total Assigned Accounts" : "مجموع الحسابات المستخدمة"
        self.tilte_lbl.text = language == "en" ? "Reports" : "تقارير"
        self.communities.text = language == "en" ? "Communities" : "مجتمعات"
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.comTableview.bounds.size.width, height: self.comTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.comTableview.backgroundView  = noDataLabel
        self.comTableview.separatorStyle  = .none
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if response.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
    //        }
    //        else
    //        {
    //
    //                let noDataLabel: UILabel   = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //                noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //                noDataLabel.isHidden = true
    //                noDataLabel.textColor     = UIColor.white
    //                noDataLabel.textAlignment = .center
    //                tableView.backgroundView  = noDataLabel
    //                tableView.separatorStyle  = .none
    //        }
    //        return numOfSections
    //    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ComListCell
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.nameLbl.text = dict.value(forKey: "community_title") as? String
        var comtype:Int!
        comtype = dict.value(forKey: "community_type") as? Int
        
        if comtype == 1 {
            cell.typeLbl.text = language == "en" ? "Residential Complex" : "مجمع سكني"
        }else if comtype == 2 {
            cell.typeLbl.text = language == "en" ? "Corporate Office" : "مكتب الشركة"
        }else if comtype == 0{
            cell.typeLbl.text = "N/A"
        }
        
        cell.no_of_gates_lbl.text = String(describing: dict.value(forKey: "total_gates") as! Int)
        cell.no_of_users_lbl.text = String(describing: dict.value(forKey: "total_users") as! Int)
        cell.no_of_subusers_lbl.text = String(describing: dict.value(forKey: "total_subusers") as! Int)
        cell.no_of_visit_records_lbl.text = String(describing: dict.value(forKey: "total_visit") as! Int)

        cell.comNameLb.text = language == "en" ? "Title:" : "عنوان:"
        cell.comtypeLb.text = language == "en" ? "Type:" : "اكتب:"
        cell.no_of_users_lbl_ref.text = language == "en" ? "No. of users" : "عدد المستخدمين"
        cell.no_of_gates_lbl_rf.text = language == "en" ? "No. of gates" : "عدد البوابات"
        cell.no_of_subusers_lbl_ref.text = language == "en" ? "No. of subusers" : "عدد المستخدمين الفرعيين"
        cell.no_of_visit_records_lbl_ref.text = language == "en" ? "No. of visit records" : "رقم سجلات الزيارة"
        
        return cell
    }
}

//MARK:-DGLoclalization Delegate
extension ReportingViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
