//
//  FinDashboardViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 15/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class FinDashboardViewController: UIViewController {
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var defaults: UserDefaults!
    
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    var user_Id:Int!
    var arb = ""
    var eng = ""
    
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    //MARK:- IBOutlet
    @IBOutlet weak var total_community: UILabel!
    @IBOutlet weak var total_staff: UILabel!
    @IBOutlet weak var total_resident: UILabel!
    @IBOutlet weak var total_gate: UILabel!
    @IBOutlet weak var total_communityLbl: UILabel!
    @IBOutlet weak var total_administratorLbl: UILabel!
    @IBOutlet weak var total_usersLbl: UILabel!
    @IBOutlet weak var total_gatesLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var updateImage:String!
    var Name:String!
    var IdNumber:String!
    var Email:String!
    var CountryCode:String!
    var Phone:String!
    var PhoneNumber:String!
    
    var businesssname:String!
    var businesssaddress:String!
    var updateImage1:String!
    var roleId:Int!
    var adminuserid:Int!
    var role:Int!
    var username:String!
    var comType:Int!
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
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
            }
            else if status == 1{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
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
    
    //MARK:- ForgotPasswordStudent WebService
    @objc func HostGateDashboard(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            
            if status == 0{
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: nil)
//                self.removeAllOverlays()
                  GIFHUD.shared.dismiss()
                
            }else{
                self.UnhideLayout()
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
                tl_res = response.value(forKey: "total_resident") as! Int
                var tlres = String()
                tlres = String(tl_res)
                
                var tl_gate = Int()
                tl_gate = response.value(forKey: "total_gate") as! Int
                var tlgt = String()
                tlgt = String(tl_gate)
                
                self.total_community.text = tl
                self.total_staff.text = tls
                self.total_resident.text = tlres
                self.total_gate.text = tlgt
                
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateResendOtpNotification"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    //MARK:- Login WebService
    @objc func HostGateGetUserDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                
                self.updateImage = response.value(forKey: "profile_picture") as? String
                self.Name = response.value(forKey: "full_name") as? String
                self.IdNumber = response.value(forKey: "id_number") as? String
                self.Email = response.value(forKey: "email") as? String
                self.CountryCode = response.value(forKey: "country_code") as? String
                self.Phone = response.value(forKey: "phone") as? String
                self.username = response.value(forKey: "username") as? String
                
                let defaults = UserDefaults.standard
                defaults.set(self.Name, forKey: "Name")
                defaults.set(self.updateImage, forKey: "Image")
                defaults.set(self.username, forKey: "USer")
                defaults.set(self.IdNumber, forKey: "IDNum")
                defaults.set(self.Email, forKey: "EMAILADDRESS")
                defaults.set(self.Phone, forKey: "PHONENumber")
                defaults.set(self.CountryCode, forKey: "CountryCode")
                defaults.synchronize()
                
//                self.removeAllOverlays()
//                GIFHUD.shared.dismiss()
            }
        }
    }
    //MARK:- Login WebService
    @objc func HostGateGetBusinessDetailAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                // SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: "OK")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                
                self.updateImage1 = response.value(forKey: "logo") as? String
                self.businesssname = (response.value(forKey: "name") as? String)!
                self.businesssaddress = (response.value(forKey: "address") as? String)!
                
                let defaults = UserDefaults.standard
                defaults.set(self.businesssname, forKey: "BusinessName")
                defaults.set(self.updateImage1, forKey: "BusinessImage")
                defaults.set(self.businesssaddress, forKey: "BusinessAddress")
                defaults.synchronize()
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        
        //CheckUser.....
        let CheckSting = defaults.value(forKey: "Check_User_For_Support_Condition")as? String
        if CheckSting == "1"{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle , message: self.language == "en" ? "Your account is expired! So please contact to Admin!!" : "انتهت صلاحية حسابك! لذا يرجى الاتصال على الادارية!", buttonTitle: self.language == "en" ? "OK" : "حسنا")
            }
        }
        
        self.hideLayout()
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as? NSString ?? ""
        adminuserid = defaults.integer(forKey: "AdminUserId")
        self.role = defaults.integer(forKey: "ROLE")
        user_sts = defaults.value(forKey: "User_Status") as! String
        self.comType = defaults.integer(forKey: "COMTYPE")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupLeftDrawer(self)
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateDashboard(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDashboardNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDashboard), name: NSNotification.Name(rawValue: "HostGateDashboardNotification"), object: nil)
        
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateUserDetail(Language: self.language, user_Id: user_Id, RoleId: roleId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetUserDetailAction), name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateGetBusinessDetail(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserID: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetBusinessDetailAction), name: NSNotification.Name(rawValue: "HostGateGetBusinessDetail"), object: nil)
        
        
        
        //MARK:- language Code Start
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
            
        }
        
       // GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    //MARK:- language Function
    func decorate() {
        self.titleLbl.text = language == "en" ? "Dashboard" : "لوحة القيادة"
        self.total_communityLbl.text = language == "en" ? "Total Communities" : "مجموع المجتمعات"
        self.total_administratorLbl.text = language == "en" ? "Total Administrators" : "مجموع المسؤولين"
        self.total_usersLbl.text = language == "en" ? "Total Users" : "مجموع المستخدمين"
        self.total_gatesLbl.text = language == "en" ? "Total Gates" : "مجموع البوابات"
    }
    
    func hideLayout(){
        self.total_community.isHidden = true
        self.total_staff.isHidden = true
        self.total_resident.isHidden = true
        self.total_gate.isHidden = true
    }
    
    func UnhideLayout(){
        self.total_community.isHidden = false
        self.total_staff.isHidden = false
        self.total_resident.isHidden = false
        self.total_gate.isHidden = false
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
    
    @IBAction func sidemenuBtnAction(_ sender: Any) {
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
extension FinDashboardViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}

