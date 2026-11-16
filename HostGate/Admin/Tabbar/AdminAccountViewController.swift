//
//  AdminAccountViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class AdminAccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var adminAccountTableview: UITableView!
    var DataArray = [Any]()
    @IBOutlet weak var searchTxt: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var add_btn: UIButton!
    @IBOutlet weak var fliter_btn: UIButton!
    @IBOutlet weak var out_border: UITextField!
    @IBOutlet var admin_Main_View: UIView!
    
    var AddStaffFlag = Bool()
    var searchplace = String()
    var defaults:UserDefaults!
    var sortData:String!
    var roleId:Int!
    var adminuserid:Int!
    var userid:Int!
    var usersts:String!
    var referseControl = UIRefreshControl()
    var noDataLabel = UILabel()
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    
    
    var searchTextField: UITextField? {
        let subViews = self.searchTxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.adminAccountTableview.delegate = self
        self.adminAccountTableview.dataSource = self
        
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        adminAccountTableview.addSubview(referseControl)
        self.AdminList_API()
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: userid, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set("", forKey: "CheckSelectedButton")
    }
    
    @objc func refresh(sender:AnyObject) {
        adminAccountTableview.reloadData()
        referseControl.endRefreshing()
        AdminList_API()
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
        GIFHUD.shared.setGif(named: "loader.gif")
        //MARK:- language Code Start
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        userid = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        usersts = defaults.value(forKey: "User_Status") as? String
        self.role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
                   deviceId = identifierManager.advertisingIdentifier.uuidString
               }
        
        searchTxt.delegate = self
        searchTxt.setImage(UIImage(), for: .search, state: .normal)

        
        self.adminAccountTableview.delegate = self
        self.adminAccountTableview.dataSource = self
        
        if #available(iOS 13.0, *) {
            //Vipin
            searchTextField?.placeholder = language == "en" ? "Search..." : "بحث..."
            self.searchTextField?.textAlignment = language == "en" ? NSTextAlignment.right : NSTextAlignment.left
            searchTextField?.textColor = UIColor.white
            searchTextField?.backgroundColor = UIColor.clear
            searchTextField?.borderStyle = .none
            searchTextField?.clearButtonMode = .never
            searchTextField?.textAlignment = NSTextAlignment.left
        }else {
            let searchfield = self.searchTxt.subviews[0].subviews.last as! UITextField
            searchfield.placeholder = language == "en" ? "Search..." : "بحث..."
            searchfield.textColor = UIColor.white
            searchfield.backgroundColor = UIColor.clear
            searchfield.borderStyle = .none
            searchfield.clearButtonMode = .never
            searchfield.textAlignment = NSTextAlignment.left
        }
        
          NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("AddAdminAccount"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("UpdateAdminAccount"), object: nil)
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        AdminList_API()
    }
    
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
          AdminList_API()
      }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ?  "Admin Accounts" : "حسابات المسؤول"
    }
    
    @objc func Edit_ButtonAction(_ sender: UIButton) {
        let str = "show"
        let dict = DataManager.getVal(self.DataArray[sender.tag]) as! NSDictionary
        let staff_id = DataManager.getVal(dict["staff_id"]) as! String
        
        var str1 = String()
        str1 = "Editstaff"
        let defaults = UserDefaults.standard
        defaults.set(str1, forKey: "Staff")
        defaults.synchronize()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAdminAccountsViewController") as! AddAdminAccountsViewController
        vc.str = str
        vc.staff_id = staff_id
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchTxt.text == "" {
            self.AdminList_API()
        }else {
            self.AdminSearch_API()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    @objc func DeleteButton_Action(_ sender: UIButton) {
        
        let dict = DataManager.getVal(self.DataArray[sender.tag]) as! NSDictionary
        let staff_id = DataManager.getVal(dict["staff_id"]) as! String
        
        let myAlert = UIAlertController(title: "HostGates", message: language == "en" ? "Are you sure to delete this staff?" : "هل أنت متأكد من حذف هذا الموظفين.", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            self.defaults.set("Admin_Account_View_Controller", forKey: "Delete_Check")
            let nextview = DeleteCommunityView.intitiateFromNib()
            let model = BackModel()
            
            nextview.buttonDoneHandler = { (UniqueName) in
                
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:4)
                
                let parameterDictionary = NSMutableDictionary()
                if self.usersts == "1" {
                    parameterDictionary.setValue(DataManager.getVal(staff_id) as! String, forKey: "staff_id")
                    parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                    parameterDictionary.setValue(DataManager.getVal(self.roleId) as! String, forKey: "role_id")
                    parameterDictionary.setValue(DataManager.getVal(self.userid) as! String, forKey: "user_id")
                    parameterDictionary.setValue(DataManager.getVal("en") as! String, forKey: "language")
                }else if self.usersts == "2" {
                    parameterDictionary.setValue(DataManager.getVal(staff_id) as! String, forKey: "staff_id")
                    parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                    parameterDictionary.setValue(DataManager.getVal(self.roleId) as! String, forKey: "role_id")
                    parameterDictionary.setValue(DataManager.getVal(self.adminuserid) as! String, forKey: "admin_user_id")
                    parameterDictionary.setValue(DataManager.getVal("en") as! String, forKey: "language")
                }
                
                print(parameterDictionary)
                
                let methodName = "deleteStaff"
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            self.AdminList_API()
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                        }else{
                            GIFHUD.shared.dismiss()
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                        }
                    })
                }
                model.closewithAnimation()
                
            }
            nextview.buttonCancelHandler = {
                model.closewithAnimation()
            }
            model.show(view: nextview)
            
        })
        myAlert.addAction(okAction);
        myAlert.addAction(sayhi);
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        if searchTxt.text == "" {
            self.AdminList_API()
        }else {
            self.AdminSearch_API()
        }
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        
        let nextview = SortingView.intitiateFromNib()
        let model = PopModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            self.defaults = UserDefaults.standard
            self.sortData = self.defaults.value(forKey: "SortData") as? String
            self.AdminSorting_API()
            model.closewithAnimation()
        }
        model.show(view: nextview)
    }
    func AdminList_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "UserIDGet")) as! String
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(user_id), forKey: "user_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.roleId), forKey: "role_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.adminuserid), forKey: "admin_user_id" as NSCopying)
        
        print(parameterDictionary)
        
        let methodName = "getAllStaff"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.noDataLabel.isHidden = true
                    self.DataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.adminAccountTableview.reloadData()
                    
                }else if status == "0"{
                    GIFHUD.shared.dismiss()
                    self.noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width:   self.adminAccountTableview.bounds.size.width, height:   self.adminAccountTableview.bounds.size.height))
                    self.noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
                    self.noDataLabel.textColor     = UIColor.white
                    self.noDataLabel.textAlignment = .center
                    self.adminAccountTableview.backgroundView  = self.noDataLabel
                    self.adminAccountTableview.separatorStyle  = .none
                    self.DataArray.removeAll()
                    self.adminAccountTableview.reloadData()
                    if self.DataArray.count > 0{
                        self.adminAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    GIFHUD.shared.dismiss()
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
        
    }
    
    func AdminSearch_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "UserIDGet")) as! String
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(user_id), forKey: "user_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(searchTxt.text), forKey: "search_keyword" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.roleId), forKey: "role_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.adminuserid), forKey: "admin_user_id" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getAllStaff"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.DataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.adminAccountTableview.reloadData()
                }else if status == "0"{
                    GIFHUD.shared.dismiss()
                    self.DataArray.removeAll()
                    self.adminAccountTableview.reloadData()
                    if self.DataArray.count > 0{
                        self.adminAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    GIFHUD.shared.dismiss()
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
        
    }
    
    func AdminSorting_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "UserIDGet")) as! String
        
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(user_id), forKey: "user_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.roleId), forKey: "role_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.adminuserid), forKey: "admin_user_id" as NSCopying)
        if sortData == "Name(A-Z)" {
            parameterDictionary.setObject(DataManager.getVal("name_asc"), forKey: "sorting" as NSCopying)
        }else if sortData == "Name(Z-A)" {
            parameterDictionary.setObject(DataManager.getVal("name_desc"), forKey: "sorting" as NSCopying)
        }else if sortData == "Email(A-Z)" {
            parameterDictionary.setObject(DataManager.getVal("email_asc"), forKey: "sorting" as NSCopying)
        }else {
            parameterDictionary.setObject(DataManager.getVal("email_desc"), forKey: "sorting" as NSCopying)
        }
        print(parameterDictionary)
        
        let methodName = "getAllStaff"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.DataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.adminAccountTableview.reloadData()
                }else if status == "0"{
                    GIFHUD.shared.dismiss()
                    self.DataArray.removeAll()
                    self.adminAccountTableview.reloadData()
                    if self.DataArray.count > 0{
                        self.adminAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    GIFHUD.shared.dismiss()
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
        
    }
    
    //MARK:- TableViewDelagte and Data Source
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if DataArray.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
    //        }
    //        else
    //        {
    //            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //            noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //        }
    //        return numOfSections
    //    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdminAccountsCell
        
        let dict = DataManager.getVal(self.DataArray[indexPath.row]) as! NSDictionary
        let email = DataManager.getVal(dict["email"]) as! String
        let phone = DataManager.getVal(dict["phone"]) as! String
        let role = DataManager.getVal(dict["role"]) as! String
        let username = DataManager.getVal(dict["username"]) as! String
        let staff_id = DataManager.getVal(dict["staff_id"]) as! String
        
        cell.idnumberlbl.text = language == "en" ? "Id Number" : "رقم الهوية"
        cell.rolelbl.text = language == "en" ?  "Role" : "وظيفة"
        
        cell.txtOwnerName.text = username
        cell.txtEmail.text = email
        let decodedString = phone.removingPercentEncoding //Decode for (+)sign
        cell.PhoneNumberlbl.text =  decodedString
        cell.IdNumberLbl.text = staff_id
        cell.RoleNumberLbl.text = role
        cell.EyeButton.isHidden = true
        var strid:Int!
        strid = Int(staff_id)
        if userid == strid {
            cell.EditButton.isHidden = true
            cell.DeleteButton.isHidden = true
        }else {
            cell.EditButton.isHidden = false
            cell.DeleteButton.isHidden = false
        }
        
        cell.EditButton.tag = indexPath.row
        cell.EditButton.addTarget(self, action: #selector(Edit_ButtonAction), for: .touchUpInside)
        
        cell.DeleteButton.tag = indexPath.row
        cell.DeleteButton.addTarget(self, action: #selector(DeleteButton_Action), for: .touchUpInside)
        
        return cell
    }
    
    
    
    @IBAction func adminAddBtnAction(_ sender: Any) {
        var str1 = String()
        str1 = "Addstaff"
        let defaults = UserDefaults.standard
        defaults.set(str1, forKey: "Staff")
        defaults.synchronize()
        self.AddStaffFlag = true
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAdminAccountsViewController") as! AddAdminAccountsViewController
        vc.AddStaffFlag = self.AddStaffFlag
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:-DGLoclalization Delegate
extension AdminAccountViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
