//
//  ChangelanguageViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 23/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class ChangelanguageViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var english_btn: UIButton!
    @IBOutlet weak var arabic_btn: UIButton!
    
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    
    
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    var role:Int!
    var comType:Int!
    var user_Id:Int!
    var roleId:Int!
    var adminuserid:Int!
    
    var arb = ""
    var eng = ""
    var strdevice:NSString!
    var isFirstTimeReload = Bool()
    var deviceTocken = NSString()
    var flag_Arabic : NSString!
    
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    //MARK:- Create Variable for language localizations
    var defaults: UserDefaults!
    var Language:String!
    
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
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.Language == "en" ? "OK" : "حسنا")
                self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                self.removeAllOverlays()
               
            }else {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.Language == "en" ? "OK" : "حسنا")
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
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        self.comType = defaults.integer(forKey: "COMTYPE")
        Language = defaults.value(forKey: "Language") as? String
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        setupLeftDrawer(self)
        
        if Language == "en" {
            self.titlelbl.text = "Change Language"
            self.arabic_btn.setTitle("عربى", for: .normal)
            self.english_btn.setTitle("ENGLISH", for: .normal)
            
        }else if Language == "ar" {
            self.titlelbl.text = "تغيير اللغة"
            self.arabic_btn.setTitle("عربى", for: .normal)
            self.english_btn.setTitle("ENGLISH", for: .normal)
        }
        
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
            
        }
        
        
        Parsing().HostGateCheckAccountStatus(Language: Language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
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
    
    @IBAction func sidemeuBtnAction(_ sender: Any) {
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
    
    
    @IBAction func english_btn_Actionb(_ sender: Any) {
        
        if user_sts == "1" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarVcViewController
            Language = "en"
            
            let defaults = UserDefaults.standard
            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if user_sts == "2" {
            if self.role == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarVcViewController
                Language = "en"
                
                let defaults = UserDefaults.standard
                defaults.set(Language, forKey: "Language")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if self.role == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinDashboardViewController") as! FinDashboardViewController
                Language = "en"
                
                let defaults = UserDefaults.standard
                defaults.set(Language, forKey: "Language")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarVcViewController
                Language = "en"
                
                let defaults = UserDefaults.standard
                defaults.set(Language, forKey: "Language")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if user_sts == "3" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
            Language = "en"
            
            let defaults = UserDefaults.standard
            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.user_sts == "4"  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GateHomeViewController") as! GateHomeViewController
            Language = "en"
            
            let defaults = UserDefaults.standard
            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func arabic_btn_Action(_ sender: Any) {
        
        if user_sts == "1" {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarVcViewController
            Language = "ar"
            
            let defaults = UserDefaults.standard
            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if user_sts == "2" {
            if self.role == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarVcViewController
//                vc.selectedIndex = 2
//                if  vc.selectedIndex < vc.viewControllers!.count {
//                    var viewControllers = vc.viewControllers
//                    viewControllers?.remove(at:  vc.selectedIndex)
//                    vc.viewControllers = viewControllers
//                }
//                vc.selectedIndex = 0
                Language = "ar"
                
                let defaults = UserDefaults.standard
                defaults.set(Language, forKey: "Language")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if self.role == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinDashboardViewController") as! FinDashboardViewController
              
                Language = "ar"
                
                let defaults = UserDefaults.standard
                defaults.set(Language, forKey: "Language")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! TabbarVcViewController
                Language = "ar"
                
                let defaults = UserDefaults.standard
                defaults.set(Language, forKey: "Language")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if user_sts == "3" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardViewController") as! UserDashboardViewController
            Language = "ar"
            
            let defaults = UserDefaults.standard
            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.user_sts == "4"  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GateHomeViewController") as! GateHomeViewController
            Language = "ar"
            
            let defaults = UserDefaults.standard
            defaults.set(Language, forKey: "Language")
            defaults.synchronize()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

