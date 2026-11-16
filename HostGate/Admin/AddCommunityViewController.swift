//
//  AddCommunityViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 19/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift

class AddCommunityViewController: UIViewController,UITextViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var gateAccountBtn: UIButton!
    @IBOutlet weak var userAccountBtn: UIButton!
    @IBOutlet weak var contactUserBtn: UIButton!
    @IBOutlet weak var userAccountLbl: UILabel!
    @IBOutlet weak var gateAccountLbl: UILabel!
    @IBOutlet weak var contactUserLbl: UILabel!
    @IBOutlet weak var view_mail: UIView!
    @IBOutlet weak var add_btn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet var sendMessageView: UIView!
    @IBOutlet weak var titlebl: UILabel!
    @IBOutlet weak var send_msg_lbl: UILabel!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var visLbl: UILabel!
    @IBOutlet weak var visitor_Btn: UIButton!
    @IBOutlet weak var send_msg_main_view: UIView!
    
    
    var btn_str = String()
    var selectArray:NSArray!
    var str = String()
    var defaults:UserDefaults!
    var str_message:NSString!
    var comName:String!
    var roleId:Int!
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    var adminuserid:Int!
    var userid:Int!
    var deviceTocken = NSString()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    
    //MARK:-
    @objc func SendMessageAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSendMessage"), object: nil)
