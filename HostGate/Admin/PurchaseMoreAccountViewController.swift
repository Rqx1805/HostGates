//
//  PurchaseMoreAccountViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift
import PayCardsRecognizer

class PurchaseMoreAccountViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
   
    
     var initialSetupViewController: PTFWInitialSetupViewController!
    //MARK:- IBOutlet
    @IBOutlet weak var selectNumberOfusers: UITextField!
    @IBOutlet weak var selectValiidtyTxt: UITextField!
    @IBOutlet weak var viewBillAmountTxt: UITextField!
    @IBOutlet weak var applyCoupneTxt: UITextField!
    @IBOutlet weak var viewdetailBtn: UIButton!
    @IBOutlet weak var switcBtn: UISwitch!
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var automatic_subcriptionlbl: UILabel!
    @IBOutlet weak var buy_btn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var countxtxLbl: UILabel!
    @IBOutlet weak var counpentopcons: NSLayoutConstraint!
    
    @IBOutlet weak var userview: UIView!
    @IBOutlet weak var discontview: UIView!
    var str_selectNo:NSString!
    var str_validity:NSString!
    var nsstingbnillAmount:NSString!
    var str_discountcount:NSString!
    var autorenew:Int!
    var defaults: UserDefaults!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var vaili:Int!
    var strty:String!
    var ValidityView = [String]()
    var ValidityPickerView: UIPickerView = UIPickerView()
    var price:Int!
    var vld:Int!
    var iscall:Bool!
    var MoonthView = [String]()
    var MoonthView1 = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var monthpickerview:UIPickerView = UIPickerView()
    var years: [Int]!
    var YearPickerview:UIPickerView = UIPickerView()
    var Month:String!
    var Year:String!
    var discout:Int!
    var counpenId:Int!
    var newAmt:Int!
    var random1:String!
    var random2:String!
    var random3:String!
    
    var fullname:String!
    var email:String!
    var Address:String!
    var Mobile:String!
    var deviceTocken = NSString()
    
    var newAmt1:Int!
    var isclick: Bool = false
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            YearPickerview.selectRow(years.firstIndex(of: year)!, inComponent: 1, animated: true)
        }
    }
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var role:Int!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    
    @objc func HostGateaddSubscription(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("AddSubscription"), object: nil)
                self.navigationController?.popViewController(animated: true)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                
            }
        }
    }
    
    @objc func HostGateGetPrice(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                print("response: \(response)")
                self.price = response.value(forKey: "price") as? Int
//                self.removeAllOverlays()
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
//                  self.removeAllOverlays()
                  self.defaults.set("0", forKey: "Check_User_For_Support_Condition")
                GIFHUD.shared.dismiss()
              }
              else if status == 1{
                  NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
                  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                  self.defaults.set("1", forKey: "Check_User_For_Support_Condition")
//                  self.removeAllOverlays()
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
    
    
    @objc func HostGateApplyCoupenAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateApplyCoupen"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
              //  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                var response = NSDictionary()
                response = (notification.userInfo?["data"] as? NSDictionary)!
                self.discout = response.value(forKey: "discount") as? Int
                self.counpenId = response.value(forKey: "coupon_id") as? Int
                
                var strnew:String!
                strnew = self.viewBillAmountTxt.text
                let str1 = strnew.replacingOccurrences(of: "$", with: "")
               
                self.newAmt = Int(str1)
                self.newAmt1 = Int(str1)
                
                var NewAmount:Int!
                NewAmount = self.newAmt!*self.discout/100
                
                
                self.newAmt -= NewAmount
                
                self.viewBillAmountTxt.text = "$" + String(self.newAmt)
                
                self.selectNumberOfusers.isUserInteractionEnabled = false
                self.applyCoupneTxt.isUserInteractionEnabled = false
                
               self.userview.layer.borderColor = UIColor.gray.cgColor
               self.discontview.layer.borderColor = UIColor.gray.cgColor
                
                self.userview.layer.borderWidth = 4
                self.discontview.layer.borderWidth = 4
                
                
                if self.language == "en" {
                    self.applyBtn.setTitle("REMOVE", for: .normal)
                    
                }else if self.language == "ar" {
                    self.applyBtn.setTitle("إزالة", for: .normal)
                }
                self.countxtxLbl.isHidden = false
                self.counpentopcons.constant = 15
                
                var news:String!
                news = String(self.discout)
                
                self.countxtxLbl.text = "You got " + news + " " + "% discount"
 
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateApplyCoupen"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    
    @objc func HostGatePaymentAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                 SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
            }
            else{
                
                  SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: nil)
                 NotificationCenter.default.post(name: NSNotification.Name("MoreAccountPurcahse"), object: nil)
                self.navigationController?.popViewController(animated: true)
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
            }
            else{
                var response = NSMutableDictionary()
                response = (notification.userInfo?["data"] as? NSMutableDictionary)!
                print("response: \(response)")
                
                
                self.fullname = response.value(forKey: "full_name") as? String
                self.Address = response.value(forKey: "address") as? String
                self.email = response.value(forKey: "email") as? String
                self.Mobile = response.value(forKey: "phone") as? String
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
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        adminuserid = defaults.integer(forKey: "AdminUserId")
        role = defaults.integer(forKey: "ROLE")
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        ValidityPickerView.delegate = self
        ValidityPickerView.dataSource = self
        monthpickerview.delegate = self
        monthpickerview.dataSource = self
        
        applyBtn.isUserInteractionEnabled = false
        applyCoupneTxt.delegate = self
        
        countxtxLbl.isHidden = true
        counpentopcons.constant = 0
        
        self.random1 = ""
        
        self.random2 = ""
        
        self.random3 = ""
        
        strty = "Fisrt"
        YearPickerview.delegate = self
        YearPickerview.dataSource = self
        
        commonSetup()
        selectValiidtyTxt.inputView = ValidityPickerView
        selectValiidtyTxt.delegate = self
        selectNumberOfusers.delegate = self
        applyCoupneTxt.delegate = self
        autorenew = 1
        iscall = true
        //        if selectNumberOfusers.text == "" {
        //
        //        }else {
        selectNumberOfusers.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingDidBegin)
        //
        //        }
        
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().GetPriceData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetPrice), name: NSNotification.Name(rawValue: "GetPriceData"), object: nil)
        
        //MARK:- language Code Start
        let one = language == "en" ? "6 Months" : "6 اشهر"
        let two = language == "en" ? "12 Months" : "12 شهر"
        let three = language == "en" ? "18 Months" : "18 شهرا"
        let fourth = language == "en" ? "24 Months" : "24 شهرا"
        
        ValidityView = [one, two, three, fourth]
        
        let jan = language == "en" ? "January" : "كانون الثاني"
        let feb = language == "en" ? "February" : "شهر فبراير"
        let march = language == "en" ? "March" : "مارس"
        let april = language == "en" ? "April" : "أبريل"
        let may = language == "en" ? "May" : "قد"
        let june = language == "en" ? "June" : "يونيو"
        let july = language == "en" ? "July" : "يوليو"
        let aug = language == "en" ? "August" : "أغسطس"
        let sept = language == "en" ? "September" : "سبتمبر"
        let oct = language == "en" ? "October" : "اكتوبر"
        let nov = language == "en" ? "November" : "شهر نوفمبر"
        let dec = language == "en" ? "December" : "ديسمبر"
        
        MoonthView = [jan, feb, march, april, may, june, july, aug, sept, oct, nov, dec]
        
        if language == "en" {
            self.viewdetailBtn.setTitle("View Amount Details", for: .normal)
            self.buy_btn.setTitle("BUY", for: .normal)
            self.applyBtn.setTitle("APPLY", for: .normal)
            
            
        }else if language == "ar" {
            self.viewdetailBtn.setTitle("عرض تفاصيل المبلغ", for: .normal)
            self.buy_btn.setTitle("يشترى", for: .normal)
            self.applyBtn.setTitle("تطبيق", for: .normal)
        }
        
        if language == nil {
            
        }else {
            DGLocalization.sharedInstance.Delegate = self;
            decorate()
        }
        
        //GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateCheckAccountStatus(Language: language, UserID: user_Id, RoleID: roleId, DeviceID: deviceId, Role: role, AdminUserID: adminuserid, device_id: deviceTocken)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateAccountStatusAction), name: NSNotification.Name(rawValue: "HostGateCheckAccountStatusNotification"), object: nil)
        
        
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateUserDetail(Language:language, user_Id: user_Id, RoleId: roleId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetUserDetailAction), name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
    }
    
    
    //MARK:- language Function
    func decorate() {
        self.titlelbl.text = language == "en" ? "Purchase More User Account" : "شراء المزيد من حساب المستخدم"
        self.selectNumberOfusers.placeholder = language == "en" ? "Number of Users" : "عدد المستخدمين"
        self.selectValiidtyTxt.placeholder = language == "en" ? "Select Validity" : "حدد الصلاحية"
        self.viewBillAmountTxt.placeholder = language == "en" ? "Payable Amount" : "المبلغ المستحق"
        self.applyCoupneTxt.placeholder = language == "en" ? "Discount Coupon" : "كوبون الخصم"
        self.automatic_subcriptionlbl.text = language == "en" ? "Automatic subscription renewal" : "تجديد الاشتراك التلقائي"
        
        if language .isEqual("en") || language .isEqual(""){
            self.selectNumberOfusers.textAlignment = .left
            self.selectValiidtyTxt.textAlignment = .left
            self.viewBillAmountTxt.textAlignment = .left
            self.applyCoupneTxt.textAlignment = .left
        }else if language .isEqual("ar") {
            self.selectNumberOfusers.textAlignment = .right
            self.selectValiidtyTxt.textAlignment = .right
            self.viewBillAmountTxt.textAlignment = .right
            self.applyCoupneTxt.textAlignment = .right
        }
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...11 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectNumberOfusers {
            vld = defaults.integer(forKey: "Validity1")
            var strnew:String!
            strnew = self.selectNumberOfusers.text
            let newI = Int(strnew)
            if newI == nil {
                
            }else {
                var tl = Int()
                tl = vld*newI!
                
                let str1 = String(tl)
                self.viewBillAmountTxt.text = "$" + str1
                
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == selectNumberOfusers {
            applyBtn.isUserInteractionEnabled = false
            if selectNumberOfusers.text == ""{
                viewBillAmountTxt.text = ""
                selectValiidtyTxt.text = ""
            }else {
                if selectNumberOfusers.text == "" {
                    
                }else {
                    if selectValiidtyTxt.text == "" {
                        
                    }else {
                        vld = defaults.integer(forKey: "Validity1")
                        var strnew:String!
                        strnew = self.selectNumberOfusers.text
                        let newI = Int(strnew)
                        if newI == nil {
                            
                        }else {
                            var tl = Int()
                            tl = vld*newI!
                            
                            let str1 = String(tl)
                            self.viewBillAmountTxt.text = "$" + str1
                        }
                    }
                }
            }
        }else if textField == applyCoupneTxt {
            applyBtn.isUserInteractionEnabled = true
            
        }
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if iscall == false {
            selectNumberOfusers.text = ""
            selectValiidtyTxt.text = ""
            viewBillAmountTxt.text = ""
            // iscall = true
            
        }else {
            iscall = false
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if selectValiidtyTxt.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == selectNumberOfusers {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 3
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        } else if textField == applyCoupneTxt {
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
    
    @IBAction func applyBtnAction(_ sender: Any) {
        if (!isclick){
            var strnew:String!
            strnew = selectNumberOfusers.text
//            showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateApplyCoupen(Language: language, UserId: user_Id, UserNumber: Int(strnew), Coupen: applyCoupneTxt.text)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateApplyCoupen"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateApplyCoupenAction), name: NSNotification.Name(rawValue: "HostGateApplyCoupen"), object: nil)
            isclick=true
           
        }
        else
        {
            
            
            
            if language == "en" {
            self.applyBtn.setTitle("APPLY", for: .normal)
                
            }else if language == "ar" {
                self.applyBtn.setTitle("تطبيق", for: .normal)
            }
            
            var str1:String!
            str1 = selectNumberOfusers.text
            var amnt:Int!
            amnt = Int(str1)
            
            var newamnt:Int!
            newamnt = amnt*vaili
            self.viewBillAmountTxt.text = "$" + String(newamnt)
            
            discout = nil
            countxtxLbl.isHidden = true
            counpentopcons.constant = 0
            applyBtn.isUserInteractionEnabled = false
            self.applyCoupneTxt.text = ""
            self.selectNumberOfusers.isUserInteractionEnabled = true
            self.applyCoupneTxt.isUserInteractionEnabled = true
            self.userview.layer.borderColor = UIColor.clear.cgColor
            self.discontview.layer.borderColor = UIColor.clear.cgColor
            isclick=false
            
        }
        
      
    }
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return ValidityView.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ValidityView[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if selectNumberOfusers.text == "" {
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter number of users." : "الرجاء إدخال عدد المستخدمين" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else {
            if row == 0 {
                selectValiidtyTxt.text = ValidityView[row]
                 strty = "Fisrt"
                vaili = 4
                var strnew:String!
                strnew = self.selectNumberOfusers.text
                let newI = Int(strnew)
                if newI == nil {
                    
                }else {
                    var tl:Int!
                    tl = vaili*newI!
                    newAmt1 = tl
                    if discout == nil {
                        
                    }else {
                        var NewAmount:Int!
                        NewAmount = tl!*self.discout/100
                        tl -= NewAmount
                    }
                   
                    
                    
                    let str1 = String(tl)
                    self.viewBillAmountTxt.text = "$" + str1
                }
                let defaults = UserDefaults.standard
                defaults.set(vaili, forKey: "Validity1")
                defaults.synchronize()
            }else if row == 1 {
                 strty = "Fisrt"
                vaili = 8
                var strnew:String!
                strnew = self.selectNumberOfusers.text
                let newI = Int(strnew)
                if newI == nil{
                    
                }else {
                    var tl:Int!
                    tl = vaili*newI!
                    newAmt1 = tl
                    if discout == nil {
                        
                    }else {
                        var NewAmount:Int!
                        NewAmount = tl!*self.discout/100
                        tl -= NewAmount
                    }
                    
                    let str1 = String(tl)
                    self.viewBillAmountTxt.text = "$" + str1
                }
                let defaults = UserDefaults.standard
                defaults.set(vaili, forKey: "Validity1")
                defaults.synchronize()
                
                selectValiidtyTxt.text = ValidityView[row]
            }else if row == 2 {
                 strty = "Fisrt"
                vaili = 12
                var strnew:String!
                strnew = self.selectNumberOfusers.text
                let newI = Int(strnew)
                if newI == nil {
                    
                }else {
                    var tl:Int!
                    tl = vaili*newI!
                    newAmt1 = tl
                    
                    if discout == nil {
                        
                    }else {
                        var NewAmount:Int!
                        NewAmount = tl!*self.discout/100
                        tl -= NewAmount
                    }
                    
                    let str1 = String(tl)
                    self.viewBillAmountTxt.text = "$" + str1
                }
                let defaults = UserDefaults.standard
                defaults.set(vaili, forKey: "Validity1")
                defaults.synchronize()
                selectValiidtyTxt.text = ValidityView[row]
            }else {
                 strty = "Fisrt"
                vaili = 16
                var strnew:String!
                strnew = self.selectNumberOfusers.text
                let newI = Int(strnew)
                if newI == nil {
                    
                }else {
                    var tl:Int!
                    tl = vaili*newI!
                     newAmt1 = tl
                    if discout == nil {
                        
                    }else {
                        var NewAmount:Int!
                        NewAmount = tl!*self.discout/100
                        tl -= NewAmount
                    }
                    
                    let str1 = String(tl)
                    self.viewBillAmountTxt.text = "$" + str1
                }
                let defaults = UserDefaults.standard
                defaults.set(vaili, forKey: "Validity1")
                defaults.synchronize()
                selectValiidtyTxt.text = ValidityView[row]
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func backBtnaction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        str_selectNo = selectNumberOfusers.text as NSString?
        str_validity = selectValiidtyTxt.text as NSString?
        nsstingbnillAmount = viewBillAmountTxt.text as NSString?
        
        if str_selectNo .isEqual(to: ""){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter number of users." : "الرجاء إدخال عدد المستخدمين" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_selectNo .isEqual(to: "0"){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid number of users." : "الرجاء إدخال عدد صحيح من المستخدمين" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_selectNo .isEqual(to: "00"){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid number of users." : "الرجاء إدخال عدد صحيح من المستخدمين" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else  if str_selectNo .isEqual(to: "000"){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter valid number of users." : "الرجاء إدخال عدد صحيح من المستخدمين" , buttonTitle: language == "en" ? "OK" : "حسنا")
        } else if str_validity .isEqual(to: ""){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please select validity." : "يرجى اختيار الصلاحية" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }else if nsstingbnillAmount .isEqual(to: ""){
            SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message: language == "en" ? "Please enter total amount." : "الرجاء إدخال المبلغ الإجمالي" , buttonTitle: language == "en" ? "OK" : "حسنا")
        }
        else{
            
            let parsed = str_validity.replacingOccurrences(of: " Months", with: "")
             let duration = Int(parsed)
             debugPrint(duration as Any)
             var strnew:String!
             strnew = self.selectNumberOfusers.text
             let newI = Int(strnew)
             var tl = Int()
             debugPrint(tl)
             if newI == 0 {
                 
             }else {
                 tl = vaili*newI!
             }
             
             var stramount:String!
             stramount = viewBillAmountTxt.text
             var tlamount:String!
             tlamount =  stramount.replacingOccurrences(of: "$", with: "")
            
             let parsed1 = nsstingbnillAmount.replacingOccurrences(of: "$", with: "")
             let duration1 = Int(parsed1)
             debugPrint(duration1 as Any)
            
            let letters : NSString = "0123456789"
            let len = UInt32(letters.length)
            
            for _ in 0 ..< 3 {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                self.random1 += NSString(characters: &nextChar, length: 1) as String
            }
            
            for _ in 0 ..< 5 {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                self.random2 += NSString(characters: &nextChar, length: 1) as String
            }
            
            for _ in 0 ..< 7 {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                self.random3 += NSString(characters: &nextChar, length: 1) as String
            }
            
            var orderstr:String!
            orderstr =  "ORDER" + random1 + random2 + random3
            
            
            
            
            let bundle = Bundle(url: Bundle.main.url(forResource: "Resources", withExtension: "bundle")!)
            self.initialSetupViewController = PTFWInitialSetupViewController.init(bundle: bundle, andWithViewFrame: self.view.frame, andWithAmount: Float(tlamount)!, andWithCustomerTitle: self.fullname, andWithCurrencyCode: "USD", andWithTaxAmount: 0.0, andWithSDKLanguage: "en", andWithShippingAddress: self.Address, andWithShippingCity: self.Address, andWithShippingCountry: "EGY", andWithShippingState: self.Address, andWithShippingZIPCode: "302017", andWithBillingAddress: self.Address, andWithBillingCity: "Manama", andWithBillingCountry: "EGY", andWithBillingState: self.Address, andWithBillingZIPCode: "302017", andWithOrderID: orderstr, andWithPhoneNumber: self.Mobile, andWithCustomerEmail: self.email, andIsTokenization: false, andIsPreAuth: false, andWithMerchantEmail: "h.adel@turnx.co", andWithMerchantSecretKey: "Zns8LVkGFCxdFEALTmkrg722CV0VxMAx92FVY0CDC9RiOs3HOo84wb79674ETEc2HSYFSAiuJaMyCQgqfpvLACVHJZlDEyFlqD1i", andWithAssigneeCode: "SDK", andWithThemeColor: UIColor(displayP3Red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0), andIsThemeColorLight: false)
//                   self.initialSetupViewController = PTFWInitialSetupViewController.init(
//                       bundle: bundle,
//                       andWithViewFrame: self.view.frame,
//                       andWithAmount: Float(tlamount)!,
//                       andWithCustomerTitle: self.fullname,
//                       andWithCurrencyCode: "USD",
//                       andWithTaxAmount: 0.0,
//                       andWithSDKLanguage: "en",
//                       andWithShippingAddress: self.Address,
//                       andWithShippingCity: self.Address,
//                       andWithShippingCountry: "EGY",
//                       andWithShippingState: self.Address,
//                       andWithShippingZIPCode: "302017",
//                       andWithBillingAddress:self.Address,
//                       andWithBillingCity: "Manama",
//                       andWithBillingCountry: "EGY",
//                       andWithBillingState: self.Address,
//                       andWithBillingZIPCode: "302017",
//                       andWithOrderID: orderstr,
//                       andWithPhoneNumber: self.Mobile,
//                       andWithCustomerEmail: self.email,
//                       andIsTokenization:false,
//                       andIsPreAuth: false,
//                       andWithMerchantEmail: "h.adel@turnx.co",
//                       andWithMerchantSecretKey: "Zns8LVkGFCxdFEALTmkrg722CV0VxMAx92FVY0CDC9RiOs3HOo84wb79674ETEc2HSYFSAiuJaMyCQgqfpvLACVHJZlDEyFlqD1i",
//                       andWithAssigneeCode: "SDK",
//                       andWithThemeColor:UIColor(displayP3Red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0),
//                       andIsThemeColorLight: false)
//
                   
                   self.initialSetupViewController.didReceiveBackButtonCallback = {
                       print("Ashish1")
                   }
                   
                   self.initialSetupViewController.didStartPreparePaymentPage = {
                       // Start Prepare Payment Page
                       // Show loading indicator
                       print("Ashish2")
                   }
            
           
                   self.initialSetupViewController.didFinishPreparePaymentPage = {
                       // Finish Prepare Payment Page
                       // Stop loading indicator
                       print("Ashish3")
                   }
                   
                   self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
                       print("Response Code: \(responseCode)")
                       print("Response Result: \(result)")
                       
                       // In Case you are using tokenization
                       print("Tokenization Cutomer Email: \(tokenizedCustomerEmail)");
                       print("Tokenization Customer Password: \(tokenizedCustomerPassword)");
                       print("TOkenization Token: \(token)");
                       print("Transaction ID: \(transactionID)");
                    
                    if responseCode == 100 {
                        var coupen:Int!
                        if self.counpenId == nil {
                            coupen = 0
                        }else {
                            coupen = self.counpenId
                        }
                        
                        var trid: Int!
                        trid = Int(transactionID)
//                        self.showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        Parsing().HostGateAddSubscriptionPlan(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid, Usernumber: self.str_selectNo as String?, Duration: duration, TotalAmount: Float(tlamount)!, AutoRenewel: self.autorenew, CounpenId: coupen, OrderID: orderstr, transationid: trid, PtToken: token, ptcusemail: tokenizedCustomerEmail, ptcutomerPass: tokenizedCustomerPassword)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGatePaymentAction), name: NSNotification.Name(rawValue: "HostGateAddSubscriptionPlan"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:self.language == "en" ? "Something went wrong. Please try again." : "هناك خطأ ما. حاول مرة اخرى." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                    }
                    
                    
                   }
                   self.view.addSubview(initialSetupViewController.view)
                   self.addChild(initialSetupViewController)
                   
                   initialSetupViewController.didMove(toParent: self)
                    
            
//            let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "paymentWebViewController") as! paymentWebViewController
//            self.navigationController?.pushViewController(Leaderboard, animated: true)
            
        }
        
    }
    
   
    
    @IBAction func viewDetailbtnAction(_ sender: Any) {
        if selectNumberOfusers.text == "" || selectValiidtyTxt.text == "" || viewBillAmountTxt.text == "" {
            let defaults = UserDefaults.standard
            defaults.set(0, forKey: "NOUsers")
            defaults.set(0, forKey: "Price")
            defaults.set(0, forKey: "Validity")
            defaults.setValue(0, forKey: "DisCount")
            defaults.set(0, forKey: "SubPrice")
            defaults.synchronize()
        }else if applyCoupneTxt.text == "" {
            var users:String!
            users = selectNumberOfusers.text
            let nousers = Int(users)
            var NewAmount:Int!
            //
            var tlAmnt:Int!
            var tlAmount:String!
            tlAmount = viewBillAmountTxt.text
            let str1 = tlAmount.replacingOccurrences(of: "$", with: "")
            newAmt = Int(str1)
            let defaults = UserDefaults.standard
            defaults.set(nousers, forKey: "NOUsers")
            defaults.set(newAmt, forKey: "SubPrice")
            defaults.setValue(newAmt, forKey: "Price")
            defaults.set(vaili, forKey: "Validity")
            defaults.setValue(NewAmount, forKey: "DisCount")
            defaults.synchronize()
        }
        else {
            var users:String!
            users = selectNumberOfusers.text
            let nousers = Int(users)
            var NewAmount:Int!
//
            var tlAmnt:Int!
//            tlAmnt = Int(str1)
            
            if discout == nil {
                var tlAmount:String!
                tlAmount = viewBillAmountTxt.text
                let str1 = tlAmount.replacingOccurrences(of: "$", with: "")
                newAmt = Int(str1)
                let defaults = UserDefaults.standard
                defaults.set(nousers, forKey: "NOUsers")
                defaults.set(newAmt, forKey: "SubPrice")
                defaults.setValue(newAmt, forKey: "Price")
                defaults.set(vaili, forKey: "Validity")
                defaults.setValue(NewAmount, forKey: "DisCount")
                defaults.synchronize()
            }else {
                
                if strty == "Fisrt" {
                    NewAmount = newAmt1!*self.discout/100
                    newAmt1  -= NewAmount
                    let defaults = UserDefaults.standard
                    defaults.set(nousers, forKey: "NOUsers")
                    defaults.set(newAmt1, forKey: "SubPrice")
                    defaults.setValue(newAmt1, forKey: "Price")
                    defaults.set(vaili, forKey: "Validity")
                    defaults.setValue(NewAmount, forKey: "DisCount")
                    defaults.setValue(strty, forKey: "FIR")
                    defaults.synchronize()
                    strty = "Second"
                }else {
                    
                }
                
               
            }
            
           
            
          
        }
        
        
        
        let nextview = PaymentDetailView.intitiateFromNib()
        let model = BackModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        model.show(view: nextview)
        
        
    }
    @IBAction func switchBtnAction(_ sender: UISwitch) {
        if sender.isOn == true {
            autorenew = 2
        }else {
            autorenew = 1
        }
        
    }
    
}


//MARK:-DGLoclalization Delegate
extension PurchaseMoreAccountViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
