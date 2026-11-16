//
//  SubscriptionViewController.swift
//  HostGate
//
//  Created by tarun-mac-6 on 22/07/19.
//  Copyright © 2019 tarun-mac-6. All rights reserved.
//

import UIKit
import AdSupport
import GiFHUD_Swift
import PayCardsRecognizer
class SubscriptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var sucriptionTableview: UITableView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var puchase_btn: UIButton!
    
     var initialSetupViewController: PTFWInitialSetupViewController!
    var leftDrawerTransition:DrawerTransition!
    var left = LeftMenuViewController()
    //MARK: - GENERAL
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_sts = String()
    var defaults: UserDefaults!
    var nav: UIStoryboard!
    var navController : UINavigationController?
    var window:UIWindow!
    var role:Int!
    var roleId:Int!
    var adminuserid:Int!
    var user_Id:Int!
    var response:NSMutableArray!
    var comType:Int!
    var referseControl = UIRefreshControl()
    var downloadFile:String!
    let identifierManager = ASIdentifierManager.shared()
    var deviceId = String()
    
    //MARK:- Create Variable for language localizations
    var language:String!
    var dGlocale = DGLocalization()
    
    
    var random1:String!
    var random2:String!
    var random3:String!
    
    var fullname:String!
    var email:String!
    var Address:String!
    var Mobile:String!
    var deviceTocken = NSString()
    var ChangeSts:Int!
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
                let checkString = self.defaults.value(forKey: "Role") as? String
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                if checkString == "Admin"{
                    let Leaderboard = self.storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") as! AdminLoginViewController
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
    
    @objc func HostGateSubscriptionList(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                self.dataNotFound()
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
                self.response.removeAllObjects()
                self.sucriptionTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                self.response = (notification.userInfo?["data"] as? NSMutableArray)!
                self.ChangeSts = (notification.userInfo?["user_activity_changes"] as? Int)!
                if self.ChangeSts == 1 {
                    self.puchase_btn.isHidden = false
                }else {
                    self.puchase_btn.isHidden = true
                }
                print("response: \(String(describing: self.response))")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
                self.sucriptionTableview.reloadData()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    
    @objc func HostGateDownloadInvoice(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDownloadInvoice"), object: nil)
                
            }
            else{
                
                self.downloadFile = notification.userInfo?["data"] as? String
                
                //                let yourURL = NSURL(string: self.downloadFile)
                //                let urlRequest = NSURLRequest(url: yourURL! as URL)
                //                let theData1 = try? NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: nil)
                //                var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
                //                docURL = docURL?.appendingPathComponent( "Invoice.pdf") as NSURL?
                //                try? theData1?.write(to: docURL! as URL)
                
                let urlString = self.downloadFile
                let url = URL(string: urlString!)
                let fileName = String((url!.lastPathComponent)) as NSString
                // Create destination URL
                let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
                let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
                //Create URL to the source file you want to download
                let fileURL = URL(string: urlString!)
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession(configuration: sessionConfig)
                let request = URLRequest(url:fileURL!)
                let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                    if let tempLocalUrl = tempLocalUrl, error == nil {
                        // Success
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                            print("Successfully downloaded. Status code: \(statusCode)")
                        }
                        do {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                            do {
                                //Show UIActivityViewController to save the downloaded file
                                let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                                for indexx in 0..<contents.count {
                                    if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                        let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                            self.present(activityViewController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                            catch (let err) {
                                print("error: \(err)")
                            }
                        } catch (let writeError) {
                            print("Error creating a file \(destinationFileUrl) : \(writeError)")
                        }
                    } else {
                        print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                    }
                }
                task.resume()
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
                
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDownloadInvoice"), object: nil)
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
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    
    @objc func HostGateVerifyPaymentAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVerifyRenewPayment"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                
                Parsing().HostGateSubscriptionList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVerifyRenewPayment"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    @objc func HostGateRenewPaymentAction(_ notification: Notification) {
        
        let status = (notification.userInfo?["status"] as? Int)!
        let str_message = (notification.userInfo?["message"] as? String)!
        debugPrint(str_message)
        
        DispatchQueue.main.async() {
            if status == 0{
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateRenewSubstription"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
            else{
                
                SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:str_message , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                
                Parsing().HostGateSubscriptionList(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserid: self.adminuserid)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateRenewSubstription"), object: nil)
//                self.removeAllOverlays()
                GIFHUD.shared.dismiss()
                GIFHUD.shared.dismiss()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIFHUD.shared.setGif(named: "loader.gif")
        defaults = UserDefaults.standard
        user_sts = defaults.value(forKey: "User_Status") as! String
        role = defaults.integer(forKey: "ROLE")
        user_Id = defaults.integer(forKey: "UserIDGet")
        language = defaults.value(forKey: "Language") as? String
        roleId = defaults.integer(forKey: "RoleId")
        adminuserid = defaults.integer(forKey: "AdminUserId")
        self.comType = defaults.integer(forKey: "COMTYPE")
        deviceTocken = defaults.value(forKey: "Devicetoken") as! NSString
        if identifierManager.isAdvertisingTrackingEnabled {
            deviceId = identifierManager.advertisingIdentifier.uuidString
        }
        setupLeftDrawer(self)
        
        referseControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        sucriptionTableview.addSubview(referseControl)
        response = NSMutableArray()
        
        self.random1 = ""
        
        self.random2 = ""
        
        self.random3 = ""
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen(_:)), name: NSNotification.Name("AddSubscription"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen1(_:)), name: NSNotification.Name("UpdateSubscription"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.currencyItemChosen2(_:)), name: NSNotification.Name("MoreAccountPurcahse"), object: nil)
        
        
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:15)
        Parsing().HostGateSubscriptionList(Language: language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        
        
        Parsing().HostGateUserDetail(Language:language, user_Id: user_Id, RoleId: roleId)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateGetUserDetailAction), name: NSNotification.Name(rawValue: "HostgateUserDetail"), object: nil)
        
        
        
        //MARK:- language Code Start
        
        
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
        self.titlelbl.text = language == "en" ? "Subscription" : "الاشتراكات"
        if language == "en" {
            self.puchase_btn.setTitle("Purchase", for: .normal)
        }else if language == "ar" {
            self.puchase_btn.setTitle("عملية الشراء", for: .normal)
        }
        
    }
    
    
    @objc func refresh(sender:AnyObject) {
        sucriptionTableview.reloadData()
        referseControl.endRefreshing()
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubscriptionList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        // Code to refresh table view
    }
    @objc func currencyItemChosen(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubscriptionList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        
        
    }
    
    @objc func currencyItemChosen1(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubscriptionList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        
    }
    
    @objc func currencyItemChosen2(_ pNotification: Notification?) {
//        showWaitOverlay()
        GIFHUD.shared.show(withOverlay: true, duration:3)
        Parsing().HostGateSubscriptionList(Language: self.language, UserId: user_Id, RoleId: roleId, AdminUserid: adminuserid)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateSubscriptionList), name: NSNotification.Name(rawValue: "HostGateSubscriptionList"), object: nil)
        
        
    }
    
    func dataNotFound(){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.sucriptionTableview.bounds.size.width, height: self.sucriptionTableview.bounds.size.height))
        noDataLabel.text = self.language == "en" ? "No Data Found" : "لاتوجد بيانات"
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        self.sucriptionTableview.backgroundView  = noDataLabel
        self.sucriptionTableview.separatorStyle  = .none
    }
    
    //MARK:- UITableView Delegate
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        var numOfSections: Int = 0
    //        if response.count>0
    //        {
    //            tableView.separatorStyle = .none
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubscriptionCell
        
        cell.activatelbl.text = language == "en" ? "Date of activate:" : "تاريخ التفعيل:"
        cell.expirylbl.text = language == "en" ? "Expiry date:" : "تاريخ انتهاء الصلاحية:"
        cell.count.text = language == "en" ? "No. of accounts" : "عدد الحسابات"
        cell.unused.text = language == "en" ? "No. of accounts unused": "عدد الحسابات غير المستخدمة"
        cell.plan_price.text = language == "en" ? "Price" : "السعر"
        cell.validity_month.text = language == "en" ? "Validity(month)" : "الصلاحية (شهر)"
        
        var dict = NSDictionary()
        dict = response.object(at: indexPath.row) as! NSDictionary
        
        var nameC:Int!
        nameC = dict.value(forKey: "no_account_unused") as? Int
        let strnameC = String(nameC)
        
        cell.unuserAcconylbl.text = strnameC
        
        //cell.nameuser.text = strname
        cell.dateLbl.text = dict.value(forKey: "date_activate") as? String
        cell.expDateLbl.text = dict.value(forKey: "expiry_date") as? String
        var name1:Int!
        name1 = dict.value(forKey: "no_account") as? Int
        let strname1 = String(name1)
        cell.countLbl.text = strname1
        var name2:Int!
        name2 = dict.value(forKey: "total_amount") as? Int
        let strname2 = String(name2)
        
        cell.priceLbl.text = "$" + strname2
        var name3:Int!
        name3 = dict.value(forKey: "duration") as? Int
        let strname3 = String(name3)
        cell.monthLbl.text = strname3
        
        if self.ChangeSts == 1 {
           cell.viewBtn.isHidden = false
           cell.renewBtn.isHidden = false
       }else {
          cell.viewBtn.isHidden = true
          cell.renewBtn.isHidden = true
       }
        
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(HandleTap(_:)), for: .touchUpInside)
        
        cell.renewBtn.tag = indexPath.row
        cell.renewBtn.addTarget(self, action: #selector(HandleTap1(_:)), for: .touchUpInside)
        return cell
    }
    
    
     @objc func HandleTap1(_ sender:UIButton) {
        
        
        
        var dict = NSDictionary()
        dict = self.response.object(at: sender.tag) as! NSDictionary
        
        var ToatlAmt = Int()
        ToatlAmt = dict.value(forKey:"total_amount") as! Int
        
        var Subid:Int!
        Subid = dict.value(forKey:"subscription_id") as? Int
        
        var cardnumnber:String!
        cardnumnber = dict.value(forKey: "card_last_four_digits") as? String
        
        let defaults = UserDefaults.standard
        defaults.set(cardnumnber, forKey: "CardNumber")
        defaults.synchronize()
        
        let nextview = PaytabPaymentView.intitiateFromNib()
        let model = BackModel()
        
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonOtherCardHandler = {
            model.closewithAnimation()
            var message:String!
            message = self.language == "en" ? "Are you sure want to renew with other card?" : "هل تريد بالتأكيد التجديد باستخدام بطاقة أخرى؟"
    
            var No:String!
            No = self.language == "en" ? "No" : "لا"
    
            var Yes:String!
            Yes = self.language == "en" ? "Yes" : "نعم"
    
            var Alert:String!
            Alert = "HostGates"
    
            let myAlert = UIAlertController(title: Alert, message:message, preferredStyle: UIAlertController.Style.alert);
            let okAction = UIAlertAction(title: No, style: UIAlertAction.Style.cancel, handler:nil)
            
            let sayhi = UIAlertAction(title: Yes, style: UIAlertAction.Style.default, handler:  { action in
                
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
                orderstr =  "ORDER" + self.random1 + self.random2 + self.random3
                
                let bundle = Bundle(url: Bundle.main.url(forResource: "Resources", withExtension: "bundle")!)
                self.initialSetupViewController = PTFWInitialSetupViewController.init(
                    bundle: bundle,
                    andWithViewFrame: self.view.frame,
                    andWithAmount: Float(ToatlAmt),
                    andWithCustomerTitle: self.fullname,
                    andWithCurrencyCode: "USD",
                    andWithTaxAmount: 0.0,
                    andWithSDKLanguage: "en",
                    andWithShippingAddress: self.Address,
                    andWithShippingCity: self.Address,
                    andWithShippingCountry: "EGY",
                    andWithShippingState: self.Address,
                    andWithShippingZIPCode: "302017",
                    andWithBillingAddress:self.Address,
                    andWithBillingCity: "Manama",
                    andWithBillingCountry: "EGY",
                    andWithBillingState: self.Address,
                    andWithBillingZIPCode: "302017",
                    andWithOrderID: orderstr,
                    andWithPhoneNumber: self.Mobile,
                    andWithCustomerEmail: self.email,
                    andIsTokenization:true,
                    andIsPreAuth: false,
                    andWithMerchantEmail: "h.adel@turnx.co",
                    andWithMerchantSecretKey: "Zns8LVkGFCxdFEALTmkrg722CV0VxMAx92FVY0CDC9RiOs3HOo84wb79674ETEc2HSYFSAiuJaMyCQgqfpvLACVHJZlDEyFlqD1i",
                    andWithAssigneeCode: "SDK",
                    andWithThemeColor:UIColor(displayP3Red: 22/255, green: 34/255, blue: 52/255, alpha: 1.0),
                    andIsThemeColorLight: false)
                
                
                self.initialSetupViewController.didReceiveBackButtonCallback = {
                    
                }
                
                self.initialSetupViewController.didStartPreparePaymentPage = {
                    // Start Prepare Payment Page
                    // Show loading indicator
                }
                self.initialSetupViewController.didFinishPreparePaymentPage = {
                    // Finish Prepare Payment Page
                    // Stop loading indicator
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
                        var trid: Int!
                        trid = Int(transactionID)
//                        self.showWaitOverlay()
                        GIFHUD.shared.show(withOverlay: true, duration:3)
                        Parsing().HostGateVerifyRenewPayment(Language: self.language, SubscriptionId: Subid, OrderID: orderstr, TranstionId: trid, PtTocken: token, PtEmail: tokenizedCustomerEmail, PtPass: tokenizedCustomerPassword)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateVerifyRenewPayment"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateVerifyPaymentAction), name: NSNotification.Name(rawValue: "HostGateVerifyRenewPayment"), object: nil)
                    }else {
                        SwAlert.showNoActionAlert(SwAlert().AppAlertTitle, message:self.language == "en" ? "Something went wrong. Please try again." : "هناك خطأ ما. حاول مرة اخرى." , buttonTitle: self.language == "en" ? "OK" : "حسنا")
                    }
                    
                    
                    
                }
                
                self.view.addSubview(self.initialSetupViewController.view)
                self.addChild(self.initialSetupViewController)
                
                self.initialSetupViewController.didMove(toParent: self)
            })
            
            myAlert.addAction(okAction);
            myAlert.addAction(sayhi);
            
            self.present(myAlert, animated: true, completion: nil)
            
        }
            
            nextview.buttonPayHandler = {
                model.closewithAnimation()
                var message:String!
                message = self.language == "en" ? "Are you sure want to renew with same card?" : "هل تريد بالتأكيد التجديد بنفس البطاقة؟"
                
                var No:String!
                No = self.language == "en" ? "No" : "لا"
                
                var Yes:String!
                Yes = self.language == "en" ? "Yes" : "نعم"
                
                var Alert:String!
                Alert = "HostGates"
                
                let myAlert = UIAlertController(title: Alert, message:message, preferredStyle: UIAlertController.Style.alert);
                let okAction = UIAlertAction(title: No, style: UIAlertAction.Style.cancel, handler:nil)
                
                let sayhi = UIAlertAction(title: Yes, style: UIAlertAction.Style.default, handler:  { action in
                    
//                    self.showWaitOverlay()
                    GIFHUD.shared.show(withOverlay: true, duration:3)
                    Parsing().HostGateRenewSubstription(Language: self.language, SubscriptionId: Subid)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateRenewSubstription"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateRenewPaymentAction), name: NSNotification.Name(rawValue: "HostGateRenewSubstription"), object: nil)
                    
                })
                
                myAlert.addAction(okAction);
                myAlert.addAction(sayhi);
                
                self.present(myAlert, animated: true, completion: nil)
                
            }
            
            model.show(view: nextview)
        
     }
    
    
    @objc func HandleTap(_ sender:UIButton) {
        var dict = NSDictionary()
        dict = response.object(at: sender.tag) as! NSDictionary
        var subId:Int!
        subId = dict.value(forKey: "subscription_id") as? Int
        var autorenew:Int!
        autorenew = dict.value(forKey: "auto_renewal") as? Int
        var noacc = Int()
        noacc = dict.value(forKey:"no_account") as! Int
        var noaccun = Int()
        noaccun = dict.value(forKey:"no_account_unused") as! Int
        var ToatlAmt = Int()
        ToatlAmt = dict.value(forKey:"total_amount") as! Int
        var Duration = Int()
        Duration = dict.value(forKey:"duration") as! Int
        var ExpDate = String()
        ExpDate = dict.value(forKey:"expiry_date") as! String
        var AcDate = String()
        AcDate = dict.value(forKey:"date_activate") as! String
        var PaymentStatus = String()
        PaymentStatus = dict.value(forKey: "payment_status") as! String
        
        let deafults = UserDefaults.standard
        deafults.set(noacc, forKey: "NOACC")
        deafults.set(noaccun, forKey: "NOACCUN")
        deafults.set(subId, forKey: "SUBID")
        deafults.set(ToatlAmt, forKey: "TLAMT")
        deafults.set(Duration, forKey: "DUA")
        deafults.set(ExpDate, forKey: "EXPDATE")
        deafults.set(AcDate, forKey: "ACDATE")
        deafults.set(autorenew, forKey: "AUTORENEW")
        defaults.set(PaymentStatus, forKey: "PAYMENTSTATUS")
        deafults.synchronize()
        
        
        let nextview = SubscriptionDetailView.intitiateFromNib()
        let model = BackModel()
        nextview.buttonCancelHandler = {
            model.closewithAnimation()
        }
        nextview.buttonDoneHandler = {
            //  model.closewithAnimation()
        }
        
        nextview.buttonDownloadInvoiceHandler = {
//            self.showWaitOverlay()
            GIFHUD.shared.show(withOverlay: true, duration:3)
            Parsing().HostGateDownloadInvoice(Language: self.language, UserId: self.user_Id, RoleId: self.roleId, AdminUserID: self.adminuserid, SunscrtionId: subId)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HostGateDownloadInvoice"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HostGateDownloadInvoice), name: NSNotification.Name(rawValue: "HostGateDownloadInvoice"), object: nil)
            
            model.closewithAnimation()
        }
        
        model.show(view: nextview)
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
    
    
    @IBAction func purchaseBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PurchaseMoreAccountViewController") as! PurchaseMoreAccountViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK:-DGLoclalization Delegate
extension SubscriptionViewController:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
