//
//  MyProfileViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class MyProfileViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var userprofileview: UIView!
    @IBOutlet weak var businessprofileview: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var IdNumberLBL: UILabel!
    @IBOutlet weak var EmailIdLbl: UILabel!
    @IBOutlet weak var PhoneNumberLbl: UILabel!
    @IBOutlet weak var BusinessProfileImageView: UIImageView!
    @IBOutlet weak var BusinessAddressLbl: UILabel!
    @IBOutlet weak var BusinessNameLbl: UILabel!
    @IBOutlet weak var FullNameLbl: UILabel!
    @IBOutlet weak var countryCodeTxt: UILabel!
    @IBOutlet weak var idnameLbl: UILabel!
    @IBOutlet weak var editBusinessBtn: UIButton!
    @IBOutlet weak var profileEditBtn: UIButton!
    @IBOutlet weak var emIDLBl: UILabel!
    @IBOutlet weak var mBlbl: UILabel!
    @IBOutlet weak var mblineLbl: UILabel!
    @IBOutlet weak var mblinelblheightCons: NSLayoutConstraint!
    @IBOutlet weak var titlelbl: UILabel!
    
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user_sts = String()
    var defaults: UserDefaults!
    var user_Id:Int!
    var roleId:Int!
    
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    var comType:Int!
    
    var updateImage:String!
    var Name:String!
    var IdNumber:String!
    var Email:String!
    var PhoneNumber:String!
    var countryCode:String!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    var businessName:String!
    var BuseinessAddress:String!
    var businessImage:String!
    var role:Int!
    var username:String!
    var busy:String!
    var decodedString1:String!
    var adminuserid:Int!
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
    
    @IBOutlet weak var userviewTopCons: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        user_sts = defaults.value(forKey: "User_Status") as! String
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        Name = defaults.value(forKey: "Name") as? String
        role = defaults.integer(forKey: "ROLE")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        username = defaults.value(forKey: "USer") as? String
        updateImage = defaults.value(forKey: "Image") as? String
        IdNumber = defaults.value(forKey: "IDNum") as? String
        Email = defaults.value(forKey: "EMAILADDRESS") as? String
        PhoneNumber = defaults.value(forKey: "PHONENumber") as? String
        countryCode = defaults.value(forKey: "CountryCode")  as? String
        language = defaults.value(forKey: "Language") as? String
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        if countryCode == nil {
            
        }else {
            decodedString1 =  countryCode.removingPercentEncoding //Decode for (+)sign
        }
        
        self.comType = defaults.integer(forKey: "COMTYPE")
        busy = defaults.value(forKey: "BUSI") as? String