//                self.removeAllOverlays()
            }
            else{
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSendMessage"), object: nil)
                self.send_msg_main_view.isHidden = true
                self.sendMessageView.isHidden = true
//                self.removeAllOverlays()
                
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
        defaults.set("myDefault", forKey: "myDefault")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        language = defaults.value(forKey: "Language") as? String
        comName = defaults.value(forKey: "community_name") as? String
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        userid = defaults.integer(forKey: "UserIDGet")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        messageView.layer.cornerRadius = 5
        messageView.layer.borderColor = UIColor.gray.cgColor
        messageView.layer.borderWidth = 1
        messageView.delegate = self
        messageView.delegate = self
        messageView.text = self.language == "en" ? "Message" : "رسالة"
        self.messageView.textColor = .lightGray
        roleId = defaults.integer(forKey: "RoleId")
        
        sendMessageView.layer.cornerRadius = 5
        
        self.send_msg_main_view.isHidden = true
        sendMessageView.isHidden = true
        
        userAccountBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        gateAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        contactUserBtn.setTitleColor(UIColor.lightGray, for: .normal)
        visitor_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        add_btn.isHidden = false
        sendBtn.isHidden = true
        
        userAccountLbl.isHidden = false
        gateAccountLbl.isHidden = true
        contactUserLbl.isHidden = true
        visLbl.isHidden = true
        
        btn_str = "user"
        titlebl.text = comName
        
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "UserAccountsViewController") as! UserAccountsViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        
        
        
        self.sendBtn.setTitle(language == "en" ? "SEND" : "إرسال", for: .normal)
        self.userAccountBtn.setTitle(language == "en" ? "User Accounts" : "حسابات المستخدمين", for: .normal)
        self.gateAccountBtn.setTitle(language == "en" ? "Gate Accounts" : "حسابات البوابات", for: .normal)
        self.contactUserBtn.setTitle(language == "en" ? "Contact Users" : "الاتصال بالمستخدمين" , for: .normal)
        self.visitor_Btn.setTitle(language == "en" ? "Visitors" : "الزائرين" , for: .normal)
        self.send_btn.setTitle(language == "en" ? "SEND" : "إرسال", for: .normal)
        self.send_msg_lbl.text = language == "en" ? "Send Message" : "إرسال رسالة"
        self.messageView.textAlignment = language == "en" ? .left : .right
        
        
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: userid, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set("RemovemyDefault", forKey: "myDefault")
    }
    
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view_mail.addSubview(content.view)
        content.didMove(toParent: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.send_msg_main_view.isHidden = true
        self.sendMessageView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("CheckALl"), object: nil)
    }
    
    
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
        defaults = UserDefaults.standard
        selectArray = defaults.value(forKey: "Array") as? NSArray
    }
    
   
    
       func validate1(string: String) -> Bool {
           return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
       }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addCommunityBtnActiomn(_ sender: Any) {
        
        if btn_str == "user"{
            let community_type = DataManager.getVal(Config().AppUserDefaults.value(forKey: "community_type")) as! String
            if community_type == "Residential Complex" || community_type == "مجمع سكني" {
                self.str = "res"
                let defaults = UserDefaults.standard
                defaults.set(self.str, forKey: "RES")
                defaults.synchronize()
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddEmployeeAccountViewController") as! AddEmployeeAccountViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                self.str = "cor"
                let defaults = UserDefaults.standard
                defaults.set(self.str, forKey: "COR")
                defaults.synchronize()
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddCommunityUserAccountVC") as! AddCommunityUserAccountVC
                navigationController?.pushViewController(vc, animated: true)
            }
        }else if btn_str == "gate"{
            var str1 = String()
            str1 = "Addgate"
            let defaults = UserDefaults.standard
            defaults.set(str1, forKey: "Gate")
            defaults.synchronize()
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddGateAccountsViewController") as! AddGateAccountsViewController
            navigationController?.pushViewController(vc, animated: true)
        }else {
            
        }
        
    }
    
    @IBAction func userAccountBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        
        userAccountBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        gateAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        contactUserBtn.setTitleColor(UIColor.lightGray, for: .normal)
        visitor_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn_str = "user"
        userAccountLbl.isHidden = false
        gateAccountLbl.isHidden = true
        contactUserLbl.isHidden = true
        visLbl.isHidden = true
        add_btn.isHidden = false
        sendBtn.isHidden = true
        
        defaults.set("", forKey: "CheckSelectedButton")
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "UserAccountsViewController") as! UserAccountsViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        
    }
    @IBAction func gateAccountBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        
        userAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        gateAccountBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        contactUserBtn.setTitleColor(UIColor.lightGray, for: .normal)
        visitor_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn_str = "gate"
        //  titlebl.text = "Community"
        userAccountLbl.isHidden = true
        gateAccountLbl.isHidden = false
        contactUserLbl.isHidden = true
        visLbl.isHidden = true
        add_btn.isHidden = false
        sendBtn.isHidden = true
        
        defaults.set("", forKey: "CheckSelectedButton")
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "GateAccountsViewController") as! GateAccountsViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    @IBAction func contactuserBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Array")
        self.selectArray = nil
        userAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        gateAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        contactUserBtn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        visitor_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn_str = "contact"
        //titlebl.text = "Community"
        userAccountLbl.isHidden = true
        gateAccountLbl.isHidden = true
        contactUserLbl.isHidden = false
        visLbl.isHidden = true
        
        add_btn.isHidden = true
        sendBtn.isHidden = false
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ContactUsersViewController") as! ContactUsersViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        
    }
    
    @IBAction func visitorBtnAction(_ sender: Any) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        
        defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Array")
        self.selectArray = nil
        userAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        gateAccountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        contactUserBtn.setTitleColor(UIColor.lightGray, for: .normal)
        visitor_Btn.setTitleColor(UIColor(red: 223/255, green: 167/255, blue: 93/255, alpha: 1.0), for: .normal)
        btn_str = "visitor"
        //titlebl.text = "Community"
        userAccountLbl.isHidden = true
        gateAccountLbl.isHidden = true
        contactUserLbl.isHidden = true
        visLbl.isHidden = false
        
        add_btn.isHidden = true
        sendBtn.isHidden = true
        
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "ComVisitorsViewController") as! ComVisitorsViewController
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.view_mail.frame.size.width, height: self.view_mail.frame.size.height)
        controller4.willMove(toParent: self)
        self.view_mail.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
    }
    
    
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        
        if selectArray == nil {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select atleast one check box." : "يرجى اختيار أتلست خانة الاختيار" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if selectArray.count == 0 {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select atleast one check box." : "يرجى اختيار أتلست خانة الاختيار" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else {
            self.send_msg_main_view.isHidden = false
            sendMessageView.isHidden = false
        }
        
    }
    @IBAction func cancleBtnAction(_ sender: Any) {
        
        self.send_msg_main_view.isHidden = true
        sendMessageView.isHidden = true
        
    }
    @IBAction func sendBtnAction1(_ sender: Any) {
        str_message = messageView.text as NSString?
        if str_message .isEqual(to: "Message") || str_message.isEqual(to: "رسالة"){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter message." : "من فضلك ادخل الرسالة" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else {
            let jsonArray = self.JSONStringify(value: self.selectArray as AnyObject)
            print(jsonArray)
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:15)
            Parsing().HostGateSendMessage(Language: self.language, Message: str_message as String?, PropertyArray: jsonArray, RoleId: roleId)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSendMessage"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.SendMessageAction), name: NSNotification.Name(rawValue: "HostGateSendMessage"), object: nil)
        }
        
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
        
    }
    
    
    // textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" || textView.text == "رسالة" {
            textView.text = ""
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Message"
            textView.textColor = UIColor.gray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
}


