//
//  UserAccountsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class UserAccountsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var userAccountTableview: UITableView!
    @IBOutlet weak var searchTxt: UISearchBar!
    @IBOutlet weak var searchBtb: UIButton!
    
    var defaults:UserDefaults!
    var comnunityId:Int!
    var UserAccountListArray = [Any]()
    var str = String()
    
    var sortData:String!
    var searchplace = String()
    var referseControl = UIRefreshControl()
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var usersts:String!
    var noDataLabel = UILabel()
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        userAccountTableview.addSubview(referseControl)
        self.getDATA_API()
    }
    @objc func refresh(sender:AnyObject) {
        userAccountTableview.reloadData()
        referseControl.endRefreshing()
        self.getDATA_API()
        // Code to refresh table view
    }
    
    var searchTextField: UITextField? {
        let subViews = self.searchTxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        usersts = defaults.value(forKey: "User_Status") as? String
        adminuserid = defaults.integer(forKey: "AdminUserId")
        comnunityId = defaults.integer(forKey: "CommunityID")
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        searchTxt.delegate = self
        searchTxt.setImage(UIImage(), for: .search, state: .normal)
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
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
        }
        
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
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
                
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
                //                self.removeAllOverlays()\
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
    
    
    
    func getDATA_API(){
        //        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:20)
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
                    self.noDataLabel.isHidden = true
                    self.UserAccountListArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.userAccountTableview.reloadData()
                    
                }else if status  == "0"{
                    GIFHUD.shared.dismiss()
                    self.dataNotFound()
                    self.UserAccountListArray.removeAll()
                    self.userAccountTableview.reloadData()
                    if self.UserAccountListArray.count > 0{
                        self.userAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
    }
    
    
    func getDATASearch_API(){
        //        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.comnunityId), forKey: "community_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(self.searchTxt.text), forKey: "search_keyword" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getAllProperty"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.UserAccountListArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.userAccountTableview.reloadData()
                }else if status  == "0"{
                    GIFHUD.shared.dismiss()
                    self.UserAccountListArray.removeAll()
                    self.userAccountTableview.reloadData()
                    if self.UserAccountListArray.count > 0{
                        self.userAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
    }
    
    func getDATASorting_API(){
        //        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(self.comnunityId), forKey: "community_id" as NSCopying)
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
        
        let methodName = "getAllProperty"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.UserAccountListArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.userAccountTableview.reloadData()
                    
                }else if status  == "0"{
                    GIFHUD.shared.dismiss()
                    self.UserAccountListArray.removeAll()
                    self.userAccountTableview.reloadData()
                    if self.UserAccountListArray.count > 0{
                        self.userAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchTxt.text == "" {
            self.getDATA_API()
        }else {
            self.getDATASearch_API()
        }
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    
    
    @IBAction func searchBtbAction(_ sender: Any) {
        if searchTxt.text == "" {
            self.getDATA_API()
        }else {
            self.getDATASearch_API()
        }
    }
    
    @IBAction func sortBtnAction(_ sender: Any) {
        let nextview = SortingView.intitiateFromNib()
        let model = PopModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            self.defaults = UserDefaults.standard
            self.sortData = self.defaults.value(forKey: "SortData") as? String
            self.getDATASorting_API()
            model.closewithAnimation()
        }
        model.show(view: nextview)
    }
    
    func dataNotFound(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.userAccountTableview.bounds.size.width, height: self.userAccountTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.userAccountTableview.backgroundView  = noDataLabel
        self.userAccountTableview.separatorStyle  = .none
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if UserAccountListArray.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
    //        }
    //        else
    //        {
    //
    //            let noDataLabel: UILabel   = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //            noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //        }
    //        return numOfSections
    //    }
    
    
    //MARK:- TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserAccountListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserAccountsCell
        
        cell.OwnerNameLbl.text = language == "en" ? "Owner Name" : "اسم المالك"
        cell.unit_numberLbl.text = language == "en" ? "Unit/Floor Number" : "وحدة / رقم الطابق"
        cell.buliding_numberLbl.text = language == "en" ? "Building Number" : "رقم المبنى"
        
        let dict = DataManager.getVal(self.UserAccountListArray[indexPath.row]) as! NSDictionary
        
        let building_number = DataManager.getVal(dict["building_number"]) as! String
        let email = DataManager.getVal(dict["email"]) as! String
        let phone = DataManager.getVal(dict["phone"]) as! String
        let unit_number = DataManager.getVal(dict["unit_number"]) as! String
        let name = DataManager.getVal(dict["name"]) as! String
        
        cell.EmailLbl.text = email
        let community_type = DataManager.getVal(Config().AppUserDefaults.value(forKey: "community_type")) as! String
        if community_type == "Residential Complex" {
            let decodedString = phone.removingPercentEncoding
            cell.PhoneNumberlbl.text =  decodedString
        }else {
            let decodedString = phone.removingPercentEncoding
            cell.PhoneNumberlbl.text =   decodedString
        }
        
        cell.UnitNumberlbl.text = unit_number
        cell.BuildingNumberLbl.text = building_number
        cell.OwnerNameLbl.text = name
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(HandleTap1(_:)), for: .touchUpInside)
        cell.DeleteButton.tag = indexPath.row
        cell.DeleteButton.addTarget(self, action: #selector(DeleteButton_Action), for: .touchUpInside)
        return cell
    }
    
    @objc func HandleTap(_ sender: UIButton){
        let dict = DataManager.getVal(self.UserAccountListArray[sender.tag]) as! NSDictionary
        let property_id = DataManager.getVal(dict["property_id"]) as! String
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserAccountsDetailsViewController") as! UserAccountsDetailsViewController
        vc.property_id = property_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func HandleTap1(_ sender: UIButton){
        
        let community_type = DataManager.getVal(Config().AppUserDefaults.value(forKey: "community_type")) as! String
        let dict = DataManager.getVal(self.UserAccountListArray[sender.tag]) as! NSDictionary
        let property_id = DataManager.getVal(dict["property_id"]) as! String
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
    @objc func DeleteButton_Action(_ sender: UIButton) {
        
        let dict = DataManager.getVal(self.UserAccountListArray[sender.tag]) as! NSDictionary
        let property_id = DataManager.getVal(dict["property_id"]) as! String
        defaults.set("User_Account_View_Controller", forKey: "Delete_Check")
        
        let myAlert = UIAlertController(title: "HostGates", message:language == "en" ? "Are you sure to delete this user?" : "هل أنت متأكد من حذف هذا المستخدم.", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            let nextview = DeleteCommunityView.intitiateFromNib()
            let model = BackModel()
            
            nextview.buttonDoneHandler = { (UniqueName) in
                
                //                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                
                let parameterDictionary = NSMutableDictionary()
                if self.usersts == "1" {
                    parameterDictionary.setValue(DataManager.getVal(property_id) as! String, forKey: "property_id")
                    parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                    parameterDictionary.setValue(DataManager.getVal(self.roleId) as! String, forKey: "role_id")
                    parameterDictionary.setValue(DataManager.getVal(self.user_Id) as! String, forKey: "user_id")
                    parameterDictionary.setValue(DataManager.getVal("") as! String, forKey: "language")
                }else if self.usersts == "2" {
                    parameterDictionary.setValue(DataManager.getVal(property_id) as! String, forKey: "property_id")
                    parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                    parameterDictionary.setValue(DataManager.getVal(self.roleId) as! String, forKey: "role_id")
                    parameterDictionary.setValue(DataManager.getVal(self.adminuserid) as! String, forKey: "admin_user_id")
                    parameterDictionary.setValue(DataManager.getVal("") as! String, forKey: "language")
                }
                
                print(parameterDictionary)
                
                let methodName = "deleteProperty"
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            self.getDATA_API()
                        }else{
                            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                        }
                        GIFHUD.shared.dismiss()
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
    
}

//MARK:-DGLoclalization Delegate
extension UserAccountsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
