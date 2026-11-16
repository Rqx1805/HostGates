//
//  FreeAccountsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 05/12/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class FreeAccountsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var freeaccountTable: UITableView!
    @IBOutlet weak var titlelbl: UILabel!
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var defaults: UserDefaults!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    var role:Int!
    var comType:Int!
    
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var deviceTocken = NSString()
    
    var response = NSMutableArray()
    var referseControl = UIRefreshControl()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateFreeAccountsList(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: nil)
                self.response.removeAllObjects()
                self.freeaccountTable.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                print("response: \(String(describing: self.response))")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: nil)
                self.freeaccountTable.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        self.comType = defaults.integer(forKey: "COMTYPE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        setupLeftDrawer(self)
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        freeaccountTable.addSubview(referseControl)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:10)
        Parsing().HostGateFreeAccounts(Language: self.language, UserID: user_Id, RoleID: roleId, AdminuserId: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateFreeAccountsList), name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: nil)
        
    
        
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
        self.titlelbl.text = language == "en" ? "Free Accounts" : "حسابات مجانية"
    }
    
    @objc func refresh(sender:AnyObject) {
        freeaccountTable.reloadData()
        referseControl.endRefreshing()
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateFreeAccounts(Language: self.language, UserID: user_Id, RoleID: roleId, AdminuserId: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateFreeAccountsList), name: NSNotification.Name(rawValue: "HostGateFreeAccountsNotification"), object: nil)
        // Code to refresh table view
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.freeaccountTable.bounds.size.width, height: self.freeaccountTable.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.freeaccountTable.backgroundView  = noDataLabel
        self.freeaccountTable.separatorStyle  = .none
    }
    
    
    //MARK:- UITableView Delegate
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if response.count>0
    //        {
    //            tableView.separatorStyle = .singleLine
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
    
    //MARK:- UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FreeAccountCell
        
        cell.admin_gate.text = language == "en" ? "Admin/Gate:" : "بوابة المشرف:"
        cell.date_of_activate.text = language == "en" ? "Date of activate:" : "تاريخ التفعيل:"
        cell.expiry_date.text = language == "en" ? "Expiry date:" : "تاريخ الانتهاء:"
        cell.no_of_account.text = language == "en" ? "No. of accounts" : "عدد الحسابات"
        cell.no_of_account_use.text = language == "en" ? "No. of accounts unused" : "عدد الحسابات غير المستخدمة"
        cell.vaildity.text = language == "en" ? "Valiidty(month)" : "صلاحية(شهر)"
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        cell.adminLbl.text = dict.value(forKey: "admin_gate") as? String
        cell.dateDeactiveLbl.text = dict.value(forKey: "date_activate") as? String
        cell.exprireLbl.text = dict.value(forKey: "expiry_date") as? String
        var noAcc = Int()
        noAcc = dict.value(forKey: "no_account") as! Int
        
        var noAccstr = String()
        noAccstr = String(noAcc)
        
        cell.noofAccountLbl.text = noAccstr
        
        var noAccUn = Int()
        noAccUn = dict.value(forKey: "no_account_unused") as! Int
        
        var noAccUnstr = String()
        noAccUnstr = String(noAccUn)
        
        cell.noofaccountunusedLbl.text = noAccUnstr
        
        var Duration = Int()
        Duration = dict.value(forKey: "duration") as! Int
        
        var Durationstr = String()
        Durationstr = String(Duration)
        
        cell.validityLbl.text = Durationstr
        return cell
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
    
    
    @IBAction func sideMenuBtnAction(_ sender: Any) {
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
    
    
}

//MARK:-DGLoclalization Delegate
extension FreeAccountsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}