//        if busy == "busines"{
//            userviewTopCons.constant = 50
//            businessprofileview.isHidden = true
//        }else if busy == nil {
//            userviewTopCons.constant = 50
//            businessprofileview.isHidden = true
//        }else {
//            userviewTopCons.constant = 11
//            businessprofileview.isHidden = false
//        }
        let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
        profileImageView.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "load_logo"))
        
        if self.user_sts == "1" {
            editBusinessBtn.isHidden = false
            
        }else if self.user_sts == "2" && role == 1 {
            editBusinessBtn.isHidden = true
        }else if self.user_sts == "2" && role == 2 {
            editBusinessBtn.isHidden = true
        }else if self.user_sts == "2" && role == 3 {
            editBusinessBtn.isHidden = false
        }else if self.user_sts == "3" && role == 1{
            editBusinessBtn.isHidden = true
        }else if self.user_sts == "3" && role == 2{
            editBusinessBtn.isHidden = true
        }else if user_sts == "4" {
            editBusinessBtn.isHidden = true
        }
        
        
        
        userprofileview.layer.cornerRadius = 5
        businessprofileview.layer.cornerRadius = 5
        if user_sts == "1" {
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.text = decodedString1
        }
        else  if user_sts == "2"{
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.text = decodedString1
        }
        else  if user_sts == "3" {
            if self.role == 1 && self.comType == 1 {
                self.mBlbl.isHidden = false
                self.mblineLbl.isHidden = false
                self.mblinelblheightCons.constant = 1
                self.PhoneNumberLbl.isHidden = false
                self.countryCodeTxt.isHidden = false
            }else if self.role == 2 && self.comType == 1 {
                self.mBlbl.isHidden = true
                self.mblineLbl.isHidden = true
                self.mblinelblheightCons.constant = 0
                self.PhoneNumberLbl.isHidden = true
                self.countryCodeTxt.isHidden = true
            }else if self.role == 1 && self.comType == 2 {
                self.mBlbl.isHidden = false
                self.mblineLbl.isHidden = false
                self.mblinelblheightCons.constant = 1
                self.PhoneNumberLbl.isHidden = false
                self.countryCodeTxt.isHidden = false
            }
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.text = decodedString1
        }else  if user_sts == "4" {
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.emIDLBl.text = language == "en" ? "Gate Name" : "اسم البوابة"
            self.mBlbl.text = language == "en" ? "Gate Number" : "رقم البوابة"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.isHidden = true
        }
        
        businessName = defaults.value(forKey: "BusinessName") as? String
        BuseinessAddress = defaults.value(forKey: "BusinessAddress") as? String
        businessImage = defaults.value(forKey: "BusinessImage") as? String
        if businessImage == nil {
            BusinessProfileImageView.image = UIImage(named: "load_logo")
        }else {
            let AddPicture_url1: NSURL = NSURL(string: businessImage)!
            BusinessProfileImageView.sd_setImage(with: AddPicture_url1 as URL, placeholderImage: UIImage(named: "load_logo"))
        }
        
        if businessName == "" || businessName == nil{
            self.BusinessNameLbl.text = language == "en" ? "Business" : "اعمال"
            self.BusinessAddressLbl.text = language == "en" ? "Address" : "عنوان"
        }else{
            self.BusinessNameLbl.text = businessName
            self.BusinessAddressLbl.text = BuseinessAddress
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("MyProfileControllerChosen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("MyBusinessProfileControllerChosen"), object: nil)
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        
        
        BusinessProfileImageView.layer.cornerRadius = BusinessProfileImageView.frame.height/2
        BusinessProfileImageView.layer.masksToBounds = true
        BusinessProfileImageView.clipsToBounds = true
        setupLeftDrawer(self)
        
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
            
        }
        
        //GIFHUD.shared.show(withOverlay: true, duration:2)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
    }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "My Profile" : "ملفي"
        //  self.idnameLbl.text = language == "en" ? "Id Number" : "رقم الهوية"
        self.emIDLBl.text = language == "en" ? "Email" : "البريد الإلكتروني"
        self.mBlbl.text = language == "en" ? "Mobile Number" : "رقم الهاتف المحمول"
    }
    
    @objc func currencyItemChosen(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        user_sts = defaults.value(forKey: "User_Status") as! String
        username = defaults.value(forKey: "USer") as? String
        Name = defaults.value(forKey: "Name") as? String
        updateImage = defaults.value(forKey: "Image") as? String
        IdNumber = defaults.value(forKey: "IDNum") as? String
        Email = defaults.value(forKey: "EMAILADDRESS") as? String
        PhoneNumber = defaults.value(forKey: "PHONENumber") as? String
        countryCode = defaults.value(forKey: "CountryCode")  as? String
        let AddPicture_url: NSURL = NSURL(string: self.updateImage)!
        profileImageView.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "load_logo"))
        if user_sts == "1" {
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.text = decodedString1
        }else  if user_sts == "2" {
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.text = decodedString1
        }else  if user_sts == "3" {
            if self.role == 1 && self.comType == 1 {
                self.mBlbl.isHidden = false
                self.mblineLbl.isHidden = false
                self.mblinelblheightCons.constant = 1
                self.PhoneNumberLbl.isHidden = false
                self.countryCodeTxt.isHidden = false
            }else if self.role == 2 && self.comType == 1 {
                self.mBlbl.isHidden = true
                self.mblineLbl.isHidden = true
                self.mblinelblheightCons.constant = 0
                self.PhoneNumberLbl.isHidden = true
                self.countryCodeTxt.isHidden = true
            }else if self.role == 1 && self.comType == 2 {
                self.mBlbl.isHidden = false
                self.mblineLbl.isHidden = false
                self.mblinelblheightCons.constant = 1
                self.PhoneNumberLbl.isHidden = false
                self.countryCodeTxt.isHidden = false
            }
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.text = decodedString1
        }else  if user_sts == "4" {
            self.idnameLbl.text = language == "en" ? "Username" : "اسم المستخدم"
            self.emIDLBl.text = language == "en" ? "Gate Name" : "اسم البوابة"
            self.mBlbl.text = language ==  "en" ? "Gate Number" : "رقم البوابة"
            self.FullNameLbl.text = Name
            self.IdNumberLBL.text = username
            self.EmailIdLbl.text = Email
            self.PhoneNumberLbl.text = PhoneNumber
            self.countryCodeTxt.isHidden = true
        }
        //        self.FullNameLbl.text = Name
        //        self.IdNumberLBL.text = IdNumber
        //        self.EmailIdLbl.text = Email
        //        self.PhoneNumberLbl.text = PhoneNumber
        //        self.countryCodeTxt.text = countryCode
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        businessName = defaults.value(forKey: "BusinessName") as? String
        BuseinessAddress = defaults.value(forKey: "BusinessAddress") as? String
        businessImage = defaults.value(forKey: "BusinessImage") as? String
        let AddPicture_url: NSURL = NSURL(string: businessImage)!
        BusinessProfileImageView.sd_setImage(with: AddPicture_url as URL, placeholderImage: UIImage(named: "load_logo"))
        self.BusinessNameLbl.text = businessName
        self.BusinessAddressLbl.text = BuseinessAddress
        
    }
    
    @IBAction func sidemenuBtnAction(_ sender: Any) {
        setSideMenu()
    }
    @IBAction func updatePersonalDetail(_ sender: Any) {
        let checkString = defaults.value(forKey: "Role") as? String
        let status = defaults.value(forKey: "Check_User_For_Support_Condition") as? String
        
        if checkString == "User" && status == "1"{
           let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "CreateSupportTicketsViewController") as! CreateSupportTicketsViewController
            self.navigationController?.pushViewController(Leaderboard, animated: true)
        }else if checkString == "Gate" && status == "0" {
            let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "GateProfileDetailVC") as! GateProfileDetailVC
            self.navigationController?.pushViewController(Leaderboard, animated: true)
        }else{
            let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePersonalDetailsViewController") as! UpdatePersonalDetailsViewController
            self.navigationController?.pushViewController(Leaderboard, animated: true)
        }
    }
    @IBAction func updateBusinessProfile(_ sender: Any) {
        let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "UpdateBusinessDetailsViewController") as! UpdateBusinessDetailsViewController
        self.navigationController?.pushViewController(Leaderboard, animated: true)
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
extension MyProfileViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
