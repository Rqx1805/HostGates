//
//  SubscriptionDetailView.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/10/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit

class SubscriptionDetailView: UIView {
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var no_of_account: UILabel!
    @IBOutlet weak var unused_account: UILabel!
    @IBOutlet weak var vati: UILabel!
    @IBOutlet weak var total_price: UILabel!
    @IBOutlet weak var vality: UILabel!
    @IBOutlet weak var activate_date: UILabel!
    @IBOutlet weak var expiry_date: UILabel!
    @IBOutlet weak var automatic: UILabel!
    @IBOutlet weak var download_btn: UIButton!
    
    
    @IBOutlet weak var noofaccuntslbl: UILabel!
    @IBOutlet weak var unusedAccountslbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var validityLbl: UILabel!
    @IBOutlet weak var activeDateLbl: UILabel!
    @IBOutlet weak var expiredatelbl: UILabel!
    @IBOutlet weak var paymentStsLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    var buttonCancelHandler : (() -> Void)?
    var buttonDownloadHandler : (() -> Void)?
    var defaults:UserDefaults!
    var noacc:Int!
    var noaccun:Int!
    var vat:Int!
    var tlprice:Int!
    var validity:Int!
    var acdata:String!
    var exdate:String!
    var subId:Int!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var autosts:Int!
    var PaymentStatus:String!
    var buttonDoneHandler : (() -> Void)?
    var buttonDownloadInvoiceHandler : (() -> Void)?
    
    @IBOutlet weak var switchBtn: UISwitch!
    @objc func HostGateUpdateSubscription(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle , message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
                
            }
            else{
                // self.buttonDoneHandler?()
                NotificationCenter.default.post(name: NSNotification.Name("UpdateSubscription"), object: nil)
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
            }
        }
    }
    
    @objc func HostGateNotUpdateSubscription(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
                
            }
            else{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                //  self.buttonDoneHandler?()
                NotificationCenter.default.post(name: NSNotification.Name("UpdateSubscription"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
            }
        }
    }
    
    
    class func intitiateFromNib() -> SubscriptionDetailView {
        let View1 = UINib.init(nibName: "SubscriptionDetailView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SubscriptionDetailView
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        language = defaults.value(forKey: "Language") as? String
        noacc = defaults.integer(forKey: "NOACC")
        noaccun = defaults.integer(forKey: "NOACCUN")
        tlprice = defaults.integer(forKey: "TLAMT")
        validity = defaults.integer(forKey: "DUA")
        acdata = defaults.value(forKey: "ACDATE") as? String
        exdate = defaults.value(forKey: "EXPDATE") as? String
        subId = defaults.integer(forKey: "SUBID")
        user_Id = defaults.integer(forKey: "UserIDGet")
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        autosts = defaults.integer(forKey: "AUTORENEW")
        PaymentStatus = defaults.value(forKey: "PAYMENTSTATUS") as? String
        
        
        if autosts == 1 {
            self.switchBtn.isOn = false
        }else {
            self.switchBtn.isOn = true
        }
        
        
        
        var str1:String!
        str1 = String(noacc)
        var str2:String!
        str2 = String(noaccun)
        var str4:String!
        str4 = String(tlprice)
        var str5:String!
        str5 = String(validity)
        
        noofaccuntslbl.text = str1
        unusedAccountslbl.text = str2
        priceLbl.text = "$" + str4
        validityLbl.text = str5
        activeDateLbl.text = acdata
        expiredatelbl.text = exdate
        statusLbl.text = PaymentStatus
        statusLbl.textColor = UIColor(red: 80/255, green: 155/255, blue: 90/255, alpha: 1.0)
       
        
//        if validity == 6 {
//            vatLbl.text = "$4"
//        }else if validity == 12 {
//            vatLbl.text = "$8"
//        }else if validity == 18
//        {
//            vatLbl.text = "$12"
//        }else {
//            vatLbl.text = "$16"
//        }
        //MARK:- language Code Start
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if self.language == "en" {
                self.download_btn.setTitle("DOWNLOAD", for: .normal)
                
            }else if self.language == "ar" {
                self.download_btn.setTitle("تحميل", for: .normal)
            }
            
            self.title_lbl.text = self.language == "en" ? "Subscription Details" : "تفاصيل الاشتراك"
            self.no_of_account.text = self.language == "en" ? "No. of accounts" : "عدد الحسابات"
            self.unused_account.text = self.language == "en" ? "No. of accounts unused" : "عدد الحسابات غير المستخدمة"
//            self.vati.text = self.language == "en" ? "Per account cost with VAT(14%)" : "لكل تكلفة حساب مع ضريبة القيمة المضافة (14 ٪)"
            self.total_price.text = self.language == "en" ? "Price" : "السعر الكلي"
            self.vality.text = self.language == "en" ? "Validity(month)": "الصلاحية (شهر)"
            self.activate_date.text = self.language == "en" ? "Date of activate" : "تاريخ التفعيل"
            self.expiry_date.text = self.language == "en" ? "Expiry date" : "تاريخ الانتهاء"
            self.automatic.text = self.language == "en" ? "Automatic renewal" : "تجديد تلقائي"
            self.paymentStsLbl.text = self.language == "en" ? "Payment status" : "حالة السداد"
            
        }
    }
    
    
    @IBAction func CanclebtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    @IBAction func downloadBtnaction(_ sender: Any) {
        buttonDownloadInvoiceHandler?()
        
    }
    @IBAction func switchBtnAction(_ sender: UISwitch) {
        if sender.isOn == true {
            Parsing().HostGateUpdateAutoRenewal(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, Subscription_id: subId, Auto_Renewal: 2)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateUpdateSubscription), name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
            
        }else {
            Parsing().HostGateUpdateAutoRenewal(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid, Subscription_id: subId, Auto_Renewal: 1)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateNotUpdateSubscription), name: NSNotification.Name(rawValue: "HostGateUpdateAutoRenewal"), object: nil)
        }
    }
    
}


