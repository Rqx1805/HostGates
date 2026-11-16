//
//  FinReporingController.swift
//  HostGate
//
//  Created by Vipul on 28/03/20.
//  Copyright © 2020 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class FinReporingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- IBOutlets
    @IBOutlet weak var title_lbl_ref: UILabel!
    @IBOutlet weak var total_communities_lbl_ref: UILabel!
    @IBOutlet weak var total_communities_lbl: UILabel!
    @IBOutlet weak var total_administrators_lbl_ref: UILabel!
    @IBOutlet weak var total_administrators_lbl: UILabel!
    @IBOutlet weak var total_users_lbl_ref: UILabel!
    @IBOutlet weak var total_users_lbl: UILabel!
    @IBOutlet weak var total_gates_lbl_ref: UILabel!
    @IBOutlet weak var total_gates_lbl: UILabel!
    @IBOutlet weak var total_subusers_lbl_ref: UILabel!
    @IBOutlet weak var total_subusers_lbl: UILabel!
    @IBOutlet weak var total_Purchase_account_lbl_ref: UILabel!
    @IBOutlet weak var total_purchase_lbl: UILabel!
    @IBOutlet weak var total_assigined_account_lbl_ref: UILabel!
    @IBOutlet weak var total_assigined_account_lbl: UILabel!
    @IBOutlet weak var communities_lbl_ref: UILabel!
    @IBOutlet weak var finrepoting_table_view: UITableView!
    
    //MARK:- Variable
    var defaults: UserDefaults!
    var language:String!
    var roleId:Int!
    var user_Id:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var deviceTocken = NSString()
    var adminuserid:Int!
    var response = NSMutableArray()
    
   //MARK:- Side bar code
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var comType:Int!
    var window:UIWindow!
    var referseControl = UIRefreshControl()
    
    //MARK:- Life view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaults = UserDefaults.standard
        self.user_Id = defaults.integer(forKey: "UserIDGet")
        self.roleId = defaults.integer(forKey: "RoleId")
        self.deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        self.language = defaults.value(forKey: "Language") as? String
        self.adminuserid = defaults.integer(forKey: "AdminUserId")
        self.role = defaults.integer(forKey: "ROLE")
        self.user_sts = defaults.value(forKey: "User_Status") as! String
        self.comType = defaults.integer(forKey: "COMTYPE")
        if identifierManager.isAdvertisingTrackingEnabled {
              deviceId = identifierManager.advertisingIdentifier.uuidString
          }
        
        self.decorate() // Language Function
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupLeftDrawer(self)
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        finrepoting_table_view.addSubview(referseControl)
        
        //MARK:- Table List web-service
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateReporting(Language: language, UserID: user_Id, RoleID: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReporting), name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
    }
    
    @objc func refresh(sender:AnyObject) {
         finrepoting_table_view.reloadData()
         referseControl.endRefreshing()
         GIFHUD.shared.show(withOverlay: true, duration:15)
         Parsing().HostGateReporting(Language: language, UserID: user_Id, RoleID: roleId, AdminUserID: adminuserid)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateReporting), name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
          // Code to refresh table view
      }
      
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- Session-Out Web-service
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
       
    }
     
    
    //MARK:- language Function
    func decorate() {
        self.total_communities_lbl_ref.text = language == "en" ? "Total Communities" : "مجموع المجتمعات"
        self.total_users_lbl_ref.text = language == "en" ? "Total Users" : "مجموع المستخدمين"
        self.total_gates_lbl_ref.text = language == "en" ? "Total Gates" : "مجموع البوابات"
        self.total_administrators_lbl_ref.text = language == "en" ? "Total Administrators" : "مجموع المسؤولين"
        self.total_subusers_lbl_ref.text = language == "en" ? "Total Subusers" : "مجموع المستخدمين الفرعيين"
        self.total_Purchase_account_lbl_ref.text = language == "en" ? "Total Purchased Accounts" : "إجمالي الحسابات المشتراة"
        self.total_assigined_account_lbl_ref.text = language == "en" ? "Total Assigned Accounts" : "مجموع الحسابات المستخدمة"
        self.title_lbl_ref.text = language == "en" ? "Reports" : "تقارير"
        self.communities_lbl_ref.text = language == "en" ? "Communities" : "مجتمعات"
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.finrepoting_table_view.bounds.size.width, height: self.finrepoting_table_view.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.finrepoting_table_view.backgroundView  = noDataLabel
        self.finrepoting_table_view.separatorStyle  = .none
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
    
    //MARK:- IBAction
    @IBAction func fin_report_back_btn_action(_ sender: Any) {
        self.setSideMenu()
    }
    
    func setSideMenu() {
        self.leftDrawerTransition.presentDrawerViewController(animated: true)
    }
    
    //MARK:- Table view Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FinReportCell
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.title_lbl.text = dict.value(forKey: "community_title") as? String
        var comtype:Int!
        comtype = dict.value(forKey: "community_type") as? Int
        
        if comtype == 1 {
            cell.type_lbl.text = language == "en" ? "Residential Complex" : "مجمع سكني"
        }else if comtype == 2 {
            cell.type_lbl.text = language == "en" ? "Corporate Office" : "مقر شركة"
        }else if comtype == 0{
            cell.type_lbl.text = "N/A"
        }
        cell.no_of_assignied_user_lbl.text = String(describing: dict.value(forKey: "total_users") as! Int)
        cell.no_of_users_lbl.text = String(describing: dict.value(forKey: "total_subusers") as! Int)
        cell.no_of_sub_users_lbl.text = String(describing: dict.value(forKey: "total_gates") as! Int)
        cell.no_of_visit_records_lbl.text = String(describing: dict.value(forKey: "total_visit") as! Int)
        
        cell.title_lbl_ref.text = language == "en" ? "Title:" : "عنوان:"
        cell.type_lbl_ref.text = language == "en" ? "Type:" : "اكتب:"
        cell.no_of_users_lbl_ref.text = language == "en" ? "No. of subusers" : "عدد الطواحين"
        cell.no_of_sub_users_lbl_ref.text = language == "en" ? "No. of gates" : "عدد البوابات"
        cell.no_of_visit_records_lbl_ref.text = language == "en" ? "No. of visit records" : "عدد سجلات الزيارة"
        cell.no_of_assignied_user_lbl_ref.text = language == "en" ? "No. of users" : "عدد المستخدمين"
        
        return cell
    }
    
    //MARK:- Private function
    @objc func HostGateAccountStatusAction(_ notification: Notification) {
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            
            if status == 0{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
//                self.removeAllOverlays()
                self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
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
       
    @objc func HostGateReporting(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        DispatchQueue.main.async() {
            
            if status == 0{
                self.dataNotFound()
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            } else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                
                self.total_communities_lbl.text = "\(response.value(forKey: "total_community") as! Int)"
                self.total_administrators_lbl.text = "\(response.value(forKey: "total_staff") as! Int)"
                self.total_users_lbl.text = "\(response.value(forKey: "total_users") as! Int)"
                self.total_gates_lbl.text = "\(response.value(forKey: "total_gate") as! Int)"
                self.total_assigined_account_lbl.text = "\(response.value(forKey: "total_assigned_account") as! Int)"
                self.total_purchase_lbl.text = "\(response.value(forKey: "total_purchased_account") as! Int)"
                self.total_subusers_lbl.text = "\(response.value(forKey: "total_subusers") as! Int)"
                
                self.response = response.value(forKey: "community_list") as! NSMutableArray
                self.finrepoting_table_view.reloadData()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateReportingNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                
            }
        }
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
}
