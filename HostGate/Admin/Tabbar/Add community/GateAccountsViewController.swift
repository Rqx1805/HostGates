//
//  GateAccountsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class GateAccountsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var gateAccountTableview: UITableView!
    @IBOutlet weak var searchbBtn: UIButton!
    @IBOutlet weak var searchTxt: UISearchBar!
    
    var GetListDataArray = [Any]()
    var AddCommunityFlag = Bool()
    var defaults:UserDefaults!
    var sortData:String!
    var searchplace = String()
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        gateAccountTableview.addSubview(referseControl)
        self.GetList_API()
    }
    @objc func refresh(sender:AnyObject) {
        gateAccountTableview.reloadData()
        referseControl.endRefreshing()
        self.GetList_API()
        // Code to refresh table view
    }
    
    var searchTextField: UITextField? {
        let subViews = self.searchTxt.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
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
        GIFHUD.shared.setGif(named: "loader.gif")
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        usersts = defaults.value(forKey: "User_Status") as? String
        adminuserid = defaults.integer(forKey: "AdminUserId")
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
    
    func GetList_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        let CommunityID = DataManager.getVal(Config().AppUserDefaults.value(forKey: "CommunityID")) as! String
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(CommunityID), forKey: "community_id" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getAllGate"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.noDataLabel.isHidden = true
                    self.GetListDataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.gateAccountTableview.reloadData()
                    
                }else if status == "0"{
                    GIFHUD.shared.dismiss()
                    self.dataNotFound()
                    self.GetListDataArray.removeAll()
                    self.gateAccountTableview.reloadData()
                    if self.GetListDataArray.count > 0{
                        self.gateAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
        
    }
    
    func GateSearch_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        let CommunityID = DataManager.getVal(Config().AppUserDefaults.value(forKey: "CommunityID")) as! String
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(CommunityID), forKey: "community_id" as NSCopying)
        parameterDictionary.setObject(DataManager.getVal(searchTxt.text), forKey: "search_keyword" as NSCopying)
        print(parameterDictionary)
        
        let methodName = "getAllGate"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.GetListDataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.gateAccountTableview.reloadData()
                }else if status == "0"{
                    GIFHUD.shared.dismiss()
                    self.dataNotFound()
                    self.GetListDataArray.removeAll()
                    self.gateAccountTableview.reloadData()
                    if self.GetListDataArray.count > 0{
                        self.gateAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
        
    }
    
    func GateSorting_API(){
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        let CommunityID = DataManager.getVal(Config().AppUserDefaults.value(forKey: "CommunityID")) as! String
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setObject(DataManager.getVal(CommunityID), forKey: "community_id" as NSCopying)
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
        
        let methodName = "getAllGate"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                
                if status == "1" {
                    GIFHUD.shared.dismiss()
                    self.GetListDataArray = DataManager.getVal(responseData?.object(forKey: "data")) as! [Any]
                    self.gateAccountTableview.reloadData()
                }else if status == "0"{
                    GIFHUD.shared.dismiss()
                    self.dataNotFound()
                    self.GetListDataArray.removeAll()
                    self.gateAccountTableview.reloadData()
                    if self.GetListDataArray.count > 0{
                        self.gateAccountTableview.backgroundView = nil
                    }else{
                    }
                }else{
                    SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                }
            })
        }
        
    }
    @objc func Edit_ButtonAction(_ sender: UIButton) {
        self.AddCommunityFlag = true
        let dict = DataManager.getVal(self.GetListDataArray[sender.tag]) as! NSDictionary
        let gate_id = DataManager.getVal(dict["gate_id"]) as! String
        
        var str1 = String()
        str1 = "editgate"
        let defaults = UserDefaults.standard
        defaults.set(str1, forKey: "Gate")
        defaults.synchronize()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddGateAccountsViewController") as! AddGateAccountsViewController
        vc.gate_id = gate_id
        vc.AddCommunityFlag = self.AddCommunityFlag
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @objc func DeleteButton_Action(_ sender: UIButton) {
        
        let dict = DataManager.getVal(self.GetListDataArray[sender.tag]) as! NSDictionary
        let gate_id = DataManager.getVal(dict["gate_id"]) as! String
        
        let myAlert = UIAlertController(title: "HostGates", message: language == "en" ? "Are you sure to delete this gate?" : "هل أنت متأكد من حذف هذه البوابة.", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            self.defaults.set("Gate_Account_View_Controller", forKey: "Delete_Check")
            let nextview = DeleteCommunityView.intitiateFromNib()
            let model = BackModel()
            
            nextview.buttonDoneHandler = { (UniqueName) in
                
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:10)
                let parameterDictionary = NSMutableDictionary()
                if self.usersts == "1" {
                    parameterDictionary.setValue(DataManager.getVal(gate_id) as! String, forKey: "gate_id")
                    parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                    parameterDictionary.setValue(DataManager.getVal(self.roleId) as! String, forKey: "role_id")
                    parameterDictionary.setValue(DataManager.getVal(self.user_Id) as! String, forKey: "user_id")
                    parameterDictionary.setValue(DataManager.getVal("") as! String, forKey: "language")
                }else if self.usersts == "2" {
                    parameterDictionary.setValue(DataManager.getVal(gate_id) as! String, forKey: "gate_id")
                    parameterDictionary.setValue(DataManager.getVal(UniqueName) as! String, forKey: "unique_name")
                    parameterDictionary.setValue(DataManager.getVal(self.roleId) as! String, forKey: "role_id")
                    parameterDictionary.setValue(DataManager.getVal(self.adminuserid) as! String, forKey: "admin_user_id")
                    parameterDictionary.setValue(DataManager.getVal("") as! String, forKey: "language")
                }
                
                print(parameterDictionary)
                
                let methodName = "deleteGate"
                DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        let status =  DataManager.getVal(responseData?.object(forKey: "status"))  as! String
                        let message =  DataManager.getVal(responseData?.object(forKey: "message"))  as! String
                        
                        if status == "1" {
                            GIFHUD.shared.dismiss()
                            self.showAlertUpate(message: message)
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
    
    func showAlertUpate(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.GetList_API()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchTxt.text == "" {
            self.GetList_API()
        }else {
            self.GateSearch_API()
        }
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    
    @IBAction func searchBtbAction(_ sender: Any) {
        if searchTxt.text == "" {
            self.GetList_API()
        }else {
            self.GateSearch_API()
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
            self.GateSorting_API()
            model.closewithAnimation()
        }
        model.show(view: nextview)
    }
    
    func dataNotFound(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.gateAccountTableview.bounds.size.width, height: self.gateAccountTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.gateAccountTableview.backgroundView  = noDataLabel
        self.gateAccountTableview.separatorStyle  = .none
    }
    
    //MARK:- UITableView Delegate and Data Source
    
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if GetListDataArray.count>0
    //        {
    //            tableView.separatorStyle = .none
    //            numOfSections            = 1
    //            tableView.backgroundView = nil
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
    //        }
    //        return numOfSections
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.GetListDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! gateAccountCell
        
        
        cell.gate_name.text = language == "en" ? "Gate Name" : "اسم البوابة"
        cell.gate_no.text = language == "en" ? "Gate Number" : "رقم البوابة"
        cell.unique_name.text = language == "en" ? "Username" : "اسم المستخدم"
        
        let dict = DataManager.getVal(self.GetListDataArray[indexPath.row]) as! NSDictionary
        
        let account_number = DataManager.getVal(dict["account_number"]) as! String
        debugPrint(account_number)
        let gate_name = DataManager.getVal(dict["gate_name"]) as! String
        let gate_number = DataManager.getVal(dict["gate_number"]) as! String
        let unique_name = DataManager.getVal(dict["unique_name"]) as! String
        
        cell.gate_name_lbl.text = gate_name
        cell.gate_no_lbl.text = gate_number
        cell.unique_name_lbl.text = unique_name
        
        cell.Editbutton.tag = indexPath.row
        cell.Editbutton.addTarget(self, action: #selector(Edit_ButtonAction), for: .touchUpInside)
        
        cell.DeleteButton.tag = indexPath.row
        cell.DeleteButton.addTarget(self, action: #selector(DeleteButton_Action), for: .touchUpInside)
        
        return cell
    }
}

//MARK:-DGLoclalization Delegate
extension GateAccountsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}

