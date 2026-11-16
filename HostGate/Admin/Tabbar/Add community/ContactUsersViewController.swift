//
//  ContactUsersViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class ContactUsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlet
    @IBOutlet weak var contactUserTableview: UITableView!
    @IBOutlet weak var selectAllLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    var defaults:UserDefaults!
    var comnunityId:Int!
    var UserAccountListArray = [Any]()
    var select_type_array = NSMutableArray()
    var isClick: Bool = false
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var UserId:Int!
    var deviceTocken = NSString()
    
    var comType:String!
    var referseControl = UIRefreshControl()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        defaults = UserDefaults.standard
        comType = defaults.value(forKey: "community_type") as? String
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        contactUserTableview.addSubview(referseControl)
        self.getDATA_API()
    }
    @objc func refresh(sender:AnyObject) {
        contactUserTableview.reloadData()
        referseControl.endRefreshing()
        self.getDATA_API()
        // Code to refresh table view
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
        defaults = UserDefaults.standard
        comnunityId = defaults.integer(forKey: "CommunityID")
        GIFHUD.shared.setGif(named: "loader.gif")
        self.hideCheckAllBtn()
        
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "ROLE")
        UserId = defaults.integer(forKey: "UserIDGet")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
       
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: UserId, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.selectAllLbl.text = language == "en" ? "Select All" : "اختر الكل"
    }
    
    func getDATA_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.comnunityId), forKey: "community_id" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getAllProperty"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.UnhideCheckAllBtn()
                    self.UserAccountListArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.contactUserTableview.reloadData()
                    
                }else if status  == "0"{
                    GIFHUD.shared.dismiss()
                    self.dataNotFound()
                    self.UserAccountListArray.removeAll()
                    self.contactUserTableview.reloadData()
                    if self.UserAccountListArray.count > 0{
                        self.contactUserTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
    }
    
    func hideCheckAllBtn(){
        self.checkBtn.isHidden = true
        self.selectAllLbl.isHidden = true
    }
    
    func UnhideCheckAllBtn(){
        self.checkBtn.isHidden = false
        self.selectAllLbl.isHidden = false
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.contactUserTableview.bounds.size.width, height: self.contactUserTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.contactUserTableview.backgroundView  = noDataLabel
        self.contactUserTableview.separatorStyle  = .none
    }
    
    //MARK:- UITableView Delegate and Data Source
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if UserAccountListArray.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
    //            self.checkBtn.isHidden = false
    //            self.selectAllLbl.isHidden = false
    //        }
    //        else
    //        {
    //
    //            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //            noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //            self.checkBtn.isHidden = true
    //            self.selectAllLbl.isHidden = true
    //        }
    //        return numOfSections
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserAccountListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactUserCell
        
        cell.ownerNameLbl.text = language == "en" ? "Owner Name" : "اسم المالك"
        cell.unit_numberlbl.text = language == "en" ? "Unit/Floor Number" : "وحدة / رقم الطابق"
        cell.buliding_numberlbl.text = self.language == "en" ? "Building Number" : "رقم المبنى"
        
        let dict = DataManager.getVal(self.UserAccountListArray[indexPath.row]) as! NSDictionary
        
        let building_number = DataManager.getVal(dict["building_number"]) as! String
        let email = DataManager.getVal(dict["email"]) as! String
        let phone = DataManager.getVal(dict["phone"]) as! String
        let unit_number = DataManager.getVal(dict["unit_number"]) as! String
        let id_number = DataManager.getVal(dict["id_number"]) as! String
        let employee_number = DataManager.getVal(dict["employee_number"]) as! String
        let name = DataManager.getVal(dict["name"]) as! String
        
        let property_id = DataManager.getVal(dict["property_id"]) as! String
        if comType == "Residential Complex"{
            cell.idnumber.text = language == "en" ? "Id Number" : "رقم الهوية"
            cell.assinGateNo.text = id_number
        }else {
            cell.idnumber.text = language == "en" ? "Employee Number" : "رقم الموظف"
            cell.assinGateNo.text = employee_number
        }
        
        cell.emailLbl.text = email
        let decodedString = phone.removingPercentEncoding
        cell.mobileNumber.text = decodedString
        cell.unitNumber.text = unit_number
        cell.buildNUmber.text = building_number
        cell.ownerNameLbl.text = name
        cell.checkBoxBtn.tag = indexPath.row
        
        if self.select_type_array.contains(property_id){
            cell.checkBoxBtn.setImage(UIImage(named:"Checkbox"), for: .normal)
        }else{
            cell.checkBoxBtn.setImage(UIImage(named:"ic_check_box_outline_blank_24px"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.UserAccountListArray[indexPath.row]) as! [String: Any]
        let s_id = DataManager.getVal(dict["property_id"]) as! String
        if select_type_array.contains(s_id)
        {
            select_type_array.remove(s_id)
            let defaults = UserDefaults.standard
            defaults.set(self.select_type_array, forKey: "Array")
            defaults.synchronize()
            isClick = false
            checkBtn.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("CheckALl"), object: nil)
            
        }
        else
        {
            select_type_array.add(s_id)
            let defaults = UserDefaults.standard
            defaults.set(self.select_type_array, forKey: "Array")
            defaults.synchronize()
            isClick = true
            if select_type_array.count == UserAccountListArray.count {
                self.checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
            }else {
                print("Ashish")
            }
            
            
            
            NotificationCenter.default.post(name: NSNotification.Name("CheckALl"), object: nil)
            defaults.synchronize()
        }
        self.contactUserTableview.reloadData()
        
    }
    
    //    @objc func HandleTap(_ sender:UIButton) {
    //
    //        var btn = sender as? UIButton
    //        let dict1 = UserAccountListArray[(btn?.tag)!] as! NSDictionary
    //
    //        let s_id = dict1.object(forKey: "property_id") ?? NSString()
    //
    //        if select_type_array.contains(s_id)
    //        {
    //            select_type_array.remove(s_id)
    //            let defaults = UserDefaults.standard
    //            defaults.set(self.select_type_array, forKey: "Array")
    //            checkBtn.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
    //            NotificationCenter.default.post(name: NSNotification.Name("CheckALl"), object: nil)
    //
    //        }
    //        else
    //        {
    //            select_type_array.add(s_id)
    //            let defaults = UserDefaults.standard
    //            defaults.set(self.select_type_array, forKey: "Array")
    //            NotificationCenter.default.post(name: NSNotification.Name("CheckALl"), object: nil)
    //            defaults.synchronize()
    //        }
    //
    ////        if select_type_array.contains(dict1.object(forKey: "property_id")!) {
    ////            sender.setImage(UIImage(named: "Checkbox"), for: .normal)
    ////        }else {
    ////            sender.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
    ////        }
    //
    //    }
    
    @IBAction func selectAllBtnAction(_ sender: UIButton) {
        if (!isClick) {
            isClick = true
            self.checkBtn.setImage(UIImage(named: "Checkbox"), for: .normal)
            for index in 0..<self.UserAccountListArray.count{
                
                let dict = DataManager.getVal(self.UserAccountListArray[index]) as! [String:Any]
                let gate_id = DataManager.getVal(dict["property_id"]) as! String
                self.select_type_array.add(gate_id)
            }
            let defaults = UserDefaults.standard
            defaults.set(self.select_type_array, forKey: "Array")
            defaults.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("CheckALl"), object: nil)
            self.contactUserTableview.reloadData()
        }else {
            isClick = false
            self.checkBtn.setImage(UIImage(named: "ic_check_box_outline_blank_24px"), for: .normal)
            self.select_type_array.removeAllObjects()
            defaults = UserDefaults.standard
            defaults.removeObject(forKey: "Array")
            self.contactUserTableview.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name("CheckALl"), object: nil)
        }
        
    }
    
}

//MARK:-DGLoclalization Delegate
extension ContactUsersViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
