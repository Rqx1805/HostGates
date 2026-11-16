//
//  CreateSupportTicketsViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 15/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class CreateSupportTicketsViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var ticketnumberTxt: UITextField!
    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var reasonTxtview: UITextView!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var ticket_no_lbl: UILabel!
    
    //MARK:- Variables
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    
    var user_sts = String()
    var defaults: UserDefaults!
    var role:Int!
    var randomString:String!
    var length: Int!
    var str_ticketnumber:NSString!
    var str_subject:NSString!
    var str_reason:NSString!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var communityID:Int!
    var deviceTocken = NSString()
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var comType:Int!
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @objc func HostGateCreateTicket(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCreateSupportTickets"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCreateSupportTickets"), object: nil)
                self.subjectTxt.text = ""
                self.reasonTxtview.text = self.language == "en" ? "Reason" : "السبب"
                let letters : NSString = "0123456789"
                let len = UInt32(letters.length)
                
                self.randomString = ""
                
                for _ in 0 ..< 5 {
                    let rand = arc4random_uniform(len)
                    var nextChar = letters.character(at: Int(rand))
                    self.randomString += NSString(characters: &nextChar, length: 1) as String
                }
                self.ticketnumberTxt.text = "#" + self.randomString
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
        
        //MARK:- language Code Start
        language = defaults.value(forKey: "Language") as? String
        
        user_sts = defaults.value(forKey: "User_Status") as! String
        self.role = defaults.integer(forKey: "ROLE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        communityID = defaults.integer(forKey: "COMNEWID")
        self.comType = defaults.integer(forKey: "COMTYPE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        reasonTxtview.layer.cornerRadius = 8
        reasonTxtview.delegate = self
        subjectTxt.delegate = self
        reasonTxtview.text = self.language == "en" ? "Reason" : "السبب"
        reasonTxtview.textColor = .lightGray
        if language .isEqual("en") || language .isEqual(""){
            self.reasonTxtview.textAlignment = .left
        }else if language .isEqual("ar") {
            self.reasonTxtview.textAlignment = .right
        }
        setupLeftDrawer(self)
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        randomString = ""
        
        for _ in 0 ..< 5 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        ticketnumberTxt.text = "#" + randomString
        
        
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
            
        }
        
       // GIFHUD.shared.show(withOverlay: true, duration:1)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
    }
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Support Ticket" : "تذكرة الدعم"
        self.ticket_no_lbl.text = language == "en" ? "Ticket Number" : "رقم التذكرة";
        self.ticketnumberTxt.placeholder = language == "en" ? "Ticket Number" : "رقم التذكرة"
        self.subjectTxt.placeholder = language == "en" ? "Subject" : "موضوع"
        if language == "en" {
            self.submit_btn.setTitle("SEND", for: .normal)
        }else if language == "ar" {
            self.submit_btn.setTitle("إرسال", for: .normal)
        }
        if language .isEqual("en") || language .isEqual(""){
            self.ticketnumberTxt.textAlignment = .left
            self.subjectTxt.textAlignment = .left
            self.reasonTxtview.textAlignment = .left
        }else if language .isEqual("ar") {
            self.ticketnumberTxt.textAlignment = .right
            self.subjectTxt.textAlignment = .right
            self.reasonTxtview.textAlignment = .right
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == subjectTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 50
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }
        else {
            return true
        }
    }
    
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Reason" || textView.text == "السبب" {
            textView.text = ""
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        guard range.location == 0 else {
            return true
        }
        let currentString: NSString = (textView.text ?? "Reason") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        return validate1(string: newString)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = language == "en" ? "Reason" : "السبب"
            if language .isEqual("en") || language .isEqual(""){
                textView.textAlignment = .left
            }else if language .isEqual("ar") {
                textView.textAlignment = .right
            }
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    func validate1(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
        
        str_subject = subjectTxt.text as NSString?
        str_reason = reasonTxtview.text as NSString?
        
        if str_subject .isEqual(to: ""){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter subject." : "الرجاء إدخال الموضوع" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if str_subject.length < 3 || str_subject.length > 50 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Subject should be 3 to 50." : "يجب أن يكون الموضوع من 3 إلى 50" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else if str_reason .isEqual(to: "Reason") || str_reason.isEqual(to: "السبب"){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter reason." : "الرجاء إدخال السبب" , buttonTitle: language == "en" ? "OK" : "حسنا")
        } else if str_reason.length > 255{
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Reason should be 255 characters." : "يجب أن يكون السبب 255 حرفًا" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else {
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:30)
            Parsing().HostGateCreateSupportTickets(Language: language, UserId: user_Id, RoleId: roleId, TicketsNumber: randomString, Subject: str_subject as String?, Reason: str_reason as String?, Role: role, AdminId: adminuserid, community: communityID)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCreateSupportTickets"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateCreateTicket), name: NSNotification.Name(rawValue: "HostGateCreateSupportTickets"), object: nil)
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
}

//MARK:-DGLoclalization Delegate
extension CreateSupportTicketsViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
