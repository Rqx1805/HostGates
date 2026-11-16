//
//  ResVisitorRecordsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AdSupport
import GiFHUD_Swift

class ResVisitorRecordsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var visitorRecordtableview: UITableView!
    @IBOutlet weak var titlelbl: UILabel!
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var response = NSMutableArray()
    var user_sts = String()
    var defaults: UserDefaults!
    var role:Int!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var comType:Int!
    var sortData:String!
    var searchplace = String()
    var noDataLabel = UILabel()
    @IBOutlet weak var searchTxtbar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    var referseControl = UIRefreshControl()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var imageString = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateVisitorRecordListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
                self.response.removeAllObjects()
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                self.noDataLabel.isHidden = true
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    @objc func HostGateVisitorDeleteRecordListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserDeleteVisitorsRecord"), object: nil)
                self.response.removeAllObjects()
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserDeleteVisitorsRecord"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid, SearchKeyword: "", Role: self.role, Visitor_Sorting: "")
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    @objc func HostGateVisitorCancleRecordListAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserCancleVisitorsRecord"), object: nil)
                self.response.removeAllObjects()
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserCancleVisitorsRecord"), object: nil)
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                self.showAlertDelete(message: str_message)
            }
        }
    }
    
    func showAlertDelete(message: String) {
        let alertController = UIAlertController(title: "HostGates", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: self.language == "en" ? "OK" : "حسنا", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateUserVisitorsRecordList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid, SearchKeyword: "", Role: self.role, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
            self.visitorRecordtableview.reloadData()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func HostGateVisitorAcceptRejectAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                /// SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUserAcceptRejectVisitors"), object: nil)
                self.response.removeAllObjects()
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid, SearchKeyword: "", Role: self.role, Visitor_Sorting: "")
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
                self.visitorRecordtableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
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
//                   self.removeAllOverlays()
                   self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
               }
               else if status == 1{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                   self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
                   self.removeAllOverlays()
                let checkString = self.defaults.value(forKey: "Role") as? String
                if checkString == "User"{
                let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                self.navigationController?.pushViewController(Leaderboard, animated: true)
                }
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
    
    var searchTextField: UITextField? {
        let subViews = self.searchTxtbar.subviews.first?.subviews.last?.subviews
        return subViews?.first as? UITextField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        
        user_sts = defaults.value(forKey: "User_Status") as! String
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "ROLE")
        self.comType = defaults.integer(forKey: "COMTYPE")
        if identifierManager.isAdvertisingTrackingEnabled {
                   deviceId = identifierManager.advertisingIdentifier.uuidString
               }
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        visitorRecordtableview.addSubview(referseControl)
        
        //GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
        searchTxtbar.delegate = self
        searchTxtbar.setImage(UIImage(), for: .search, state: .normal)
        if #available(iOS 13.0, *) {
            //Vipin
            searchTextField?.placeholder = language == "en" ? "Search (count & date/time)" : "البحث (العد والتاريخ / الوقت)"
            self.searchTextField?.textAlignment = language == "en" ? NSTextAlignment.right : NSTextAlignment.left
            searchTextField?.keyboardType = .asciiCapable
            searchTextField?.textColor = UIColor.white
            searchTextField?.backgroundColor = UIColor.clear
            searchTextField?.borderStyle = .none
            searchTextField?.clearButtonMode = .never
            searchTextField?.inputAccessoryView = searchTextField?.keyboardToolbar
            searchTextField?.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonClicked))
            let items = NSMutableArray()
            items.add(done)
            searchTextField?.keyboardToolbar.items = items as? [UIBarButtonItem]
            
            IQKeyboardManager.shared.enable = true
            searchTextField?.textAlignment = NSTextAlignment.left
        }else {
            let searchfield = self.searchTxtbar.subviews[0].subviews.last as! UITextField
            searchfield.placeholder = language == "en" ? "Search (count & date/time)" : "البحث (العد والتاريخ / الوقت)"
            searchfield.keyboardType = .asciiCapable
            searchfield.textColor = UIColor.white
            searchfield.backgroundColor = UIColor.clear
            searchfield.borderStyle = .none
            searchfield.clearButtonMode = .never
            searchfield.inputAccessoryView = searchfield.keyboardToolbar
            // searchfield.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonClicked))
            let items = NSMutableArray()
            items.add(done)
            searchfield.keyboardToolbar.items = items as? [UIBarButtonItem]
            
            IQKeyboardManager.shared.enable = true
            
            searchfield.textAlignment = NSTextAlignment.left
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("AddVisitorRecord"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("UpdateVisitorRecord"), object: nil)
        
        
        setupLeftDrawer(self)
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            
            Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", Role: role, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Visitors" : "الزائرين"
    }
    
    @objc func refresh(sender:AnyObject) {
        visitorRecordtableview.reloadData()
        referseControl.endRefreshing()
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", Role: role, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        
        
        // Code to refresh table view
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        view.endEditing(true)
        searchTxtbar.text = ""
        //your code when clicked on done
    }
    @objc func currencyItemChosen(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", Role: role, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        
        
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        if Reachability.isConnectedToNetwork() == true {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", Role: role, Visitor_Sorting: "")
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
        }else {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        
        
    }
    
    func dataNotFound(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.visitorRecordtableview.bounds.size.width, height: self.visitorRecordtableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.visitorRecordtableview.backgroundView  = noDataLabel
        self.visitorRecordtableview.separatorStyle  = .none
    }
    
    //    //MARK:- UITableView Delegate
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
    //            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //                noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //            noDataLabel.textColor     = UIColor.white
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //        }
    //        return numOfSections
    //    }
    
    //MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResVisitorRecordCell
        
        cell.type.text = language == "en" ? "Type" : "النوع"
        cell.count.text = language == "en" ? "Count" : "العدد"
        cell.date_time.text =  language == "en" ? "Date/Time" : "تاريخ / وقت"
        cell.status.text = language == "en" ? "Status" : "الحالة"
        cell.pincode.text = language == "en" ? "Pincode" : "الرقم السري"
        
        if language == "en" {
            cell.acceptBtn.setTitle("Accept", for: .normal)
            cell.rejectBtn.setTitle("Reject", for: .normal)
            
        }else if language == "ar" {
            cell.acceptBtn.setTitle("قبول", for: .normal)
            cell.rejectBtn.setTitle("رفض", for: .normal)
        }
        
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.typeLbl.text = dict.value(forKey: "visitor_types") as? String
        cell.nameLbl.text = dict.value(forKey: "date_time") as? String
        cell.dateLbl.text = dict.value(forKey: "pin_code") as? String
        cell.statusLbl.text = dict.value(forKey: "status") as? String
        var accountSts:Int!
        accountSts = dict.value(forKey: "account_status") as? Int
        
        
        
        var hostname:String!
        hostname = dict.value(forKey: "created_by") as? String
        cell.hostnameLbl.text = (language == "en" ? "Host Name:" : "اسم المضيف:") + " " + hostname
        
        var creattor:String!
        creattor = dict.value(forKey: "creator") as? String
        cell.creatorLbl.text = (language == "en" ? "Creator:" : "المنشئ:") + " " + creattor
        
        
        var shoests:String!
        shoests = dict.value(forKey: "status") as? String
        if shoests == "Active" {
            if accountSts == 1 && role == 2 {
                cell.deleteBtn.isHidden = true
                cell.cancleBtb.isHidden = true
                cell.deleteBtnWidthCons.constant = 0
                cell.cancleBtnWidthCons.constant = 0
            }else {
                cell.deleteBtn.isHidden = false
                cell.cancleBtb.isHidden = false
                cell.deleteBtnWidthCons.constant = 30
                cell.cancleBtnWidthCons.constant = 30
            }
            //cell.deleteBtn.isHidden = false
            cell.viewBtn.isHidden = false
            cell.editBtn.isHidden = false
            cell.downloadBtn.isHidden = false
            cell.acceptBtn.isHidden = true
            cell.rejectBtn.isHidden = true
            cell.accpet_reject_stack_view.isHidden = true
            cell.statusLbl.textColor = UIColor(red: 80/255, green: 155/255, blue: 90/255, alpha: 1.0)
        }else if shoests == "Cancelled" {
            cell.deleteBtn.isHidden = true
            cell.cancleBtb.isHidden = true
            cell.editBtn.isHidden = true
            cell.downloadBtn.isHidden = true
            cell.acceptBtn.isHidden = true
            cell.rejectBtn.isHidden = true
            cell.accpet_reject_stack_view.isHidden = true
            cell.viewBtn.isHidden = false
//            cell.viewbtnCons.constant = -120
            cell.statusLbl.textColor = UIColor.red
        }else if shoests == "Expired" {
            cell.deleteBtn.isHidden = true
            cell.viewBtn.isHidden = false
            cell.cancleBtb.isHidden = true
            cell.editBtn.isHidden = true
            cell.downloadBtn.isHidden = true
            cell.acceptBtn.isHidden = true
            cell.rejectBtn.isHidden = true
            cell.accpet_reject_stack_view.isHidden = true
//            cell.viewbtnCons.constant = -120
            cell.statusLbl.textColor = UIColor.yellow
        }else if shoests == "Completed" {
            cell.deleteBtn.isHidden = true
            cell.viewBtn.isHidden = false
            cell.cancleBtb.isHidden = true
            cell.editBtn.isHidden = true
            cell.downloadBtn.isHidden = true
            cell.acceptBtn.isHidden = true
            cell.rejectBtn.isHidden = true
            cell.accpet_reject_stack_view.isHidden = true
//            cell.viewbtnCons.constant = -120
            cell.statusLbl.textColor = UIColor(red: 56/255, green: 180/255, blue: 56/255, alpha: 1.0)
        }else if shoests == "Pending" {
            cell.deleteBtn.isHidden = true
            cell.viewBtn.isHidden = false
            cell.cancleBtb.isHidden = true
            cell.editBtn.isHidden = true
            cell.downloadBtn.isHidden = true
            cell.acceptBtn.isHidden = false
            cell.rejectBtn.isHidden = false
            cell.accpet_reject_stack_view.isHidden = false
            cell.statusLbl.textColor = UIColor.yellow
        }
        
        
        
        
        var count = Int()
        count = dict.value(forKey: "count") as! Int
        var countlb = String()
        countlb = String(count)
        cell.countLbl.text = countlb
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(handleTap1(_:)), for: .touchUpInside)
        cell.cancleBtb.tag = indexPath.row
        cell.cancleBtb.addTarget(self, action: #selector(handleTap2(_:)), for: .touchUpInside)
        cell.downloadBtn.tag = indexPath.row
        cell.downloadBtn.addTarget(self, action: #selector(handleTap5(_:)), for: .touchUpInside)
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(handleTap3(_:)), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(handleTap4(_:)), for: .touchUpInside)
        
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(handleTapView(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleTapView(_ sender: UIButton){
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var vistorid:Int!
        vistorid = dict.value(forKey: "visitor_id") as? Int
        
        
        let defaults = UserDefaults.standard
        defaults.set(vistorid, forKey: "VISTORID")
        defaults.synchronize()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GateVisitorDetailViewController") as! GateVisitorDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func handleTap(_ sender: UIButton){
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var subid = Int()
        subid = dict.value(forKey: "visitor_id") as! Int
        var str = String()
        str = "edit"
        let defaults = UserDefaults.standard
        defaults.set(subid, forKey: "VISNEWID")
        defaults.set(str, forKey: "VISEDIT")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNewVisitorViewController") as! CreateNewVisitorViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func handleTap1(_ sender: UIButton){
        let myAlert = UIAlertController(title: "HostGates", message: language == "en" ? "Are you sure to delete this visitor?" : "هل أنت متأكد من حذف هذا الزائر؟", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            var dict = NSDictionary()
            dict = self.response.object(at: sender.tag) as! NSDictionary
            var subid = Int()
            subid = dict.value(forKey: "visitor_id") as! Int
            if Reachability.isConnectedToNetwork() == true {
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserDeleteVisitorsRecord(Language: self.language, VisitorId: subid)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorDeleteRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserDeleteVisitorsRecord"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
            
        })
        myAlert.addAction(okAction);
        myAlert.addAction(sayhi);
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    @objc func handleTap2(_ sender: UIButton){
        
        
        let myAlert = UIAlertController(title: "HostGates", message: language == "en" ? "Are you sure to cancel this visitor?" : "هل أنت متأكد من إلغاء هذا الزائر؟", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            var dict = NSDictionary()
            dict = self.response.object(at: sender.tag) as! NSDictionary
            var subid = Int()
            subid = dict.value(forKey: "visitor_id") as! Int
            if Reachability.isConnectedToNetwork() == true {
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:15)
                Parsing().HostGateUserCancleVisitorsRecord(Language: self.language, VisitorId: subid)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorCancleRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserCancleVisitorsRecord"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
            
        })
        myAlert.addAction(okAction);
        myAlert.addAction(sayhi);
        
        self.present(myAlert, animated: true, completion: nil)
        
        
        
    }
    @objc func handleTap3(_ sender: UIButton){
        let nextview = AcceptView.intitiateFromNib()
        let model = PopModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            var dict = NSDictionary()
            dict = self.response.object(at: sender.tag) as! NSDictionary
            var subid = Int()
            subid = dict.value(forKey: "visitor_id") as! Int
            if Reachability.isConnectedToNetwork() == true {
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserAcceptRejectVisitors(Language: self.language, VisitorId: subid, Status: 1)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorAcceptRejectAction), name: NSNotification.Name(rawValue: "HostGateUserAcceptRejectVisitors"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
            model.closewithAnimation()
        }
        model.show(view: nextview)
        
        
    }
    @objc func handleTap4(_ sender: UIButton){
        let nextview = RejectView.intitiateFromNib()
        let model = PopModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            var dict = NSDictionary()
            dict = self.response.object(at: sender.tag) as! NSDictionary
            var subid = Int()
            subid = dict.value(forKey: "visitor_id") as! Int
            if Reachability.isConnectedToNetwork() == true {
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserAcceptRejectVisitors(Language: self.language, VisitorId: subid, Status: 3)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorAcceptRejectAction), name: NSNotification.Name(rawValue: "HostGateUserAcceptRejectVisitors"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
            model.closewithAnimation()
        }
        model.show(view: nextview)
        
    }
    @objc func handleTap5(_ sender: UIButton){
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var pincode = String()
        pincode = dict.value(forKey: "pin_code") as! String
        let defaults = UserDefaults.standard
        defaults.set(pincode, forKey: "PINCODE")
        defaults.synchronize()
        let text = "PIN code to access the gate is : \(pincode)"
        debugPrint(text)
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        activityViewController.popoverPresentationController?.sourceRect = self.navigationController?.navigationBar.frame ?? CGRect.zero
        activityViewController.popoverPresentationController?.sourceView = self.navigationController?.navigationBar
        self.present(activityViewController, animated: true)
        
        //        let nextview = SendOtpView.intitiateFromNib()
        //        let model = PopModel()
        //        nextview.buttonCancelHandler = {
        //            model.closewithAnimation()
        //        }
        //        nextview.buttonDoneHandler = {
        //           SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:"OTP Send Sucessfully." , buttonTitle: "OK")
        //           model.closewithAnimation()
        //        }
        //        model.show(view: nextview)
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchTxtbar.text == "" {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", Role: role, Visitor_Sorting: "")
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: searchTxtbar.text, Role: role, Visitor_Sorting: "")
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
        }
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchplace = searchText
    }
    
    
    
    @IBAction func searchBtnAction(_ sender: Any) {
        searchTxtbar.resignFirstResponder()
        if searchTxtbar.text == "" {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: "", Role: role, Visitor_Sorting: "")
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
        }else {
            if Reachability.isConnectedToNetwork() == true {
//                showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, SearchKeyword: searchTxtbar.text, Role: role, Visitor_Sorting: "")
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
        }
    }
    
    @IBAction func sortBtnAction(_ sender: Any) {
        let nextview = ResidentSortView.intitiateFromNib()
        let model = PopModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            self.defaults = UserDefaults.standard
            self.sortData = self.defaults.value(forKey: "SortRes") as? String
            var vist:String!
            if self.sortData == "All" {
                vist = ""
            }else if self.sortData == "Pending" {
                vist = "5"
            }
            else if self.sortData == "Upcoming" {
                vist = "upcoming"
            }else if self.sortData == "Past" {
                vist = "past"
            }else if self.sortData == "Active" {
                vist = "1"
            }else if self.sortData == "Expired" {
                vist = "4"
            }else if self.sortData == "Completed" {
                vist = "2"
            }else if self.sortData == "Cancelled"  {
                vist = "3"
            }
            model.closewithAnimation()
            if Reachability.isConnectedToNetwork() == true {
//                self.showWaitOverlay()
                GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateUserVisitorsRecordList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid, SearchKeyword: "", Role: self.role, Visitor_Sorting: vist)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorRecordListAction), name: NSNotification.Name(rawValue: "HostGateUserVisitorsRecordList"), object: nil)
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet Connection not Available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
            
        }
        model.show(view: nextview)
    }
    
    @IBAction func Export_btn_action(_ sender: Any) {
        GIFHUD.shared.show(withOverlay: true, duration:3)
        if response.count == 0{
            GIFHUD.shared.dismiss()
            GIFHUD.shared.dismiss()
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "No record found." : "لا يوجد سجلات.", buttonTitle: language == "en" ? "OK" : "حسنا")
        }else{
            
            let fileName = "Visitor_Sheet_120.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            var csvText = "S.No.,HostName,Visit Type,Count,Name,Date/Time,Check-In,Check-Out,Status,Creator\n"
            for i in 0...response.count-1 {
                var dict1 = NSDictionary()
                dict1 = response.object(at: i) as! NSDictionary
                
                //            var imageAr = NSArray()
                //            imageAr = dict1.value(forKey: "images") as! NSArray
                //            for i in 0..<imageAr.count{
                //                if imageString == ""{
                //                    imageString += "\"" + "\(imageAr[i])" + "\""
                //                }else{
                //                    imageString += "\\" + "\"" + "\(imageAr[i])" + "\""
                //                }
                //            }
                var a:Int!
                a = i + 1
                var name:String!
                name = dict1.value(forKey: "name") as? String
                let vc = name.replacingOccurrences(of: ",", with: "")
                print(vc)
                let newLine = "\("\(String(describing: a!))"),\((dict1.value(forKey: "created_by")) ?? ""),\((dict1.value(forKey: "visitor_types")) ?? ""),\((dict1.value(forKey: "count")) ?? ""),\((dict1.value(forKey: "name")) ?? ""),\((dict1.value(forKey: "date_time")) ?? ""),\(("N/A")),\(("N/A")),\((dict1.value(forKey: "status")) ?? ""),\((dict1.value(forKey: "creator")) ?? "")\n"
                csvText.append(contentsOf: newLine)
            }
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                // let csvData = URL(fileURLWithPath: path!.absoluteString)
                let textToShare = "Look at this awesome Iphone App!"
                let objectsToShare = [textToShare, path!] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes =  [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                GIFHUD.shared.dismiss()
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
        }
    }
    
    //MARK:- Logout WebService
    @objc func HostGateLogoutAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        
        
        DispatchQueue.main.async() {
            
            if status == 1{
             let deafults = UserDefaults.standard
             deafults.set(nil, forKey: "Logoutstatus")
             deafults.synchronize()
             let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
             self.navigationController?.pushViewController(Leaderboard, animated: true)
             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                print("Logout sucessfully.")
            }else {
                print("Somthing went wrong.")
             NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
            }
            
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        setSideMenu()
    }
    func setSideMenu() {
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
    
   //MARK: - Left drawer
   func setupLeftDrawer(_ controller: UIViewController) {
       
       self.leftDrawerTransition = DrawerTransition(target: controller, drawer: left)
       self.leftDrawerTransition.setPresentCompletion { print("left present...") }
       self.leftDrawerTransition.setDismissCompletion { print("left dismiss...") }
       self.leftDrawerTransition.edgeType = .left
       
       if user_sts == "1" {
           
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                   //                self.navigationController?.pushViewController(VC, animated: true)
                   
                   self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   })
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  
                  
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 2)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               } else if(indexpath.row == 3)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FreeAccountsViewController") as! FreeAccountsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "VisitorTypeNewViewController") as! VisitorTypeNewViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                 //  self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
                   
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       } else if user_sts == "2" && self.role == 1 {
           
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                   //                    VC.selectedIndex = 2
                   //                    if  VC.selectedIndex < VC.viewControllers!.count {
                   //                        var viewControllers = VC.viewControllers
                   //                        viewControllers?.remove(at:  VC.selectedIndex)
                   //                        VC.viewControllers = viewControllers
                   //                    }
                   //                    VC.selectedIndex = 0
                   self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   })
                   
                   
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 2) {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "VisitorTypeNewViewController") as! VisitorTypeNewViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(VC, animated: true)
                   }
               }else if (indexpath.row == 3) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }
               else if(indexpath.row == 4)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
                   
               else if(indexpath.row == 5)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }else if user_sts == "2" && self.role == 2 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0){
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FinDashboardViewController") as! FinDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 3) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FreeAccountsViewController") as! FreeAccountsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 4) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "FinReporingController") as! FinReporingController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 5) {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(VC, animated: true)
                   }
               }else if(indexpath.row == 6){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }else if user_sts == "2" && self.role == 3 {
           
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                   //                self.navigationController?.pushViewController(VC, animated: true)
                   
                   self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   })
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 2)
               {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                     //  self.navigationController?.pushViewController(VC, animated: true)
                   }
               } else if(indexpath.row == 3)
               {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "FreeAccountsViewController") as! FreeAccountsViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                       //self.navigationController?.pushViewController(VC, animated: true)
                   }
               }
               else if(indexpath.row == 4)
               {
                   //PAREEK
                   //CheckUser.....
                   let CheckSting = UserDefaults.standard.value(forKey: "Check_User_For_Support_Condition")as? String
                   if CheckSting == "1"{
                       let VC = self.appDelegate.storyboard1.instantiateViewController(withIdentifier: "Tabbar")
                       self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                       self.appDelegate.navigationController?.navigationBar.isHidden = true
                       self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                       self.appDelegate.window?.makeKeyAndVisible()
                   }else{
                       let VC = self.storyboard?.instantiateViewController(withIdentifier: "VisitorTypeNewViewController") as! VisitorTypeNewViewController
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(VC, animated: true)
                   }
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
                   
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
       else if user_sts == "3" && self.role == 1 && self.comType == 1 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResSubAccountsViewController") as! ResSubAccountsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if (indexpath.row == 3) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResVisitorRecordsViewController") as! ResVisitorRecordsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPasscardViewController") as! ResidentPasscardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 7){
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 9)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                        Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       } else if user_sts == "3" && self.role == 1 && self.comType == 2 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResVisitorRecordsViewController") as! ResVisitorRecordsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 3)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeePasscardViewController") as! EmployeePasscardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
                   else if(indexpath.row == 7)
                   {
                       let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                      // self.navigationController?.pushViewController(Leaderboard, animated: true)
                   }else if(indexpath.row == 8)
                   {
                       let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                      self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                          self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                          self.appDelegate.navigationController?.navigationBar.isHidden = true
                          self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                          self.appDelegate.window?.makeKeyAndVisible()
                      })
                       //self.navigationController?.pushViewController(Leaderboard, animated: true)
                   }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
       else if user_sts == "3" && self.role == 2 && comType == 1 {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if (indexpath.row == 1) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if (indexpath.row == 2) {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResVisitorRecordsViewController") as! ResVisitorRecordsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 3)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPasscardViewController") as! ResidentPasscardViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
                   
               }else if(indexpath.row == 4)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
       else {
           left.clickCellEvent { (indexpath) in
               //
               //            if(indexpath.row == -1)
               //            {
               //                // NotificationCenter.default.post(name: Notification.Name("notifyMilesChange"), object: nil)
               //            }
               if(indexpath.row == 0)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "GateHomeViewController") as! GateHomeViewController
                  
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
                   
               }
               else if(indexpath.row == 1)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 2)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "ResidentListViewController") as! ResidentListViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
                   
               else if(indexpath.row == 3)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "GateReverseVisitorRecordViewController") as! GateReverseVisitorRecordViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else if(indexpath.row == 4)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "ChangelanguageViewController") as! ChangelanguageViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 5)
               {
                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: VC)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(VC, animated: true)
               }
               else if(indexpath.row == 6)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 7)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                  // self.navigationController?.pushViewController(Leaderboard, animated: true)
               }else if(indexpath.row == 8)
               {
                   let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                  self.leftDrawerTransition.dismissDrawerViewController(animated: true, completion: {
                      self.appDelegate.navigationController = UINavigationController(rootViewController: Leaderboard)
                      self.appDelegate.navigationController?.navigationBar.isHidden = true
                      self.appDelegate.window?.rootViewController = self.appDelegate.navigationController
                      self.appDelegate.window?.makeKeyAndVisible()
                  })
                   //self.navigationController?.pushViewController(Leaderboard, animated: true)
               }
               else {
                   
                   let nextview = LogoutView.intitiateFromNib()
                   let model = BackModel()
                   nextview.buttonDoneHandler = {
                       Parsing().HostGatesLogout(UserId: self.user_Id, RoleId: self.roleId)
                                          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                                          NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateLogoutAction), name: NSNotification.Name(rawValue: "HostGatesLogoutNotification"), object: nil)
                       model.closewithAnimation()
                       
                   }
                   nextview.buttonCancelHandler = {
                       model.closewithAnimation()
                   }
                   model.show(view: nextview)
               }
               
               self.leftDrawerTransition.dismissDrawerViewController()
           }
       }
   }
    
    
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        var str = String()
        str = "add"
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "VISEDIT")
        defaults.synchronize()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNewVisitorViewController") as! CreateNewVisitorViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:-DGLoclalization Delegate
extension ResVisitorRecordsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
