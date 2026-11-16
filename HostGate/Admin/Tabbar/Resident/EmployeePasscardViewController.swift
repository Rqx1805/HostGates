//
//  EmployeePasscardViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class EmployeePasscardViewController: UIViewController {
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user_sts = String()
    var defaults: UserDefaults!
    var role:Int!
    
    var comType:Int!
    var user_id:Int!
    var roleId:Int!
    var adminuserid:Int!
    var communityID:Int!
    var updateImage:String!
    let identifierManager = ASIdentifierManager.shared()
       var deviceId = String()
    var deviceTocken = NSString()
    
    //MARK:- IBOutlet
    @IBOutlet weak var hostpassBtn: UIButton!
    @IBOutlet weak var qrcodeBtn: UIButton!
    @IBOutlet weak var qrcodelineLbl: UILabel!
    @IBOutlet weak var hostpasslineLbl: UILabel!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
         language = defaults.value(forKey: "Language") as? String
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        self.comType = defaults.integer(forKey: "COMTYPE")
        user_id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        communityID = defaults.integer(forKey: "COMNEWID")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        setupLeftDrawer(self)
        
        hostpassBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        qrcodeBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        
        
        hostpasslineLbl.isHidden = false
        qrcodelineLbl.isHidden = true
        
        
        // btn_str = "user"
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EMPPASSViewController") as! EMPPASSViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        
        //MARK:- language Code Start
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
       // GIFHUD.shared.show(withOverlay: true, duration:1)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        if language == "en" {
            self.hostpassBtn.setTitle("ID Card", for: .normal)
            self.qrcodeBtn.setTitle("QR Code", for: .normal)
            
        }else if language == "ar" {
            self.hostpassBtn.setTitle("بطاقة التعريف", for: .normal)
            self.qrcodeBtn.setTitle("رمز الاستجابة السريعة", for: .normal)
        }
        self.titlelbl.text = language == "en" ? "Pass Cards" : "بطاقات المرور"
        
    }
    
    
    @IBAction func hostBtnAction(_ sender: Any) {
        
        hostpassBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        qrcodeBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        
        hostpasslineLbl.isHidden = false
        qrcodelineLbl.isHidden = true
        
        
        // btn_str = "user"
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EMPPASSViewController") as! EMPPASSViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    
    @IBAction func qrcodeBtnAction(_ sender: Any) {
        hostpassBtn.setTitleColor(UIColor.lightGray, for: .normal)
        qrcodeBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        
        
        hostpasslineLbl.isHidden = true
        qrcodelineLbl.isHidden = false
        
        
        // btn_str = "user"
        
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "EMPQRCODEViewController") as! EMPQRCODEViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_main.frame.size.width, height: self.view_main.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
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
                         Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                        Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                       Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                        Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                        Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                       Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                        Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
                        Parsing().HostGatesLogout(UserId: self.user_id, RoleId: self.roleId)
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
extension EmployeePasscardViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
