//
//  VisitortypesViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class VisitortypesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- IBOutlet
    @IBOutlet weak var visitorTableview: UITableView!
    @IBOutlet weak var visitor_typelbl: UILabel!
    @IBOutlet weak var actionlbl: UILabel!
    @IBOutlet weak var types_Ar: UILabel!
    
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var defaults: UserDefaults!
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    var role:Int!
    @IBOutlet weak var addBtn: UIButton!
    var response:NSMutableArray?
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var comtype:String!
    var referseControl = UIRefreshControl()
    var noDataLabel = UILabel()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateVisitorList(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
                self.response?.removeAllObjects()
                self.visitorTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                var dict = NSMutableDictionary()
                dict = (notification.userInfo?["data"] as? NSMutableDictionary)!
                if self.comtype == "Residential Complex" {
                    self.response = dict.value(forKey: "Residential") as? NSMutableArray
                    if self.response == nil {
                        self.dataNotFound()
                    }else {
                        self.noDataLabel.isHidden = true
                    }
                }else {
                    self.response = dict.value(forKey: "Corporate") as? NSMutableArray
                    if self.response == nil {
                        self.dataNotFound()
                    }else {
                        self.noDataLabel.isHidden = true
                    }
                }
                
                print("response: \(String(describing: self.response))")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
                self.visitorTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    @objc func HostGateDeleteAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        
        DispatchQueue.main.async() {
            if status == 0 {
                self.response?.removeAllObjects()
                self.visitorTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                Parsing().HostGateVisitorTypeList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorList), name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
                self.visitorTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    //MARK:- Login WebService
       @objc func HostGateAccountStatusAction(_ notification: Notification) {
           let status = (notification.userInfo?["status"] as? Int)!
           let str_message = (notification.userInfo?["message"] as? String)!
           
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
           
           DispatchQueue.main.async() {
               
               if status == 0{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                   self.removeAllOverlays()
                   self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
               }
               else if status == 1{
                   NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                   SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                   self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                   self.removeAllOverlays()
                GIFHUD.shared.dismiss()
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
        language = defaults.value(forKey: "Language") as? String
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        comtype = defaults.value(forKey: "RESCOM") as? String
        if identifierManager.isAdvertisingTrackingEnabled {
                   deviceId = identifierManager.advertisingIdentifier.uuidString
               }
        //        if user_sts == "1" {
        //            addBtn.isHidden = false
        //        }else if user_sts == "2" {
        //            addBtn.isHidden = true
        //        }
        response = NSMutableArray()
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        visitorTableview.addSubview(referseControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("Addvisitortype"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("Updatevisitortype"), object: nil)
        
        
//        showWaitOverlay()
         GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorTypeList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorList), name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        
       
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    
    //MARK:- language Function
    func decorate() {
        self.visitor_typelbl.text = language == "en" ? "Types(en)" : "أنواع (en)"
        self.types_Ar.text = language == "en" ? "Types(ar)" : "أنواع (ar)"
        self.actionlbl.text = language == "en" ? "Action" : "عمل"
    }
    
    
    @objc func refresh(sender:AnyObject) {
        visitorTableview.reloadData()
        referseControl.endRefreshing()
//        showWaitOverlay()
//         GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorTypeList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorList), name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        // Code to refresh table view
    }
    
    
    @objc func currencyItemChosen(_ pNotification: Notification?) {
//        showWaitOverlay()
         GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorTypeList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorList), name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
//        showWaitOverlay()
         GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateVisitorTypeList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVisitorList), name: NSNotification.Name(rawValue: "HostGateVisitorTypeList"), object: nil)
        
    }
    
    
    func dataNotFound(){
        noDataLabel    = UILabel(frame: CGRect(x: 0, y: 0, width: visitorTableview.bounds.size.width, height: visitorTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        visitorTableview.backgroundView  = noDataLabel
        visitorTableview.separatorStyle  = .none
    }
    
    
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //
    //        var numOfSections: Int = 0
    //        if response == nil {
    //
    //                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //                noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //                noDataLabel.textColor     = UIColor.white
    //                noDataLabel.textAlignment = .center
    //                tableView.backgroundView  = noDataLabel
    //                tableView.separatorStyle  = .none
    //        }else {
    //            if response.count>0
    //            {
    //                tableView.separatorStyle = .none
    //                numOfSections            = 1
    //                tableView.backgroundView = nil
    //            }
    //            else
    //            {
    //                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //                    noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
    //                    noDataLabel.textColor     = UIColor.white
    //                    noDataLabel.textAlignment = .center
    //                    tableView.backgroundView  = noDataLabel
    //                    tableView.separatorStyle  = .none
    //            }
    //        }
    //
    //        return numOfSections
    //    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VisitortypesCell
        
       
        cell.createLbl.text = language == "en" ? "Created By Super Admin" : "التي أنشأتها سوبر الادارية"
        
        var dict = NSDictionary()
        dict = response?.object(at: indexPath.row) as! NSDictionary
        cell.username.text = dict.value(forKey: "type") as? String
        cell.user_name_Ar.text = dict.value(forKey: "type_ar") as? String
        var sts = Int()
        sts = (dict.value(forKey: "status") as? Int)!
        
        if sts == 1 {
            cell.editBtn.isHidden = true
            cell.deleteBtn.isHidden = true
            cell.createLbl.isHidden = false
            
        }else {
            cell.editBtn.isHidden = false
            cell.deleteBtn.isHidden = false
            cell.createLbl.isHidden = true
        }
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        
        cell.editBtn.addTarget(self, action: #selector(Edit_ButtonAction), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(DeleteButton_Action), for: .touchUpInside)
        return cell
    }
    @objc func Edit_ButtonAction(_ sender: UIButton) {
        let btn = sender as? UIButton
        var dict = NSDictionary()
        dict = response?.object(at: btn!.tag) as! NSDictionary
        var typeid:Int!
        typeid = dict.value(forKey: "type_id") as? Int
        var strn = String()
        strn = "Edit"
        let defaults = UserDefaults.standard
        defaults.set(typeid, forKey: "TYPEID")
        defaults.set(strn, forKey: "VISITTYPE")
        
        defaults.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVisitirtypesviewController") as! AddVisitirtypesviewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func DeleteButton_Action(_ sender: UIButton) {
        var btn = sender as? UIButton
        var dict = NSDictionary()
        dict = response?.object(at: btn!.tag) as! NSDictionary
        var typeid:Int!
        typeid = dict.value(forKey: "type_id") as? Int
        
        let indexPath = NSIndexPath(row: (btn?.tag)!, section: 0)
        visitorTableview.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)
        
        let myAlert = UIAlertController(title: "HostGates", message: self.language == "en" ? "Are you sure to delete this visitor type?" : "هل أنت متأكد من حذف هذا النوع من الزوار؟", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: language == "en" ? "No" : "لا", style: UIAlertAction.Style.cancel, handler:nil)
        
        let sayhi = UIAlertAction(title: language == "en" ? "Yes" : "نعم", style: UIAlertAction.Style.default, handler:  { action in
            if Reachability.isConnectedToNetwork() == true {
//                self.showWaitOverlay()
                 GIFHUD.shared.show(withOverlay: true, duration:3)
                Parsing().HostGateDeleteVisitorType(Language: self.language, TypeId: typeid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDeleteVisitorType"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDeleteAction), name: NSNotification.Name(rawValue: "HostGateDeleteVisitorType"), object: nil)
                
            }else {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: self.language == "en" ? "Internet connection not available!" : "اتصال إنترنت غير متوفر!" , buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
        })
        myAlert.addAction(okAction);
        myAlert.addAction(sayhi);
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    //    @IBAction func addBtnAction(_ sender: Any) {
    //        var strn = String()
    //        strn = "Add"
    //        let defaults = UserDefaults.standard
    //        defaults.set(strn, forKey: "VISITTYPE")
    //        defaults.synchronize()
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVisitirtypesviewController") as! AddVisitirtypesviewController
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK:-DGLoclalization Delegate
extension VisitortypesViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
